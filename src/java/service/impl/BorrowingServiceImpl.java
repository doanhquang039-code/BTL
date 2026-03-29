/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import DAO.BorrowingDAO;
import DAO.BookDAO;
import model.Borrowing;
import service.BorrowingService;
import java.util.List;

public class BorrowingServiceImpl extends BorrowingService {
    private final BorrowingDAO borrowingDAO;
    private final BookDAO bookDAO; // Cần thêm BookDAO để thay đổi số lượng sách
    private static BorrowingServiceImpl instance;

    private BorrowingServiceImpl() {
        borrowingDAO = BorrowingDAO.getInstance();
        bookDAO = BookDAO.getInstance(); // Khởi tạo BookDAO
    }

    public static BorrowingServiceImpl getInstance() {
        if (instance == null) instance = new BorrowingServiceImpl();
        return instance;
    }

    @Override
    public void add(Borrowing e) {
        // 1. Lưu phiếu mượn vào Database
        borrowingDAO.addBorrowing(e);
        
        // 2. Cập nhật giảm số lượng sách trong kho đi 1
        int currentQuantity = e.getBook().getQuantity();
        if (currentQuantity > 0) {
            bookDAO.updateQuantity(e.getBook().getBookCode(), currentQuantity - 1);
        }
    }

  @Override
public void update(Borrowing e, int id) {
    // 1. Lấy dữ liệu cũ từ Database trước khi cập nhật để so sánh
    Borrowing oldBorrow = borrowingDAO.findById(id);
    if (oldBorrow == null) return;
    e.setBorrowingCode(id);
    if (oldBorrow.getBook().getBookCode() != e.getBook().getBookCode()) {
        // Cộng lại số lượng cho sách cũ
        bookDAO.updateQuantity(oldBorrow.getBook().getBookCode(), 
                               oldBorrow.getBook().getQuantity() + 1);
        bookDAO.updateQuantity(e.getBook().getBookCode(), 
                               e.getBook().getQuantity() - 1);
    } 
    else if (!"Đã trả".equalsIgnoreCase(oldBorrow.getStatus()) && "Đã trả".equalsIgnoreCase(e.getStatus())) {
        bookDAO.updateQuantity(e.getBook().getBookCode(), 
                               oldBorrow.getBook().getQuantity() + 1);
    }
    // Trường hợp C: Nếu đang "Đã trả" mà Admin sửa nhầm thành "Đang mượn" (ngược lại)
    else if ("Đã trả".equalsIgnoreCase(oldBorrow.getStatus()) && "Đang mượn".equalsIgnoreCase(e.getStatus())) {
        bookDAO.updateQuantity(e.getBook().getBookCode(), 
                               oldBorrow.getBook().getQuantity() - 1);
    }

    // 4. Gọi DAO để cập nhật tất cả các trường vào Database
    borrowingDAO.update(e);
}
    @Override
    public void delete(int id) {
        // Trước khi xóa bản ghi, có thể cần cân nhắc việc hoàn trả số lượng sách
        borrowingDAO.delete(id);
    }

    @Override
    public List<Borrowing> findAll() {
        return borrowingDAO.findAll();
    }

    @Override
    public Borrowing findById(int id) {
        return borrowingDAO.findById(id); // Sử dụng hàm findById đã viết ở DAO
    }

    @Override
    public List<Borrowing> searchByName(String name) {
        // Có thể triển khai tìm kiếm theo tên người mượn hoặc tên sách
        return null; 
    }
    
    // Thêm hàm xử lý trả sách nhanh để gọi từ Servlet
   
}