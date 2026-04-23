package controller;

import DAO.BookDAO;
import DAO.BorrowingDAO;
import DAO.PenaltyDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ManagerReportServlet", urlPatterns = {"/manager-report"})
public class ManagerReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        request.setAttribute("pendingApprovals", BorrowingDAO.getInstance().countPendingApprovals());
        request.setAttribute("overdueBooks", PenaltyDAO.getInstance().countOverdueBooks());
        request.setAttribute("todayBorrows", BorrowingDAO.getInstance().countTodayBorrows());
        request.setAttribute("bookStats", BookDAO.getInstance().findBorrowStatistics());

        request.getRequestDispatcher("/manager/report.jsp").forward(request, response);
    }
}
