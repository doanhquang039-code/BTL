package controller;

import DAO.BorrowingDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Borrowing;
import model.User;
import service.BorrowingService;
import service.impl.BorrowingServiceImpl;

@WebServlet(name = "ApprovalServlet", urlPatterns = {"/approvals"})
public class ApprovalServlet extends HttpServlet {
    private final BorrowingService borrowingService = BorrowingServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("userSession");
        String role = user == null || user.getRole() == null ? "" : user.getRole().trim().toLowerCase();
        boolean canProcess = "manager".equals(role);

        String action = request.getParameter("action");
        String idRaw = request.getParameter("id");

        if (action != null && idRaw != null) {
            try {
                int id = Integer.parseInt(idRaw);
                Borrowing borrowing = BorrowingDAO.getInstance().findById(id);
                String currentStatus = borrowing == null ? null : borrowing.getStatus();
                if ("approve".equals(action)) {
                    if (!canProcess) {
                        response.sendRedirect("approvals?msg=chiManager");
                        return;
                    }
                    if ("Chờ duyệt trả".equalsIgnoreCase(currentStatus) || "ReturnPending".equalsIgnoreCase(currentStatus)) {
                        borrowingService.approveReturnRequest(id);
                    } else {
                        borrowingService.approveBorrowRequest(id);
                    }
                    response.sendRedirect("approvals?msg=daDuyet");
                    return;
                }
                if ("reject".equals(action)) {
                    if (!canProcess) {
                        response.sendRedirect("approvals?msg=chiManager");
                        return;
                    }
                    if ("Chờ duyệt trả".equalsIgnoreCase(currentStatus) || "ReturnPending".equalsIgnoreCase(currentStatus)) {
                        borrowingService.rejectReturnRequest(id);
                    } else {
                        borrowingService.rejectBorrowRequest(id);
                    }
                    response.sendRedirect("approvals?msg=tuChoi");
                    return;
                }
                if ("detail".equals(action)) {
                    request.setAttribute("borrowingDetail", borrowingService.findDetailById(id));
                    request.setAttribute("backUrl", request.getContextPath() + "/approvals");
                    request.getRequestDispatcher("/manager/approval_detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("approvals?msg=khongHopLe");
                return;
            }
        }

        request.setAttribute("canProcess", canProcess);
        request.setAttribute("requests", BorrowingDAO.getInstance().findPendingRequests());
        request.getRequestDispatcher("/manager/approvals.jsp").forward(request, response);
    }
}
