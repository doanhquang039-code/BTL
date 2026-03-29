/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

public class Message {
    private int messageId;
    private User sender;   // Đối tượng người gửi
    private String senderRole;
    private String content;
    private Timestamp timestamp;
    private User receiver; // Đối tượng người nhận

    public Message() {}

    public Message(int messageId, User sender, String senderRole, String content, Timestamp timestamp, User receiver) {
        this.messageId = messageId;
        this.sender = sender;
        this.senderRole = senderRole;
        this.content = content;
        this.timestamp = timestamp;
        this.receiver = receiver;
    }

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public User getSender() {
        return sender;
    }

    public void setSender(User sender) {
        this.sender = sender;
    }

    public String getSenderRole() {
        return senderRole;
    }

    public void setSenderRole(String senderRole) {
        this.senderRole = senderRole;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public User getReceiver() {
        return receiver;
    }

    public void setReceiver(User receiver) {
        this.receiver = receiver;
    }
   
}