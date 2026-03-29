/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import DAO.MessageDAO;
import model.Message;
import service.MessageService; // Giả sử bạn đã tạo Abstract MessageService
import java.util.List;

/**
 * @author admoi
 */
public class MessageServiceImpl {
    private final MessageDAO messageDAO;
    private static MessageServiceImpl instance;

    private MessageServiceImpl() {
        messageDAO = MessageDAO.getInstance();
    }

    public static MessageServiceImpl getInstance() {
        if (instance == null) {
            instance = new MessageServiceImpl();
        }
        return instance;
    }

    public List<Message> getMessagesForUser(int userId) {
        return messageDAO.getMessagesForUser(userId);
    }
    
    // Các hàm add (gửi tin), delete (xóa tin) triển khai tương tự gọi từ MessageDAO
}