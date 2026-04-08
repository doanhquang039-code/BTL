/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Penalty;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Borrowing;
import model.Borrowing;
public class PenaltyDAO {
    private Connection connection;
    private static PenaltyDAO instance;

    private PenaltyDAO() {
        try { connection = MyConnection.getInstance(); } 
        catch (SQLException e) { e.printStackTrace(); }
    }

    public static PenaltyDAO getInstance() {
        if (instance == null) instance = new PenaltyDAO();
        return instance;
    }

    // 1. Tạo phiếu phạt mới (Dùng khi trả sách muộn hoặc làm hỏng sách)
    public void createPenalty(Penalty p) {
        String sql = "INSERT INTO Penalties (user_code, amount, reason, status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, p.getUser().getUserCode());
            ps.setBigDecimal(2, p.getAmount());
            ps.setString(3, p.getReason());
            ps.setString(4, "Chưa thanh toán"); // Mặc định khi tạo mới
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

  public List<Penalty> findAll() {
    List<Penalty> list = new ArrayList<>();
    // Sử dụng LEFT JOIN để đảm bảo bản ghi phạt không bị mất khi JOIN lỗi
    String sql = "SELECT p.*, u.fullname, b.borrowingcode " +
                 "FROM penalties p " +
                 "LEFT JOIN users u ON p.user_code = u.usercode " +
                 "LEFT JOIN borrowings b ON p.borrowing_code = b.borrowingcode " +
                 "ORDER BY p.penaltiecode DESC";
    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            list.add(mapPenalty(rs));
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}
public void update(Penalty p) {
    // SQL cập nhật 5 trường dựa trên penaltiecode
    String sql = "UPDATE penalties SET user_code = ?, borrowing_code = ?, " +
                 "amount = ?, reason = ?, status = ? " +
                 "WHERE penaltiecode = ?"; 
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, p.getUser().getUserCode());
        ps.setInt(2, p.getBorrowing().getBorrowingCode());
        ps.setBigDecimal(3, p.getAmount());
        ps.setString(4, p.getReason());
        ps.setString(5, p.getStatus());
        ps.setInt(6, p.getPenaltyCode());
        
        int rowsAffected = ps.executeUpdate(); 
        // Log này sẽ hiện ở tab Output của NetBeans
        System.out.println("DEBUG DAO: Ket qua Update ID " + p.getPenaltyCode() + " -> Rows: " + rowsAffected);
    } catch (SQLException e) { e.printStackTrace(); }
}
public void delete(int penaltyCode) {
    String sql = "DELETE FROM Penalties WHERE penaltiecode = ?"; // Phải là penaltiecode
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, penaltyCode);
        ps.executeUpdate();
    } catch (SQLException e) { e.printStackTrace(); }
}

// Hàm update giữ nguyên như bạn viết là đã đúng (nhưng nhớ Clean & Build)

    // Hàm tìm theo UserID (Bạn đã viết, mình tối ưu lại bằng hàm map)
    public List<Penalty> findByUserId(int userId) {
        List<Penalty> list = new ArrayList<>();
        String sql = "SELECT p.*, u.fullname FROM Penalties p " +
                     "JOIN Users u ON p.user_code = u.usercode WHERE p.user_code = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPenalty(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Hàm hỗ trợ map dữ liệu để tránh lặp code
  private Penalty mapPenalty(ResultSet rs) throws SQLException {
    Penalty p = new Penalty();
    p.setPenaltyCode(rs.getInt("penaltiecode")); // Khớp với penaltiecode trong DB
    
    User u = new User();
    u.setUserCode(rs.getInt("user_code"));
    u.setFullName(rs.getString("fullname")); // Lấy từ JOIN
    p.setUser(u);
    
    // Xử lý đối tượng Borrowing
    Borrowing br = new Borrowing(); 
    br.setBorrowingCode(rs.getInt("borrowing_code")); // Khớp với cột borrowing_code
    p.setBorrowing(br);
    
    p.setAmount(rs.getBigDecimal("amount"));
    p.setReason(rs.getString("reason"));
    p.setStatus(rs.getString("status"));
    return p;
}

    public Penalty findById(int id) {
    String sql = "SELECT p.*, u.fullname, b.borrowingcode " +
                 "FROM penalties p " +
                 "LEFT JOIN users u ON p.user_code = u.usercode " +
                 "LEFT JOIN borrowings b ON p.borrowing_code = b.borrowingcode " +
                 "WHERE p.penaltiecode = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return mapPenalty(rs);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}
    public int countActivePenalties() {
    // Giả sử bạn có cột status: 0 là chưa xử lý, 1 là đã xử lý
    String sql = "SELECT COUNT(*) FROM Penalties WHERE status = 0";
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
    public int countOverdueBooks() {
    // Đếm các bản ghi có ngày trả dự kiến nhỏ hơn ngày hiện tại và chưa trả
    String sql = "SELECT COUNT(*) FROM borrows WHERE due_date < CURRENT_DATE AND return_date IS NULL";
    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
    } catch (SQLException e) { e.printStackTrace(); }
    return 0;
}
}