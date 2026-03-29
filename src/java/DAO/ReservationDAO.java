/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Reservation;
import model.User;
import model.Book;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {
    private Connection connection;
    private static ReservationDAO instance;

    private ReservationDAO() {
        try { connection = MyConnection.getInstance(); } 
        catch (SQLException e) { e.printStackTrace(); }
    }

    public static ReservationDAO getInstance() {
        if (instance == null) instance = new ReservationDAO();
        return instance;
    }

    // 1. Thêm mới phiếu đặt trước
    public void createReservation(Reservation res) {
        String sql = "INSERT INTO Reservations (user_code, book_code, reserve_date, status, is_notified) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, res.getUser().getUserCode());
            ps.setInt(2, res.getBook().getBookCode());
            ps.setString(3, res.getReserveDate());
            ps.setString(4, res.getStatus() != null ? res.getStatus() : "Đang chờ");
            ps.setBoolean(5, res.isNotified());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 2. Hiển thị tất cả danh sách (JOIN để lấy tên User và tiêu đề sách)
    public List<Reservation> findAll() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, u.fullname, b.title " +
                     "FROM Reservations r " +
                     "JOIN Users u ON r.user_code = u.usercode " +
                     "JOIN Books b ON r.book_code = b.bookcode " +
                     "ORDER BY r.reserve_date ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapReservation(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 3. Tìm phiếu đặt theo mã khóa chính
    public Reservation findById(int id) {
        String sql = "SELECT r.*, u.fullname, b.title " +
                     "FROM Reservations r " +
                     "JOIN Users u ON r.user_code = u.usercode " +
                     "JOIN Books b ON r.book_code = b.bookcode " +
                     "WHERE r.reservationcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapReservation(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // 4. Cập nhật TẤT CẢ các thuộc tính
    public void update(Reservation res) {
        String sql = "UPDATE Reservations SET user_code = ?, book_code = ?, " +
                     "reserve_date = ?, status = ?, is_notified = ? " +
                     "WHERE reservationcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, res.getUser().getUserCode());
            ps.setInt(2, res.getBook().getBookCode());
            ps.setString(3, res.getReserveDate());
            ps.setString(4, res.getStatus());
            ps.setBoolean(5, res.isNotified());
            ps.setInt(6, res.getReservationCode()); // Khóa chính
            
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 5. Xóa phiếu đặt trước
    public void delete(int code) {
        String sql = "DELETE FROM Reservations WHERE reservationcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, code);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Hàm ánh xạ dữ liệu thực tế từ DB sang Model
    private Reservation mapReservation(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setReservationCode(rs.getInt("reservationcode"));
        
        User u = new User();
        u.setUserCode(rs.getInt("user_code"));
        u.setFullName(rs.getString("fullname"));
        res.setUser(u);
        
        Book b = new Book();
        b.setBookCode(rs.getInt("book_code"));
        b.setTitle(rs.getString("title"));
        res.setBook(b);
        
        res.setReserveDate(rs.getString("reserve_date"));
        res.setStatus(rs.getString("status"));
        res.setNotified(rs.getBoolean("is_notified"));
        return res;
    }
}