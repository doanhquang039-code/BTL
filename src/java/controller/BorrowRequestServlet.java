package controller;

import DAO.BookDAO;
import DAO.BorrowingDAO;
import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Book;
import model.Borrowing;
import model.User;
import service.BorrowingService;
import service.impl.BorrowingServiceImpl;

@WebServlet(name = "BorrowRequestServlet", urlPatterns = {"/borrow-request"})
public class BorrowRequestServlet extends HttpServlet {
    private final BorrowingService borrowingService = BorrowingServiceImpl.getInstance();
    private final BookDAO bookDAO = BookDAO.getInstance();
    private final BorrowingDAO borrowingDAO = BorrowingDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("userSession");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!"user".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/books?msg=chiDocGia");
            return;
        }

        int bookCode;
        try {
            bookCode = Integer.parseInt(request.getParameter("bookCode"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books?msg=khongHopLe");
            return;
        }

        Book book = bookDAO.findById(bookCode);
        if (book == null || book.getQuantity() <= 0) {
            response.sendRedirect(request.getContextPath() + "/books?msg=hetSach");
            return;
        }

        request.setAttribute("borrowDateDefault", LocalDate.now().toString());
        request.setAttribute("dueDateDefault", LocalDate.now().plusDays(14).toString());
        request.setAttribute("book", book);
        request.getRequestDispatcher("/user/borrow_request_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("userSession");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!"user".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/books?msg=chiDocGia");
            return;
        }

        int bookCode;
        try {
            bookCode = Integer.parseInt(request.getParameter("bookCode"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books?msg=khongHopLe");
            return;
        }

        Book book = bookDAO.findById(bookCode);
        if (book == null || book.getQuantity() <= 0) {
            response.sendRedirect(request.getContextPath() + "/books?msg=hetSach");
            return;
        }

        String confirm = request.getParameter("confirmRequest");
        String borrowDateRaw = request.getParameter("borrowDate");
        String dueDateRaw = request.getParameter("dueDate");
        String statusRaw = "Chờ duyệt";

        LocalDate borrowDate;
        LocalDate dueDate;
        try {
            borrowDate = LocalDate.parse(borrowDateRaw);
            dueDate = LocalDate.parse(dueDateRaw);
        } catch (Exception e) {
            request.setAttribute("borrowDateDefault", borrowDateRaw);
            request.setAttribute("dueDateDefault", dueDateRaw);
            request.setAttribute("book", book);
            request.setAttribute("errorMessage", "Ngày mượn hoặc hạn trả không hợp lệ.");
            request.getRequestDispatcher("/user/borrow_request_form.jsp").forward(request, response);
            return;
        }

        if (dueDate.isBefore(borrowDate)) {
            request.setAttribute("borrowDateDefault", borrowDateRaw);
            request.setAttribute("dueDateDefault", dueDateRaw);
            request.setAttribute("book", book);
            request.setAttribute("errorMessage", "Hạn trả phải bằng hoặc sau ngày mượn.");
            request.getRequestDispatcher("/user/borrow_request_form.jsp").forward(request, response);
            return;
        }

        if (!"yes".equals(confirm)) {
            request.setAttribute("borrowDateDefault", borrowDateRaw);
            request.setAttribute("dueDateDefault", dueDateRaw);
            request.setAttribute("book", book);
            request.setAttribute("errorMessage", "Vui lòng xác nhận thông tin trước khi gửi phiếu mượn.");
            request.getRequestDispatcher("/user/borrow_request_form.jsp").forward(request, response);
            return;
        }

        if (borrowingDAO.hasPendingRequest(user.getUserCode(), bookCode)) {
            response.sendRedirect(request.getContextPath() + "/books?msg=trungYeuCau");
            return;
        }

        Borrowing borrowing = new Borrowing();
        borrowing.setUser(user);
        borrowing.setBook(book);
        borrowing.setBorrowDate(borrowDate.toString());
        borrowing.setDueDate(dueDate.toString());
        borrowing.setStatus(statusRaw);
        borrowingService.requestBorrowBook(borrowing);
        response.sendRedirect(request.getContextPath() + "/books?msg=daGuiYeuCau");
    }
}
