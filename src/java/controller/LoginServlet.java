/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        User account = userService.login(user, pass);

        if (account != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userSession", account);

            // Phân quyền điều hướng
            String role = account.getRole();
            if (role.equals("admin")) {
                response.sendRedirect(request.getContextPath() + "/admin/book_list.jsp");
            } else if (role.equals("manager")) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp");
            }
                else if (role.equals("user")) {
                response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.html");
            }
        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}