/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;
import service.impl.UserServiceImpl;

/**
 *
 * @author admoi
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private final UserServiceImpl userService = UserServiceImpl.getInstance();
private final UserDAO userDAO = UserDAO.getInstance();
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    
    String fullname = request.getParameter("fullname");
    String user = request.getParameter("username");
    String pass = request.getParameter("password");

    // 1. Kiểm tra mật khẩu đủ 8 ký tự
    if (pass == null || pass.length() < 8) {
        request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự!");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }

    // 2. Kiểm tra tài khoản đã tồn tại chưa
    if (userDAO.checkUsernameExists(user)) {
        request.setAttribute("error", "Tên đăng nhập này đã tồn tại!");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }

    // 3. Nếu mọi thứ hợp lệ thì tiến hành đăng ký
    User newUser = new User();
    newUser.setFullName(fullname);
    newUser.setUsername(user);
    newUser.setPassword(pass);

    userDAO.add(newUser); // Lưu vào DB (role mặc định là user)
    
    // Gửi thông báo thành công sang trang Login
    request.setAttribute("message", "Đăng ký thành công! Bạn có thể đăng nhập ngay.");
    request.getRequestDispatcher("login.jsp").forward(request, response);
}
}