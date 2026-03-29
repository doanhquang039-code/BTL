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
import service.BookService;
import service.impl.BookServiceImpl;

/**
 *
 * @author admoi
 */
@WebServlet(name = "BookImportServlet", urlPatterns = {"/imports"})
public class BookImportServlet extends HttpServlet {
    private final BookService bookService = BookServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị lịch sử nhập kho
        request.getRequestDispatcher("/admin/import_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookCode = Integer.parseInt(request.getParameter("bookCode"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        bookService.updateStock(bookCode, quantity);
        response.sendRedirect("books"); // Sau khi nhập xong quay về trang danh sách sách
    }
}