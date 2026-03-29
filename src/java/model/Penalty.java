/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

public class Penalty {
    private int penaltyCode;
    private User user; 
    private Borrowing borrowing; // Phạt dựa trên phiếu mượn nào
    private BigDecimal amount;
    private String reason;
    private String status;

    public Penalty() {}

    public Penalty(int penaltyCode, User user, Borrowing borrowing, BigDecimal amount, String reason, String status) {
        this.penaltyCode = penaltyCode;
        this.user = user;
        this.borrowing = borrowing;
        this.amount = amount;
        this.reason = reason;
        this.status = status;
    }

    public int getPenaltyCode() {
        return penaltyCode;
    }

    public void setPenaltyCode(int penaltyCode) {
        this.penaltyCode = penaltyCode;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Borrowing getBorrowing() {
        return borrowing;
    }

    public void setBorrowing(Borrowing borrowing) {
        this.borrowing = borrowing;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
}