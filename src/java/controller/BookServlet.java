/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;
import DAO.BookDAO;
import DAO.CategoryDAO;
import java.io.File;
import javax.servlet.annotation.MultipartConfig;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import model.Book;
import model.Category;
import model.User;
import service.impl.BookServiceImpl;
import service.impl.CategoryServiceImpl;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
@WebServlet(name = "BookServlet", urlPatterns = {"/books"})
public class BookServlet extends HttpServlet {
    private final BookServiceImpl bookService = BookServiceImpl.getInstance();
    private final CategoryServiceImpl categoryService = CategoryServiceImpl.getInstance();
private final BookDAO bookDAO = BookDAO.getInstance();
    private final CategoryDAO categoryDAO = CategoryDAO.getInstance();
    

 

    private void displayAllBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book> books = bookService.findAll();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/admin/book_list.jsp").forward(request, response);
        // Trong BookServlet.java hàm doGet hoặc displayAll
User user = (User) request.getSession().getAttribute("userSession");
if (user.getRole().equals("admin")) {
    request.getRequestDispatcher("/admin/book_list.jsp").forward(request, response);
} else {
    request.getRequestDispatcher("/user/book_list.jsp").forward(request, response);
}
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cần lấy list categories để user chọn khi thêm sách mới
        List<Category> categories = categoryService.findAll();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/book_form.jsp").forward(request, response);
    }

    private void createBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        int categoryId = Integer.parseInt(request.getParameter("categoryCode"));
        String year = request.getParameter("publishYear");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Book book = new Book();
        book.setTitle(title);
        book.setAuthor(author);
        book.setPublishYear(year);
        book.setQuantity(quantity);
        
        Category cat = new Category();
        cat.setCategoryCode(categoryId);
        book.setCategory(cat);

        bookService.add(book);
        response.sendRedirect(request.getContextPath() + "/books");
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        bookService.delete(id);
        response.sendRedirect(request.getContextPath() + "/books");
    }
    
    // updatePost và updateGet làm tương tự như CategoryServlet của bạn...
// 1. Hàm hiển thị form chỉnh sửa (GET)
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Book existingBook = bookDAO.findById(id); // Lấy thông tin sách hiện tại
            List<Category> categories = categoryDAO.findAll(); // Lấy list danh mục để chọn lại

            request.setAttribute("book", existingBook);
            request.setAttribute("categories", categories);
            
            // Forward tới trang save.jsp (dùng chung cho cả thêm và sửa)
            request.getRequestDispatcher("/admin/book_save.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }

    // 2. Hàm xử lý cập nhật sách (POST)
    private void updateBook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        int categoryCode = Integer.parseInt(request.getParameter("categoryCode"));
        String publishYear = request.getParameter("publishYear");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Xử lý ảnh:
        Part filePart = request.getPart("image");
        String imagePath = saveImage(filePart);

        // LOGIC QUAN TRỌNG: Nếu người dùng không chọn ảnh mới khi sửa, 
        // ta lấy lại đường dẫn ảnh cũ từ input hidden 'oldImage'
        if (imagePath == null || imagePath.isEmpty()) {
            imagePath = request.getParameter("oldImage");
        }

        Book book = new Book();
        book.setTitle(title);
        book.setAuthor(author);
        book.setPublishYear(publishYear);
        book.setQuantity(quantity);
        book.setImage(imagePath); // imagePath bây giờ chắc chắn không null
        
        Category cat = new Category();
        cat.setCategoryCode(categoryCode);
        book.setCategory(cat);

        bookDAO.update(book, id);
        response.sendRedirect(request.getContextPath() + "/books");
    }

    // 3. Hàm tìm kiếm sách (POST)
    private void searchBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("name"); // Tên từ ô input search
        List<Book> foundBooks = bookDAO.searchByName(keyword);
        
        request.setAttribute("books", foundBooks);
        // Sau khi tìm xong, hiển thị kết quả trên chính trang list.jsp
        request.getRequestDispatcher("/admin/book_list.jsp").forward(request, response);
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":
                request.setAttribute("categories", categoryDAO.findAll());
                request.getRequestDispatcher("/admin/book_save.jsp").forward(request, response);
                break;
            case "update":
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("book", bookDAO.findById(id));
                request.setAttribute("categories", categoryDAO.findAll());
                request.getRequestDispatcher("/admin/book_save.jsp").forward(request, response);
                break;
            case "delete":
                int delId = Integer.parseInt(request.getParameter("id"));
                bookDAO.delete(delId);
                response.sendRedirect(request.getContextPath() + "/books");
                break;
            default:
              List<Book> allBooks = bookDAO.findAll();
            request.setAttribute("books", allBooks); 
            request.getRequestDispatcher("/admin/book_list.jsp").forward(request, response);
            break;
        }
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");

    if ("search".equals(action)) {
        // Nút tìm kiếm chỉ hoạt động khi bạn nhấn SUBMIT form
        searchBooks(request, response); 
    } else if ("create".equals(action)) {
        processAddOrUpdate(request, response, true);
    } else if ("update".equals(action)) {
        processAddOrUpdate(request, response, false);
    }
}

    private void processAddOrUpdate(HttpServletRequest request, HttpServletResponse response, boolean isCreate) 
            throws ServletException, IOException {
        
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        int categoryCode = Integer.parseInt(request.getParameter("categoryCode"));
        String publishYear = request.getParameter("publishYear");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Xử lý upload ảnh
        Part filePart = request.getPart("image");
        String imagePath = saveImage(filePart);

        // Nếu là update và không chọn ảnh mới, giữ lại ảnh cũ
        if (!isCreate && (imagePath == null || imagePath.isEmpty())) {
            imagePath = request.getParameter("oldImage");
        }

        Book book = new Book();
        book.setTitle(title);
        book.setAuthor(author);
        book.setPublishYear(publishYear);
        book.setQuantity(quantity);
        book.setImage(imagePath);
        
        Category cat = new Category();
        cat.setCategoryCode(categoryCode);
        book.setCategory(cat);

        if (isCreate) {
            bookDAO.add(book);
        } else {
            int id = Integer.parseInt(request.getParameter("id"));
            bookDAO.update(book, id);
        }

        response.sendRedirect(request.getContextPath() + "/books");
    }

    private String saveImage(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSubmittedFileName().isEmpty()) {
            return null;
        }
        // Tạo thư mục uploads trong thư mục build của server
        String uploadDir = getServletContext().getRealPath("/") + "uploads" + File.separator;
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        String fileName = Path.of(imagePart.getSubmittedFileName()).getFileName().toString();
        // Đổi tên file để tránh trùng lặp (tùy chọn)
        fileName = System.currentTimeMillis() + "_" + fileName;
        
        imagePart.write(uploadDir + fileName);
        return "uploads/" + fileName; 
    }

}