package controller;

import DAO.BookDAO;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Book;
import model.BookImport;
import service.BookImportService;
import service.impl.BookImportServiceImpl;
import service.BookService;
import service.impl.BookServiceImpl;

@WebServlet(name = "BookImportServlet", urlPatterns = {"/imports"})
public class BookImportServlet extends HttpServlet {
    private final BookImportService importService = BookImportServiceImpl.getInstance();
    private final BookService bookService = BookServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                prepareCreate(request, response);
                break;
            case "update":
                prepareUpdate(request, response);
                break;
            case "delete":
                executeDelete(request, response);
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
            executeCreate(request, response);
        } else if ("update".equals(action)) {
            executeUpdate(request, response);
        }
    }

    // --- CÁC HÀM HỖ TRỢ GET ---

    private void displayAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<BookImport> list = importService.findAll();
        request.setAttribute("imports", list);
        request.getRequestDispatcher("/admin/import_list.jsp").forward(request, response);
    }

    private void prepareCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book> books = bookService.findAll();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/admin/import_save.jsp").forward(request, response);
    }

    private void prepareUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        BookImport bi = importService.findById(id);
        List<Book> books = bookService.findAll();
        
        request.setAttribute("importItem", bi);
        request.setAttribute("books", books);
        request.getRequestDispatcher("/admin/import_update.jsp").forward(request, response);
    }

  // Trong BookImportServlet.java
private void executeCreate(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    try {
        BookImport bi = mapRequestToEntity(request);
        
        // 1. Luu lich su vao bang book_imports
        importService.add(bi); 
        
        // 2. Cap nhat Books: Tang quantity va tang ca total_imported
        // Su dung instance cua BookDAO hoac thong qua BookService neu ban da khai bao
        BookDAO.getInstance().updateStockAfterImport(bi.getBook().getBookCode(), bi.getImportQuantity());
        
        // 3. Quay ve trang danh sach lich su nhap kho
        response.sendRedirect("imports?msg=success");
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("imports?action=create&msg=error");
    }
}
private void executeUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
        int id = Integer.parseInt(request.getParameter("importId"));
        BookImport oldImport = importService.findById(id);
        
        if (oldImport != null) {
            int oldQty = oldImport.getImportQuantity();
            BookImport newImport = mapRequestToEntity(request); // Lấy số lượng mới từ form
            int newQty = newImport.getImportQuantity();
            
            // 1. Cập nhật bảng lịch sử nhập
            newImport.setImportId(id);
            importService.update(newImport, id);
            
            // 2. Cập nhật bảng Books: Tính chênh lệch (Mới - Cũ)
            int diff = newQty - oldQty;
            BookDAO.getInstance().updateFullStock(newImport.getBook().getBookCode(), diff);
        }
        response.sendRedirect("imports?msg=updated");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("imports?msg=error");
    }
}

private void executeDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        BookImport bi = importService.findById(id);
        
        if (bi != null) {
            // Trừ đi số lượng đã nhập trong cả tồn kho và tổng lịch sử (truyền số âm)
            BookDAO.getInstance().updateFullStock(bi.getBook().getBookCode(), -bi.getImportQuantity());
            
            // Xóa phiếu
            importService.delete(id);
        }
        response.sendRedirect("imports?msg=deleted");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("imports?msg=error");
    }
}
    private BookImport mapRequestToEntity(HttpServletRequest request) {
    BookImport bi = new BookImport();
    Book b = new Book();
    b.setBookCode(Integer.parseInt(request.getParameter("bookCode")));
    bi.setBook(b);
    bi.setImportQuantity(Integer.parseInt(request.getParameter("quantity")));
    bi.setImportedBy(request.getParameter("importedBy"));
    
    String dateStr = request.getParameter("importDate");
    if (dateStr == null || dateStr.isEmpty()) {
        // Nếu trống, lấy thời gian hiện tại chính xác đến từng giây
        bi.setImportDate(new java.sql.Timestamp(System.currentTimeMillis()));
    } else {
        try {
            // HTML5 datetime-local gửi về: yyyy-MM-ddTHH:mm
            // Chuyển sang định dạng SQL: yyyy-MM-dd HH:mm:00
            String formattedDate = dateStr.replace("T", " ") + ":00";
            bi.setImportDate(java.sql.Timestamp.valueOf(formattedDate));
        } catch (Exception e) {
            bi.setImportDate(new java.sql.Timestamp(System.currentTimeMillis()));
        }
    }
    return bi;
}
}