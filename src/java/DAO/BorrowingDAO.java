/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Borrowing;
import model.Book;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BorrowingDAO {
    private Connection connection;
    private static BorrowingDAO instance;

    private BorrowingDAO() {
        try { connection = MyConnection.getInstance(); } 
        catch (SQLException e) { e.printStackTrace(); }
    }

    public static BorrowingDAO getInstance() {
        if (instance == null) instance = new BorrowingDAO();
        return instance;
    }

    // 1. Thêm mới phiếu mượn
    public void addBorrowing(Borrowing br) {
        String sql = "INSERT INTO Borrowings (user_code, book_bookcode, borrow_date, due_date, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, br.getUser().getUserCode());
            ps.setInt(2, br.getBook().getBookCode());
            ps.setString(3, br.getBorrowDate());
            ps.setString(4, br.getDueDate());
            ps.setString(5, "Đang mượn");
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

  public List<Borrowing> findAll() {
    List<Borrowing> list = new ArrayList<>();
    // Chuyển sang LEFT JOIN để phiếu mượn không bị "mất tích"
    String sql = "SELECT br.*, u.fullname, bk.title, bk.quantity " + 
                 "FROM borrowings br " +
                 "LEFT JOIN users u ON br.user_code = u.usercode " +
                 "LEFT JOIN books bk ON br.book_bookcode = bk.bookcode " +
                 "ORDER BY br.borrowingcode DESC";
    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            list.add(mapBorrowing(rs));
        }
    } catch (SQLException e) { 
        e.printStackTrace(); 
    }
    return list;
}

public Borrowing findById(int id) {
    String sql = "SELECT br.*, u.fullname, bk.title, bk.quantity " +
                 "FROM Borrowings br " +
                 "LEFT JOIN Users u ON br.user_code = u.usercode " +
                 "LEFT JOIN Books bk ON br.book_bookcode = bk.bookcode " +
                 "WHERE br.borrowingcode = ?"; 
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return mapBorrowing(rs);
        }
    } catch (SQLException e) { 
        System.out.println("Lỗi findById: " + e.getMessage()); 
    }
    return null;
}
    // 4. CẬP NHẬT TẤT CẢ CÁC TRƯỜNG (Của đối tượng Borrowing)
    public void update(Borrowing br) {
        String sql = "UPDATE Borrowings SET user_code = ?, book_bookcode = ?, " +
                     "borrow_date = ?, due_date = ?, status = ? " +
                     "WHERE borrowingcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, br.getUser().getUserCode());
            ps.setInt(2, br.getBook().getBookCode());
            ps.setString(3, br.getBorrowDate());
            ps.setString(4, br.getDueDate());
            ps.setString(5, br.getStatus());
            ps.setInt(6, br.getBorrowingCode()); // Khóa chính để xác định bản ghi cần sửa
            
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 5. Xóa phiếu mượn
    public void delete(int id) {
        String sql = "DELETE FROM Borrowings WHERE borrowingcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Hàm hỗ trợ ánh xạ dữ liệu
    private Borrowing mapBorrowing(ResultSet rs) throws SQLException {
        Borrowing br = new Borrowing();
        br.setBorrowingCode(rs.getInt("borrowingcode"));
        
        User u = new User();
        u.setUserCode(rs.getInt("user_code"));
        u.setFullName(rs.getString("fullname"));
        br.setUser(u);
        
        Book b = new Book();
        b.setBookCode(rs.getInt("book_bookcode"));
        b.setTitle(rs.getString("title"));
        // Lấy thêm quantity để Service có thể xử lý logic mượn trả
        b.setQuantity(rs.getInt("quantity")); 
        br.setBook(b);
        
        br.setBorrowDate(rs.getString("borrow_date"));
        br.setDueDate(rs.getString("due_date"));
        br.setStatus(rs.getString("status"));
        return br;
    }

}