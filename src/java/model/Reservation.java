/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

public class Reservation {
    private int reservationCode;
    private User user;
    private Book book;
    private String reserveDate;
    private String status;
    private Date borrowDate;
    private Date returnDate;
    private boolean isNotified;

    public Reservation() {}

    public Reservation(int reservationCode, User user, Book book, String reserveDate, String status, Date borrowDate, Date returnDate, boolean isNotified) {
        this.reservationCode = reservationCode;
        this.user = user;
        this.book = book;
        this.reserveDate = reserveDate;
        this.status = status;
        this.borrowDate = borrowDate;
        this.returnDate = returnDate;
        this.isNotified = isNotified;
    }
private boolean notified;
    public int getReservationCode() {
        return reservationCode;
    }

    public void setReservationCode(int reservationCode) {
        this.reservationCode = reservationCode;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public String getReserveDate() {
        return reserveDate;
    }

    public void setReserveDate(String reserveDate) {
        this.reserveDate = reserveDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Date borrowDate) {
        this.borrowDate = borrowDate;
    }

    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    public boolean isIsNotified() {
        return isNotified;
    }

    public void setIsNotified(boolean isNotified) {
        this.isNotified = isNotified;
    }
    

    public void setNotified(boolean notified) {
    this.notified = notified; // Gán giá trị bình thường
}

public boolean isNotified() {
    return notified;
}
}