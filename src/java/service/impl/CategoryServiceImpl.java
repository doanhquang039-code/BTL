/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import DAO.CategoryDAO;
import model.Category;
import service.CategoryService;
import java.util.List;

/**
 * @author admoi
 */
public class CategoryServiceImpl extends CategoryService {

    private final CategoryDAO categoryDAO;
    private static CategoryServiceImpl instance;

    // Constructor private để thực hiện Singleton
    private CategoryServiceImpl() {
        // Lấy thực thể duy nhất của CategoryDAO
        categoryDAO = CategoryDAO.getInstance();
    }

    // Phương thức để các lớp khác (như Servlet) lấy thực thể của Service này
    public static CategoryServiceImpl getInstance() {
        if (instance == null) {
            instance = new CategoryServiceImpl();
        }
        return instance;
    }

    @Override
    public void add(Category category) {
        // Bạn có thể thêm logic kiểm tra dữ liệu trước khi gọi DAO
        if (category.getName() != null && !category.getName().trim().isEmpty()) {
            categoryDAO.add(category);
        }
    }

    @Override
    public void update(Category category, int id) {
        // Đảm bảo ID truyền vào khớp với ID của đối tượng category
        categoryDAO.update(category, id);
    }

    @Override
    public void delete(int id) {
        // Có thể thêm kiểm tra xem có sách nào thuộc Category này không trước khi xóa
        categoryDAO.delete(id);
    }

    @Override
    public List<Category> findAll() {
        return categoryDAO.findAll();
    }

    @Override
    public Category findById(int id) {
        return categoryDAO.findById(id);
    }

    @Override
    public List<Category> searchByName(String name) {
        // Vì trong CategoryDAO của bạn chưa có hàm searchByName cụ thể cho Category,
        // bạn có thể lọc trong List hoặc bổ sung hàm search vào DAO.
        // Ở đây mình tạm thời lọc cơ bản:
        return categoryDAO.findAll().stream()
                .filter(c -> c.getName().toLowerCase().contains(name.toLowerCase()))
                .toList();
    }
}