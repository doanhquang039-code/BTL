/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.BookImport;
import model.Book;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookImportDAO {
    private Connection connection;
    private static BookImportDAO instance;

    private BookImportDAO() {
        try {
            connection = MyConnection.getInstance();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static BookImportDAO getInstance() {
        if (instance == null) instance = new BookImportDAO();
        return instance;
    }


    // 2. Lấy tất cả lịch sử nhập kho (JOIN với bảng Books để lấy tiêu đề sách)
    public List<BookImport> findAll() {
        List<BookImport> list = new ArrayList<>();
        String sql = "SELECT bi.*, b.title FROM book_imports bi JOIN Books b ON bi.book_code = b.bookcode ORDER BY bi.import_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBookImport(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 3. Tìm phiếu nhập kho theo ID
    public BookImport findById(int id) {
        String sql = "SELECT bi.*, b.title FROM book_imports bi JOIN Books b ON bi.book_code = b.bookcode WHERE bi.import_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBookImport(rs);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    

    // 5. Xóa phiếu nhập kho
    public void delete(int id) {
        String sql = "DELETE FROM book_imports WHERE import_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Hàm hỗ trợ map dữ liệu từ ResultSet sang Object BookImport
    private BookImport mapBookImport(ResultSet rs) throws SQLException {
        BookImport bi = new BookImport();
        bi.setImportId(rs.getInt("import_id"));
        bi.setImportQuantity(rs.getInt("import_quantity"));
       bi.setImportDate(rs.getTimestamp("import_date"));
    bi.setImportedBy(rs.getString("imported_by"));

        Book b = new Book();
        b.setBookCode(rs.getInt("book_code"));
        b.setTitle(rs.getString("title"));
        bi.setBook(b);
        return bi;
    }
    // 1. Thêm mới phiếu nhập kho
public void addImport(BookImport bi) {
    String sql = "INSERT INTO book_imports (book_code, import_quantity, import_date, imported_by) VALUES (?, ?, ?, ?)";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, bi.getBook().getBookCode());
        ps.setInt(2, bi.getImportQuantity());
        
        // DÙNG setTimestamp để lưu cả Giờ:Phút:Giây
        ps.setTimestamp(3, bi.getImportDate()); 
        
        ps.setString(4, bi.getImportedBy());
        ps.executeUpdate();
    } catch (SQLException e) { e.printStackTrace(); }
}

public void update(BookImport bi) {
    // Đảm bảo thứ tự dấu ? khớp với ps.set... bên dưới
    String sql = "UPDATE book_imports SET book_code = ?, import_quantity = ?, import_date = ?, imported_by = ? WHERE import_id = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, bi.getBook().getBookCode());
        ps.setInt(2, bi.getImportQuantity());
        
        // PHẢI lấy từ đối tượng bi và dùng setTimestamp
        ps.setTimestamp(3, bi.getImportDate()); 
        
        ps.setString(4, bi.getImportedBy());
        ps.setInt(5, bi.getImportId());
        
        int rowsAffected = ps.executeUpdate();
        System.out.println("DEBUG DAO: Cap nhat Import ID " + bi.getImportId() + " - Rows: " + rowsAffected);
    } catch (SQLException e) { 
        e.printStackTrace(); 
    }
}
}