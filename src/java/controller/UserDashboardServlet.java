package controller;

import DAO.BorrowingDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "UserDashboardServlet", urlPatterns = {"/user-dashboard"})
public class UserDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("userSession");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setAttribute("userBorrows", BorrowingDAO.getInstance().findActiveByUserCode(user.getUserCode()));
        request.getRequestDispatcher("/user/dashboard.jsp").forward(request, response);
    }
}
