package controller;

import DAO.BookDAO;
import DAO.CategoryDAO;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Path;
import java.util.List;
import java.util.Comparator;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import model.Book;
import model.Category;
import model.User;
import service.impl.BookServiceImpl;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 100
)
@WebServlet(name = "BookServlet", urlPatterns = {"/books"})
public class BookServlet extends HttpServlet {
    private final BookServiceImpl bookService = BookServiceImpl.getInstance();
    private final BookDAO bookDAO = BookDAO.getInstance();
    private final CategoryDAO categoryDAO = CategoryDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String keyword = request.getParameter("keyword");
        User user = currentUser(request);
        if (keyword != null && !keyword.trim().isEmpty()) {
            displayBooks(request, response, bookDAO.searchByName(keyword));
            return;
        }
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "create":
                if (!requireAdmin(request, response)) return;
                request.setAttribute("categories", categoryDAO.findAll());
                request.getRequestDispatcher("/admin/book_save.jsp").forward(request, response);
                break;
            case "update":
                if (!requireAdmin(request, response)) return;
                showUpdateForm(request, response);
                break;
            case "delete":
                if (!requireAdmin(request, response)) return;
                deleteBook(request, response);
                break;
            default:
                if (canManageBooks(user)) {
                    request.setAttribute("categories", categoryDAO.findAll());
                    displayBooks(request, response, filterManagedBooks(request, bookService.findAll()));
                } else {
                    displayBooks(request, response, bookService.findAll());
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("search".equals(action)) {
            searchBooks(request, response);
        } else if ("create".equals(action)) {
            if (!requireAdmin(request, response)) return;
            saveBook(request, response, true);
        } else if ("update".equals(action)) {
            if (!requireAdmin(request, response)) return;
            saveBook(request, response, false);
        } else {
            displayBooks(request, response, bookService.findAll());
        }
    }

    private void displayBooks(HttpServletRequest request, HttpServletResponse response, List<Book> books)
            throws ServletException, IOException {
        request.setAttribute("books", books);
        if (canManageBooks(currentUser(request))) {
            request.getRequestDispatcher("/admin/book_list.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/user/book_list.jsp").forward(request, response);
        }
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("book", bookDAO.findById(id));
        request.setAttribute("categories", categoryDAO.findAll());
        request.getRequestDispatcher("/admin/book_save.jsp").forward(request, response);
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        bookDAO.delete(id);
        boolean deleted = bookDAO.findById(id) == null;
        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/books?msg=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/books?msg=deleteFailed");
        }
    }

    private void searchBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("name");
        displayBooks(request, response, bookDAO.searchByName(keyword));
    }

    private void saveBook(HttpServletRequest request, HttpServletResponse response, boolean isCreate)
            throws ServletException, IOException {
        Book book = new Book();
        book.setTitle(request.getParameter("title"));
        book.setAuthor(request.getParameter("author"));
        book.setPublisher(request.getParameter("publisher"));
        book.setPublishYear(request.getParameter("publishYear"));
        book.setPrice(parseBigDecimal(request.getParameter("price")));
        book.setPageCount(parseInt(request.getParameter("pageCount")));
        book.setShelfLocation(request.getParameter("shelfLocation"));
        book.setQuantity(Integer.parseInt(request.getParameter("quantity")));

        Category category = new Category();
        category.setCategoryCode(Integer.parseInt(request.getParameter("categoryCode")));
        book.setCategory(category);

        String imagePath = saveImage(request.getPart("image"));
        if (!isCreate && (imagePath == null || imagePath.isEmpty())) {
            imagePath = request.getParameter("oldImage");
        }
        book.setImage(imagePath);

        if (isCreate) {
            bookDAO.add(book);
        } else {
            int id = Integer.parseInt(request.getParameter("id"));
            bookDAO.update(book, id);
        }

        response.sendRedirect(request.getContextPath() + "/books");
    }

    private String saveImage(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSubmittedFileName() == null || imagePart.getSubmittedFileName().isEmpty()) {
            return null;
        }

        String uploadDir = getServletContext().getRealPath("/uploads");
        if (uploadDir == null || uploadDir.trim().isEmpty()) {
            uploadDir = getServletContext().getRealPath("/") + "uploads";
        }
        if (uploadDir == null || uploadDir.trim().isEmpty()) {
            return null;
        }
        if (!uploadDir.endsWith(File.separator)) {
            uploadDir += File.separator;
        }
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        String fileName = Path.of(imagePart.getSubmittedFileName()).getFileName().toString();
        fileName = System.currentTimeMillis() + "_" + fileName;

        imagePart.write(uploadDir + fileName);
        return "uploads/" + fileName;
    }

    private User currentUser(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("userSession");
    }

    private boolean canManageBooks(User user) {
        return user != null
                && ("admin".equalsIgnoreCase(user.getRole())
                || "manager".equalsIgnoreCase(user.getRole()));
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (canManageBooks(currentUser(request))) {
            return true;
        }
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return false;
    }

    private BigDecimal parseBigDecimal(String value) {
        if (value == null || value.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

    private int parseInt(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private Integer parseIntegerOrNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private List<Book> filterManagedBooks(HttpServletRequest request, List<Book> books) {
        String filterKeyword = trim(request.getParameter("filterKeyword")).toLowerCase();
        Integer minQty = parseIntegerOrNull(request.getParameter("minQty"));
        Integer maxQty = parseIntegerOrNull(request.getParameter("maxQty"));
        String stockStatus = trim(request.getParameter("stockStatus"));
        Integer categoryCode = parseIntegerOrNull(request.getParameter("categoryCode"));
        String qtySort = trim(request.getParameter("qtySort"));

        request.setAttribute("filterKeyword", request.getParameter("filterKeyword"));
        request.setAttribute("minQty", request.getParameter("minQty"));
        request.setAttribute("maxQty", request.getParameter("maxQty"));
        request.setAttribute("stockStatus", stockStatus);
        request.setAttribute("categoryCode", request.getParameter("categoryCode"));
        request.setAttribute("qtySort", qtySort);

        List<Book> filtered = books.stream()
                .filter(book -> filterKeyword.isEmpty()
                        || containsIgnoreCase(book.getTitle(), filterKeyword)
                        || containsIgnoreCase(book.getAuthor(), filterKeyword)
                        || containsIgnoreCase(book.getPublisher(), filterKeyword)
                        || containsIgnoreCase(book.getPublishYear(), filterKeyword)
                        || (book.getCategory() != null && containsIgnoreCase(book.getCategory().getName(), filterKeyword)))
                .filter(book -> categoryCode == null
                        || (book.getCategory() != null && book.getCategory().getCategoryCode() == categoryCode))
                .filter(book -> minQty == null || book.getQuantity() >= minQty)
                .filter(book -> maxQty == null || book.getQuantity() <= maxQty)
                .filter(book -> !"inStock".equalsIgnoreCase(stockStatus) || book.getQuantity() > 0)
                .filter(book -> !"outOfStock".equalsIgnoreCase(stockStatus) || book.getQuantity() <= 0)
                .collect(Collectors.toList());

        if ("asc".equalsIgnoreCase(qtySort)) {
            filtered.sort(Comparator.comparingInt(Book::getQuantity));
        } else if ("desc".equalsIgnoreCase(qtySort)) {
            filtered.sort(Comparator.comparingInt(Book::getQuantity).reversed());
        }
        return filtered;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean containsIgnoreCase(String source, String keyword) {
        return source != null && source.toLowerCase().contains(keyword);
    }
}
