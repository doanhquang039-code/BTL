/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebFilter(urlPatterns = {"/admin/*", "/books", "/categories"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("userSession") : null;

        if (user == null) {
            // Chưa đăng nhập -> đá về trang login
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        } else if (!"admin".equalsIgnoreCase(user.getRole())) {
            // Đã đăng nhập nhưng không phải admin mà dám vào trang quản lý
            res.sendRedirect(req.getContextPath() + "/access-denied.jsp");
        } else {
            // Hợp lệ -> cho đi tiếp
            chain.doFilter(request, response);
        }
    }
}