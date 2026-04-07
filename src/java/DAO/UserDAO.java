/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private Connection connection;
    private static UserDAO instance;
   
    private UserDAO() {
        try {
            connection = MyConnection.getInstance();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static UserDAO getInstance() {
        if (instance == null) instance = new UserDAO();
        return instance;
    }

 

    // Hàm bổ sung để làm mới kết nối nếu bị ngắt hoặc null
    private void refreshConnection() {
        try {
            // Kiểm tra nếu connection null hoặc đã đóng thì mới lấy mới
            if (this.connection == null || this.connection.isClosed()) {
                this.connection = MyConnection.getInstance();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

  // Trong UserDAO.java
private User mapUser(ResultSet rs) throws SQLException {
    User u = new User();
    u.setUserCode(rs.getInt("usercode"));
    u.setUsername(rs.getString("username"));
    u.setFullName(rs.getString("fullname"));
    // Dòng này cực kỳ quan trọng để hiển thị đúng Role
    u.setRole(rs.getString("role")); 
    return u;
}
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
public void add(User u) {
    // Sửa 'user' thành ? để nhận role từ form
    String sql = "INSERT INTO Users (username, password, fullname, role) VALUES (?, ?, ?, ?)";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, u.getUsername());
        ps.setString(2, u.getPassword());
        ps.setString(3, u.getFullName());
        // Lấy role từ đối tượng User truyền từ Servlet
        ps.setString(4, u.getRole()); 
        ps.executeUpdate();
    } catch (SQLException e) { 
        e.printStackTrace(); 
    }
}
public void update(User u) {
    // Chú ý: usercode viết liền theo cấu trúc bảng của bạn
    String sql = "UPDATE users SET fullname = ?, role = ?, password = ? WHERE usercode = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, u.getFullName());
        ps.setString(2, u.getRole());
        ps.setString(3, u.getPassword());
        ps.setInt(4, u.getUserCode());
        
        int rowsAffected = ps.executeUpdate(); 
        System.out.println("DEBUG DAO: Da cap nhat ID " + u.getUserCode() + " - Rows: " + rowsAffected);
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
    public void delete(int id) {
        String sql = "DELETE FROM Users WHERE usercode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public User findById(int id) {
        String sql = "SELECT * FROM Users WHERE usercode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<User> searchByName(String name) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    public boolean checkUsernameExists(String username) {
    String sql = "SELECT * FROM Users WHERE username = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next(); // Trả về true nếu tìm thấy username
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
    public int countTotalUsers() {
    // Đếm tất cả trừ Admin nếu bạn muốn chỉ đếm người dùng/thành viên
    String sql = "SELECT COUNT(*) FROM Users WHERE role != 'Admin'";
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
}