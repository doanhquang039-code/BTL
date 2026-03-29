/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Message;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {
    private Connection connection;
    private static MessageDAO instance;

    private MessageDAO() {
        try { connection = MyConnection.getInstance(); } 
        catch (SQLException e) { e.printStackTrace(); }
    }

    public static MessageDAO getInstance() {
        if (instance == null) instance = new MessageDAO();
        return instance;
    }

    public List<Message> getMessagesForUser(int userId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT m.*, u.fullname as sender_name FROM Messages m " +
                     "JOIN Users u ON m.sender_usercode = u.usercode " +
                     "WHERE receiver_usercode = ? ORDER BY timestamp DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Message msg = new Message();
                msg.setMessageId(rs.getInt("message_id"));
                msg.setContent(rs.getString("content"));
                msg.setTimestamp(rs.getTimestamp("timestamp"));
                
                User sender = new User();
                sender.setFullName(rs.getString("sender_name"));
                msg.setSender(sender);
                
                list.add(msg);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}