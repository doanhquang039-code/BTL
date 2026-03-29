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
import service.ReservationService;
import service.impl.ReservationServiceImpl;

/**
 *
 * @author admoi
 */
@WebServlet(name = "ReservationServlet", urlPatterns = {"/reservations"})
public class ReservationServlet extends HttpServlet {
    private final ReservationService resService = ReservationServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("reservations", resService.findAll());
        request.getRequestDispatcher("/admin/reservation_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý khi user nhấn "Đặt trước"
        int userCode = Integer.parseInt(request.getParameter("userCode"));
        int bookCode = Integer.parseInt(request.getParameter("bookCode"));
        resService.add(userCode, bookCode);
        response.sendRedirect("books"); // Quay lại danh sách sách
    }
}
