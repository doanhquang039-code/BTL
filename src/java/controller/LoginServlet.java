package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;
import service.impl.UserServiceImpl;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private final UserServiceImpl userService = UserServiceImpl.getInstance();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User account = userService.login(username, password);

        if (account == null) {
            request.setAttribute("error", "Sai tai khoan hoac mat khau!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("userSession", account);

        String role = account.getRole() == null ? "user" : account.getRole();
        if ("admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        } else if ("manager".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/manager-dash");
        } else if ("user".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/user-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/index.html");
        }
    }
}
