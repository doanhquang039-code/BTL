/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Book;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * @author admoi
 */
public class BookDAO {
    private Connection connection;
    private static BookDAO instance;

    private BookDAO() {
        try { 
            connection = MyConnection.getInstance(); 
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    public static BookDAO getInstance() {
        if (instance == null) instance = new BookDAO();
        return instance;
    }

    // 1. Lấy tất cả sách (Phải lấy cả cột image và publish_year)
    public List<Book> findAll() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name as catName FROM Books b LEFT JOIN Categories c ON b.category_code = c.categorycode";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBook(rs));
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }
// Trong BookDAO.java
public void updateStockAfterImport(int bookCode, int quantity) {
    // Cập nhật cả quantity (tồn kho hiện tại) và total_imported (tổng lịch sử nhập)
    String sql = "UPDATE Books SET quantity = quantity + ?, total_imported = total_imported + ? WHERE bookcode = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, quantity);
        ps.setInt(2, quantity);
        ps.setInt(3, bookCode);
        
        int rows = ps.executeUpdate();
        System.out.println("DEBUG DAO: Da cap nhat kho cho Book " + bookCode + " - Rows: " + rows);
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
    // 2. Thêm sách mới
    public void add(Book b) {
        String sql = "INSERT INTO Books (title, author, category_code, publish_year, quantity, image) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setInt(3, b.getCategory().getCategoryCode());
            ps.setString(4, b.getPublishYear());
            ps.setInt(5, b.getQuantity());
            ps.setString(6, b.getImage()); // Lưu tên file ảnh
            ps.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    // 3. Cập nhật sách
    public void update(Book b, int id) {
        String sql = "UPDATE Books SET title = ?, author = ?, category_code = ?, publish_year = ?, quantity = ?, image = ? WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setInt(3, b.getCategory().getCategoryCode());
            ps.setString(4, b.getPublishYear());
            ps.setInt(5, b.getQuantity());
            ps.setString(6, b.getImage());
            ps.setInt(7, id);
            ps.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    // 4. Xóa sách
    public void delete(int id) {
        String sql = "DELETE FROM Books WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    // 5. Tìm sách theo ID (Dùng cho trang Update)
    public Book findById(int id) {
        String sql = "SELECT b.*, c.name as catName FROM Books b LEFT JOIN Categories c ON b.category_code = c.categorycode WHERE b.bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapBook(rs);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return null;
    }
   public List<Book> searchByName(String keyword) {
    List<Book> list = new ArrayList<>();
   
    String sql = "SELECT b.*, c.name as catName FROM Books b " +
                 "LEFT JOIN Categories c ON b.category_code = c.categorycode " +
                 "WHERE b.title LIKE ? OR b.author LIKE ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        String searchPattern = "%" + keyword + "%";
        ps.setString(1, searchPattern);
        ps.setString(2, searchPattern);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBook(rs));
            }
        }
    } catch (SQLException e) { 
        e.printStackTrace(); 
    }
    return list;
}

    private Book mapBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setBookCode(rs.getInt("bookcode"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setQuantity(rs.getInt("quantity"));
        b.setImage(rs.getString("image")); // QUAN TRỌNG: Cần lấy cột này để hiện ảnh
        b.setPublishYear(rs.getString("publish_year"));
        
        Category cat = new Category(rs.getInt("category_code"), rs.getString("catName"));
        b.setCategory(cat);
        return b;
    }

   public void updateQuantity(int bookCode, int updatedQty) {
    String sql = "UPDATE Books SET quantity = ? WHERE bookcode = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, updatedQty);
        ps.setInt(2, bookCode);
        
        int rowsUpdated = ps.executeUpdate();
        if (rowsUpdated > 0) {
            System.out.println("Cập nhật số lượng sách thành công cho mã: " + bookCode);
        }
    } catch (SQLException e) {
        System.err.println("Lỗi khi cập nhật số lượng sách: " + e.getMessage());
        e.printStackTrace();
    }
}
  public void updateStock(int bookCode, int quantity) {
    // quantity ở đây có thể là số âm (khi xóa) hoặc dương (khi thêm/sửa tăng)
    String sql = "UPDATE Books SET quantity = quantity + ? WHERE bookcode = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, quantity);
        ps.setInt(2, bookCode);
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
  public int countTotalBooksInStock() {
    String sql = "SELECT SUM(quantity) FROM Books";
    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

// Nếu bạn muốn đếm có bao nhiêu ĐẦU SÁCH khác nhau
public int countBookTitles() {
    String sql = "SELECT COUNT(*) FROM Books";
    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
    } catch (SQLException e) { e.printStackTrace(); }
    return 0;
}
}