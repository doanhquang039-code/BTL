/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import common.Activity;
import model.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author admoi
 */
public class CategoryDAO implements Activity<Category> {
    private Connection connection;
    private static CategoryDAO instance;

    // Các câu lệnh SQL khớp với database QuanLyThuVien
    private final String INSERT_INTO = "INSERT INTO Categories (name) VALUES (?)";
    private final String UPDATE_BY_ID = "UPDATE Categories SET name = ? WHERE categorycode = ?";
    private final String DELETE_BY_ID = "DELETE FROM Categories WHERE categorycode = ?";
    private final String FIND_ALL = "SELECT * FROM Categories";
    private final String FIND_BY_ID = "SELECT * FROM Categories WHERE categorycode = ?";

    // Constructor private để thực hiện Singleton
    private CategoryDAO() {
        try {
            // Sử dụng lớp MyConnection bạn đã cung cấp
            this.connection = MyConnection.getInstance();
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối trong CategoryDAO: " + e.getMessage());
        }
    }

    // Hàm lấy thực thể duy nhất (Singleton)
    public static CategoryDAO getInstance() {
        if (instance == null) {
            instance = new CategoryDAO();
        }
        return instance;
    }

    @Override
    public void add(Category category) {
        try (PreparedStatement ps = connection.prepareStatement(INSERT_INTO)) {
            ps.setString(1, category.getName());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm Category: " + e.getMessage());
        }
    }

    @Override
    public void update(Category category, int id) {
        try (PreparedStatement ps = connection.prepareStatement(UPDATE_BY_ID)) {
            ps.setString(1, category.getName());
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật Category: " + e.getMessage());
        }
    }

    @Override
    public void delete(int id) {
        try (PreparedStatement ps = connection.prepareStatement(DELETE_BY_ID)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa Category: " + e.getMessage());
        }
    }

    @Override
    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(new Category(
                    rs.getInt("categorycode"), 
                    rs.getString("name")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách Category: " + e.getMessage());
        }
        return categories;
    }

    @Override
    public Category findById(int id) {
        try (PreparedStatement ps = connection.prepareStatement(FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                        rs.getInt("categorycode"), 
                        rs.getString("name")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm Category theo ID: " + e.getMessage());
        }
        return null;
    }
}