/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

public class BookImport {
    private int importId;
    private Book book; // Liên kết đến đối tượng Book
    private int importQuantity;
private Timestamp importDate;
    private String importedBy;

    public BookImport() {}

    public BookImport(int importId, Book book, int importQuantity, Timestamp importDate, String importedBy) {
        this.importId = importId;
        this.book = book;
        this.importQuantity = importQuantity;
        this.importDate = importDate;
        this.importedBy = importedBy;
    }

    public int getImportId() {
        return importId;
    }

    public void setImportId(int importId) {
        this.importId = importId;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public int getImportQuantity() {
        return importQuantity;
    }

    public void setImportQuantity(int importQuantity) {
        this.importQuantity = importQuantity;
    }

   

    public String getImportedBy() {
        return importedBy;
    }

    public void setImportedBy(String importedBy) {
        this.importedBy = importedBy;
    }
    public Timestamp getImportDate() {
        return importDate;
    }

    public void setImportDate(Timestamp importDate) {
        this.importDate = importDate;
    }


}