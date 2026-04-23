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
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;
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
    private static final int PAGE_SIZE = 10;

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
        String keyword = trimToEmpty(request.getParameter("keyword"));
        String role = trimToEmpty(request.getParameter("role"));
        String startsWith = trimToEmpty(request.getParameter("startsWith")).toUpperCase();
        int page = parseInt(request.getParameter("page"), 1);

        List<User> list = keyword.isEmpty()
                ? userService.findAll()
                : userService.searchByName(keyword);

        if (!role.isEmpty()) {
            list = list.stream()
                    .filter(u -> u.getRole() != null && u.getRole().equalsIgnoreCase(role))
                    .collect(Collectors.toList());
        }

        if (!startsWith.isEmpty()) {
            list = list.stream()
                    .filter(u -> u.getFullName() != null && u.getFullName().toUpperCase().startsWith(startsWith))
                    .collect(Collectors.toList());
        }

        int totalItems = list.size();
        int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
        page = Math.max(1, Math.min(page, totalPages));
        int fromIndex = (page - 1) * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalItems);
        List<User> paged = totalItems == 0 ? List.of() : list.subList(fromIndex, toIndex);

        request.setAttribute("users", paged);
        request.setAttribute("keyword", keyword);
        request.setAttribute("role", role);
        request.setAttribute("startsWith", startsWith);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("totalItems", totalItems);
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
            fillReaderFields(request, u);

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
        u.setUserCode(userCode);
        fillReaderFields(request, u);

        // Gọi đúng hàm update(User e, int id) như bạn đã định nghĩa trong Service
        userService.update(u, userCode);
        
        // Chuyển hướng kèm thông báo thành công
        response.sendRedirect("users?msg=updated");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("users?msg=error");
    }
}

private void fillReaderFields(HttpServletRequest request, User user) {
    user.setBirthDate(request.getParameter("birthDate"));
    user.setPosition(request.getParameter("position"));
    user.setAddress(request.getParameter("address"));
    user.setIdentityNumber(request.getParameter("identityNumber"));
    user.setCardIssueDate(request.getParameter("cardIssueDate"));
    user.setCardExpiryDate(request.getParameter("cardExpiryDate"));
    user.setDepositAmount(parseBigDecimal(request.getParameter("depositAmount")));
    user.setMaxBorrowBooks(parseInt(request.getParameter("maxBorrowBooks"), 5));
}

private BigDecimal parseBigDecimal(String value) {
    if (value == null || value.trim().isEmpty()) {
        return BigDecimal.ZERO;
    }
    try {
        return new BigDecimal(value.trim());
    } catch (NumberFormatException e) {
        return BigDecimal.ZERO;
    }
}

private int parseInt(String value, int defaultValue) {
    if (value == null || value.trim().isEmpty()) {
        return defaultValue;
    }
    try {
        return Integer.parseInt(value.trim());
    } catch (NumberFormatException e) {
        return defaultValue;
    }
}

private String trimToEmpty(String value) {
    return value == null ? "" : value.trim();
}
}
