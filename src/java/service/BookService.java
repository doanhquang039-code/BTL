/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package service;

import common.Activity;
import common.Search;
import model.Book;

/**
 * @author admoi
 */
public abstract class BookService implements Activity<Book>, Search<Book> {

    public void updateStock(int bookCode, int quantity) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    // Bạn có thể thêm các phương thức đặc thù của Book ở đây
    // Ví dụ: abstract void updateQuantity(int bookId, int amount);
}