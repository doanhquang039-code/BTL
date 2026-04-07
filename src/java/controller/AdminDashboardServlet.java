package controller;

import DAO.BookDAO;
import DAO.BookImportDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin-dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy dữ liệu thực tế từ các hàm count bạn đã viết trong DAO
        int totalBooks = BookDAO.getInstance().countTotalBooksInStock();
        int totalImports = BookImportDAO.getInstance().countImportsThisMonth();
        
        // Giả sử các con số khác (vì bạn chưa đưa code UserDAO)
        int totalUsers = 450; 
        int activePenalties = 12;

        // 2. Gán vào request với đúng tên biến bạn dùng ở JSP (${totalBooks})
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalImports", totalImports);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activePenalties", activePenalties);

        // 3. Forward sang trang JSP trong thư mục admin
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}