package controller;

import DAO.BorrowingDAO;
import DAO.PenaltyDAO; // Giả định
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Borrowing;

@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager-dash"})
public class ManagerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pending = BorrowingDAO.getInstance().countPendingApprovals();
        int overdue = PenaltyDAO.getInstance().countOverdueBooks();
        int today = BorrowingDAO.getInstance().countTodayBorrows();
        List<Borrowing> latestRequests = BorrowingDAO.getInstance().findPendingRequests();

        if ("1".equals(request.getParameter("ajax"))) {
            writeAjaxResponse(response, pending, overdue, today, latestRequests);
            return;
        }

        request.setAttribute("pendingApprovals", pending);
        request.setAttribute("overdueBooks", overdue);
        request.setAttribute("todayBorrows", today);
        request.setAttribute("latestRequests", latestRequests);
        request.getRequestDispatcher("/manager/dashboard.jsp").forward(request, response);
    }

    private void writeAjaxResponse(HttpServletResponse response, int pending, int overdue, int today,
            List<Borrowing> latestRequests) throws IOException {
        response.setContentType("application/json; charset=UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"pendingApprovals\":").append(pending).append(",");
        json.append("\"overdueBooks\":").append(overdue).append(",");
        json.append("\"todayBorrows\":").append(today).append(",");
        json.append("\"latestRequests\":[");

        for (int i = 0; i < latestRequests.size(); i++) {
            Borrowing item = latestRequests.get(i);
            if (i > 0) {
                json.append(",");
            }

            String fullName = item.getUser() != null ? item.getUser().getFullName() : "";
            String userCode = item.getUser() != null ? String.valueOf(item.getUser().getUserCode()) : "";
            String bookTitle = item.getBook() != null ? item.getBook().getTitle() : "";
            String status = item.getStatus() != null ? item.getStatus() : "";
            String borrowDate = item.getBorrowDate() != null ? item.getBorrowDate() : "";

            json.append("{");
            json.append("\"borrowingCode\":").append(item.getBorrowingCode()).append(",");
            json.append("\"fullName\":\"").append(escapeJson(fullName)).append("\",");
            json.append("\"userCode\":\"").append(escapeJson(userCode)).append("\",");
            json.append("\"bookTitle\":\"").append(escapeJson(bookTitle)).append("\",");
            json.append("\"status\":\"").append(escapeJson(status)).append("\",");
            json.append("\"borrowDate\":\"").append(escapeJson(borrowDate)).append("\"");
            json.append("}");
        }

        json.append("]}");
        response.getWriter().write(json.toString());
    }

    private String escapeJson(String value) {
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "")
                .replace("\n", "\\n");
    }
}
