/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Book {
    private int bookCode;
    private String title;
    private String author;
    private Category category; // Liên kết trực tiếp đến đối tượng Category
    private String publishYear;
    private int quantity;
    private String image;
    private int totalImported;

    public Book() {}

    public Book(int bookCode, String title, String author, Category category, String publishYear, int quantity, String image, int totalImported) {
        this.bookCode = bookCode;
        this.title = title;
        this.author = author;
        this.category = category;
        this.publishYear = publishYear;
        this.quantity = quantity;
        this.image = image;
        this.totalImported = totalImported;
    }

    public int getBookCode() {
        return bookCode;
    }

    public void setBookCode(int bookCode) {
        this.bookCode = bookCode;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getPublishYear() {
        return publishYear;
    }

    public void setPublishYear(String publishYear) {
        this.publishYear = publishYear;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getTotalImported() {
        return totalImported;
    }

    public void setTotalImported(int totalImported) {
        this.totalImported = totalImported;
    }

}