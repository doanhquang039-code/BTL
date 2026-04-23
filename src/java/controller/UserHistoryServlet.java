package controller;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.BorrowingDAO;
import model.Borrowing;
import model.User;
import service.BorrowingService;
import service.impl.BorrowingServiceImpl;

@WebServlet(name = "UserHistoryServlet", urlPatterns = {"/history"})
public class UserHistoryServlet extends HttpServlet {
    private final BorrowingDAO borrowingDAO = BorrowingDAO.getInstance();
    private final BorrowingService borrowingService = BorrowingServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("userSession");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            detail(request, response, user);
            return;
        }
        if ("returnForm".equals(action)) {
            showReturnForm(request, response, user);
            return;
        }

        request.setAttribute("borrowings", borrowingDAO.findByUserCode(user.getUserCode()));
        request.getRequestDispatcher("/user/history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("userSession");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("return".equals(action)) {
            returnBook(request, response, user);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/history");
    }

    private void detail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int borrowingCode = Integer.parseInt(request.getParameter("id"));
            Borrowing borrowing = borrowingDAO.findByIdAndUserCode(borrowingCode, user.getUserCode());
            if (borrowing == null) {
                response.sendRedirect(request.getContextPath() + "/history?msg=khongTimThay");
                return;
            }
            request.setAttribute("borrowing", borrowing);
            request.getRequestDispatcher("/user/borrow_detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/history?msg=khongHopLe");
        }
    }

    private void returnBook(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int borrowingCode = Integer.parseInt(request.getParameter("id"));
            Borrowing borrowing = borrowingDAO.findByIdAndUserCode(borrowingCode, user.getUserCode());
            if (borrowing == null) {
                response.sendRedirect(request.getContextPath() + "/history?msg=khongTimThay");
                return;
            }

            String status = borrowing.getStatus() == null ? "" : borrowing.getStatus().trim();
            if ("Đã trả".equalsIgnoreCase(status) || "Returned".equalsIgnoreCase(status)) {
                response.sendRedirect(request.getContextPath() + "/history?msg=daTra");
                return;
            }
            if ("Chờ duyệt trả".equalsIgnoreCase(status) || "ReturnPending".equalsIgnoreCase(status)) {
                response.sendRedirect(request.getContextPath() + "/history?msg=daGuiYeuCauTra");
                return;
            }

            String confirm = request.getParameter("confirmReturn");
            String returnDate = request.getParameter("returnDate");
            String statusInput = "Chờ duyệt trả";

            LocalDate parsedReturnDate;
            try {
                parsedReturnDate = LocalDate.parse(returnDate);
            } catch (Exception e) {
                request.setAttribute("borrowing", borrowing);
                request.setAttribute("returnDateDefault", returnDate);
                request.setAttribute("errorMessage", "Ngày trả không hợp lệ.");
                request.getRequestDispatcher("/user/return_form.jsp").forward(request, response);
                return;
            }

            try {
                LocalDate borrowDate = LocalDate.parse(borrowing.getBorrowDate());
                if (parsedReturnDate.isBefore(borrowDate)) {
                    request.setAttribute("borrowing", borrowing);
                    request.setAttribute("returnDateDefault", parsedReturnDate.toString());
                    request.setAttribute("errorMessage", "Ngày trả phải bằng hoặc sau ngày mượn.");
                    request.getRequestDispatcher("/user/return_form.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("borrowing", borrowing);
                request.setAttribute("returnDateDefault", parsedReturnDate.toString());
                request.setAttribute("errorMessage", "Không thể xác thực ngày mượn trong hệ thống.");
                request.getRequestDispatcher("/user/return_form.jsp").forward(request, response);
                return;
            }

            if (!"yes".equals(confirm)) {
                request.setAttribute("borrowing", borrowing);
                request.setAttribute("returnDateDefault", parsedReturnDate.toString());
                request.setAttribute("errorMessage", "Vui lòng xác nhận thông tin trước khi trả sách.");
                request.getRequestDispatcher("/user/return_form.jsp").forward(request, response);
                return;
            }

            borrowingService.returnBook(borrowingCode, parsedReturnDate.toString(), statusInput);
            response.sendRedirect(request.getContextPath() + "/history?msg=yeuCauTraThanhCong");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/history?msg=khongHopLe");
        }
    }

    private void showReturnForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int borrowingCode = Integer.parseInt(request.getParameter("id"));
            Borrowing borrowing = borrowingDAO.findByIdAndUserCode(borrowingCode, user.getUserCode());
            if (borrowing == null) {
                response.sendRedirect(request.getContextPath() + "/history?msg=khongTimThay");
                return;
            }
            request.setAttribute("returnDateDefault", LocalDate.now().toString());
            request.setAttribute("borrowing", borrowing);
            request.getRequestDispatcher("/user/return_form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/history?msg=khongHopLe");
        }
    }
}
