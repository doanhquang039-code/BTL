package controller;

import DAO.BorrowingDAO;
import DAO.PenaltyDAO; // Giả định
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager-dash"})
public class ManagerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy dữ liệu thật từ Database qua DAO
        int pending = BorrowingDAO.getInstance().countPendingApprovals();
        int overdue = PenaltyDAO.getInstance().countOverdueBooks();
        int today = BorrowingDAO.getInstance().countTodayBorrows();

        // 2. Đẩy dữ liệu vào request attributes
        request.setAttribute("pendingApprovals", pending);
        request.setAttribute("overdueBooks", overdue);
        request.setAttribute("todayBorrows", today);

        // 3. Chuyển hướng đến file JSP nằm trong thư mục manager
        request.getRequestDispatcher("/manager/dashboard.jsp").forward(request, response);
    }
}