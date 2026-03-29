/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import DAO.UserDAO;
import model.User;
import service.UserService;
import java.util.List;

public class UserServiceImpl extends UserService {
    private final UserDAO userDAO;
    private static UserServiceImpl instance;

    private UserServiceImpl() {
        userDAO = UserDAO.getInstance();
    }

    public static UserServiceImpl getInstance() {
        if (instance == null) instance = new UserServiceImpl();
        return instance;
    }

    // Logic đặc thù: Đăng nhập
    public User login(String username, String password) {
        return userDAO.checkLogin(username, password);
    }
    public void register(User user) {
        // Bạn có thể thêm logic kiểm tra username tồn tại ở đây trước khi add
        userDAO.add(user);
    }

    @Override
    public void add(User e) { userDAO.add(e); }

   @Override
public void update(User e, int id) {
    // Đảm bảo đối tượng User có ID đúng từ tham số id truyền vào
    e.setUserCode(id); 
    
    // Gọi hàm update của DAO (chỉ truyền đối tượng User)
    userDAO.update(e); 
}
    @Override
    public void delete(int id) { userDAO.delete(id); }

    @Override
    public List<User> findAll() { return userDAO.findAll(); }

    @Override
    public User findById(int id) { return userDAO.findById(id); }

    @Override
    public List<User> searchByName(String name) {
        return userDAO.searchByName(name);
    }
}