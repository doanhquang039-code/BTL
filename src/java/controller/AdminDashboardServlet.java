package controller;

import DAO.BookDAO;
import DAO.BookImportDAO;
import DAO.CategoryDAO;
import DAO.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Gọi DAO lấy số liệu thật
        int totalBooks = BookDAO.getInstance().countBookTitles();
        int totalUsers = UserDAO.getInstance().countAll(); 
        int totalCategories = CategoryDAO.getInstance().countAll();

        // Gán dữ liệu vào request
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalCategories", totalCategories);

        // Chuyển hướng sang trang JSP
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

}