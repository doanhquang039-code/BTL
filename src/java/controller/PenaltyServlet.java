/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.io.IOException;
import java.math.BigDecimal; // Sử dụng BigDecimal cho tiền tệ
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Penalty;
import model.User;
import model.Borrowing;
import service.PenaltyService;
import service.impl.PenaltyServiceImpl;

@WebServlet(name = "PenaltyServlet", urlPatterns = {"/penalties"})
public class PenaltyServlet extends HttpServlet {
    private final PenaltyService penaltyService = PenaltyServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":
                request.getRequestDispatcher("/admin/penalty_save.jsp").forward(request, response);
                break;
            case "update":
                int idUpdate = Integer.parseInt(request.getParameter("id"));
                Penalty p = penaltyService.findById(idUpdate);
                request.setAttribute("penalty", p);
                request.getRequestDispatcher("/admin/penalty_update.jsp").forward(request, response);
                break;
            case "delete":
                int idDelete = Integer.parseInt(request.getParameter("id"));
                penaltyService.delete(idDelete);
                response.sendRedirect("penalties");
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
        List<Penalty> list = penaltyService.findAll();
        request.setAttribute("penalties", list);
        request.getRequestDispatcher("/admin/penalty_list.jsp").forward(request, response);
    }

    private void createPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Penalty p = new Penalty();
            
            // Mã người dùng
            User u = new User();
            u.setUserCode(Integer.parseInt(request.getParameter("userCode")));
            p.setUser(u);
            
            // Mã phiếu mượn
            Borrowing br = new Borrowing();
            br.setBorrowingCode(Integer.parseInt(request.getParameter("borrowingCode")));
            p.setBorrowing(br);
            
            // Xử lý BigDecimal cho tiền tệ (Cột amount)
            String amountStr = request.getParameter("amount");
            p.setAmount(new BigDecimal(amountStr));
            
            p.setReason(request.getParameter("reason")); // Lý do
            p.setStatus(request.getParameter("status")); // Trạng thái

            penaltyService.add(p);
            response.sendRedirect("penalties?msg=success");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/penalty_save.jsp").forward(request, response);
        }
    }
private void updatePost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int penaltyCode = Integer.parseInt(request.getParameter("penaltyCode"));
        int userCode = Integer.parseInt(request.getParameter("userCode"));
        
        // Xử lý borrowingCode: Nếu trống thì để 0 hoặc giá trị mặc định
        String brCodeRaw = request.getParameter("borrowingCode");
        int borrowingCode = (brCodeRaw != null && !brCodeRaw.isEmpty()) ? Integer.parseInt(brCodeRaw) : 0;
        
        // Làm sạch chuỗi tiền tệ trước khi chuyển sang BigDecimal
        String amountStr = request.getParameter("amount").replaceAll("[^\\d.]", ""); 
        
        Penalty p = new Penalty();
        p.setPenaltyCode(penaltyCode);
        
        User u = new User();
        u.setUserCode(userCode);
        p.setUser(u);
        
        Borrowing br = new Borrowing();
        br.setBorrowingCode(borrowingCode);
        p.setBorrowing(br);
        
        p.setAmount(new java.math.BigDecimal(amountStr));
        p.setReason(request.getParameter("reason"));
        p.setStatus(request.getParameter("status"));

        penaltyService.update(p, penaltyCode);
        response.sendRedirect("penalties?msg=updated");
    } catch (Exception e) {
        System.out.println("LOI UPDATE: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("penalties?msg=error");
    }
}
}