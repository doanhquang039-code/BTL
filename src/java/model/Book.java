package model;

import java.math.BigDecimal;

public class Book {
    private int bookCode;
    private String title;
    private String author;
    private Category category;
    private String publisher;
    private String publishYear;
    private BigDecimal price;
    private int pageCount;
    private String shelfLocation;
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

    public int getBookCode() { return bookCode; }
    public void setBookCode(int bookCode) { this.bookCode = bookCode; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public String getPublishYear() { return publishYear; }
    public void setPublishYear(String publishYear) { this.publishYear = publishYear; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getPageCount() { return pageCount; }
    public void setPageCount(int pageCount) { this.pageCount = pageCount; }

    public String getShelfLocation() { return shelfLocation; }
    public void setShelfLocation(String shelfLocation) { this.shelfLocation = shelfLocation; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public int getTotalImported() { return totalImported; }
    public void setTotalImported(int totalImported) { this.totalImported = totalImported; }
}
