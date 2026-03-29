package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Borrowing;
import model.Book;
import model.User;
import service.BorrowingService;
import service.impl.BorrowingServiceImpl;

@WebServlet(name = "BorrowingServlet", urlPatterns = {"/borrow"})
public class BorrowingServlet extends HttpServlet {
    private final BorrowingService borrowingService = BorrowingServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":
                createGet(request, response);
                break;
            case "update": // MỚI: Hiển thị form sửa
                updateGet(request, response);
                break;
          
            case "delete":
                delete(request, response);
                break;
            default:
                displayAll(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createPost(request, response);
        } else if ("update".equals(action)) { // MỚI: Xử lý lưu dữ liệu sửa
            updatePost(request, response);
        } else {
            displayAll(request, response);
        }
    }
private void displayAll(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    // Lấy danh sách từ Service
    List<Borrowing> list = borrowingService.findAll();
    
    // Gửi sang JSP với tên "borrowings"
    request.setAttribute("borrowings", list); 
    request.getRequestDispatcher("/admin/borrow_list.jsp").forward(request, response);
}
    private void createGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/borrow_save.jsp").forward(request, response);
    }

   // 3. Xử lý lưu phiếu mượn mới (Đầy đủ thuộc tính)
    private void createPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form borrow_save.jsp
            int userCode = Integer.parseInt(request.getParameter("userCode"));
            int bookCode = Integer.parseInt(request.getParameter("bookCode"));
            String borrowDate = request.getParameter("borrowDate");
            String dueDate = request.getParameter("dueDate");
            String status = request.getParameter("status"); // Mặc định thường là "Đang mượn"

            // Tạo đối tượng model và đóng gói dữ liệu
            Borrowing br = new Borrowing();
            
            User user = new User();
            user.setUserCode(userCode);
            br.setUser(user);
            
            Book book = new Book();
            book.setBookCode(bookCode);
            br.setBook(book);
            
            br.setBorrowDate(borrowDate);
            br.setDueDate(dueDate);
            br.setStatus(status != null ? status : "Đang mượn");

            // Gọi service để xử lý (Service sẽ gọi DAO.addBorrowing và BookDAO.updateQuantity)
            borrowingService.add(br); 
            
            response.sendRedirect("borrow?msg=success");
        } catch (Exception e) {
            // Nếu lỗi (ví dụ sai định dạng ngày hoặc ép kiểu số), quay lại trang tạo và báo lỗi
            request.setAttribute("error", "Lỗi nhập liệu: " + e.getMessage());
            createGet(request, response);
        }
    }

    // 4. MỚI: Hiển thị dữ liệu cũ lên form Sửa
    private void updateGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Borrowing borrowing = borrowingService.findById(id); // Gọi hàm findById từ DAO
        request.setAttribute("borrowing", borrowing);
        request.getRequestDispatcher("/admin/borrow_update.jsp").forward(request, response);
    }

    // 5. MỚI: Xử lý cập nhật tất cả các trường
    private void updatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int borrowingCode = Integer.parseInt(request.getParameter("borrowingCode"));
            int userCode = Integer.parseInt(request.getParameter("userCode"));
            int bookCode = Integer.parseInt(request.getParameter("bookCode"));
            String borrowDate = request.getParameter("borrowDate");
            String dueDate = request.getParameter("dueDate");
            String status = request.getParameter("status");

            // Tạo đối tượng Borrowing mới để truyền vào hàm update all
            Borrowing br = new Borrowing();
            br.setBorrowingCode(borrowingCode);
            
            User user = new User();
            user.setUserCode(userCode);
            br.setUser(user);
            
            Book book = new Book();
            book.setBookCode(bookCode);
            br.setBook(book);
            
            br.setBorrowDate(borrowDate);
            br.setDueDate(dueDate);
            br.setStatus(status);

            borrowingService.update(br, borrowingCode); // Gọi hàm update all trường
            response.sendRedirect("borrow?msg=updated");
        } catch (Exception e) {
            response.sendRedirect("borrow?msg=error");
        }
    }


    private void delete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        borrowingService.delete(id);
        response.sendRedirect("borrow");
    }
}