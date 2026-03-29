/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package service;

import common.Activity;
import common.Search;
import model.Borrowing;

/**
 * @author admoi
 */
public abstract class BorrowingService implements Activity<Borrowing>, Search<Borrowing> {

    public void borrowBook(int userCode, int bookCode) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    // Có thể thêm: abstract void returnBook(int borrowingId);

    public void returnBook(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}