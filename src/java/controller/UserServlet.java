/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


/**
 *
 * @author admoi
 */
package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;
import service.UserService;
import service.impl.UserServiceImpl;

@WebServlet(name = "UserServlet", urlPatterns = {"/users"})
public class UserServlet extends HttpServlet {
    private final UserService userService = UserServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":
                request.getRequestDispatcher("/admin/user_save.jsp").forward(request, response);
                break;
            case "update":
                // Lấy id từ URL (ví dụ: users?action=update&id=1001)
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    int idUpdate = Integer.parseInt(idParam);
                    User userUpdate = userService.findById(idUpdate);
                    request.setAttribute("user", userUpdate);
                    request.getRequestDispatcher("/admin/user_update.jsp").forward(request, response);
                } else {
                    response.sendRedirect("users");
                }
                break;
            case "delete":
                int idDelete = Integer.parseInt(request.getParameter("id"));
                userService.delete(idDelete);
                response.sendRedirect("users?msg=deleted");
                break;
            default:
                displayAll(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createPost(request, response);
        } else if ("update".equals(action)) {
            updatePost(request, response);
        } else {
            displayAll(request, response);
        }
    }

    private void displayAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> list = userService.findAll();
        request.setAttribute("users", list);
        request.getRequestDispatcher("/admin/user_list.jsp").forward(request, response);
    }

    private void createPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User u = new User();
            u.setUsername(request.getParameter("username"));
            u.setPassword(request.getParameter("password"));
            u.setFullName(request.getParameter("fullName"));
            u.setRole(request.getParameter("role"));

            userService.add(u);
            response.sendRedirect("users?msg=success");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi thêm người dùng: " + e.getMessage());
            request.getRequestDispatcher("/admin/user_save.jsp").forward(request, response);
        }
    }
private void updatePost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Lấy mã số từ thẻ hidden
        int userCode = Integer.parseInt(request.getParameter("userCode"));
        
        // Lấy đầy đủ các thuộc tính từ form bạn đã thiết kế
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String password = request.getParameter("password");
        String username = request.getParameter("username"); // Lấy để đủ đối tượng dù readonly

        // Khởi tạo đối tượng User với đầy đủ thông tin
        User u = new User();
        u.setFullName(fullName);
        u.setRole(role);
        u.setPassword(password);
        u.setUsername(username);

        // Gọi đúng hàm update(User e, int id) như bạn đã định nghĩa trong Service
        userService.update(u, userCode);
        
        // Chuyển hướng kèm thông báo thành công
        response.sendRedirect("users?msg=updated");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("users?msg=error");
    }
}
}