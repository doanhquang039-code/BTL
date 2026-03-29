/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import DAO.BookDAO;
import model.Book;
import service.BookService;
import java.util.List;

public class BookServiceImpl extends BookService {
    private final BookDAO bookDAO;
    private static BookServiceImpl instance;

    private BookServiceImpl() {
        bookDAO = BookDAO.getInstance();
    }

    public static BookServiceImpl getInstance() {
        if (instance == null) instance = new BookServiceImpl();
        return instance;
    }

    @Override
    public void add(Book e) { bookDAO.add(e); }

    @Override
    public void update(Book e, int id) { bookDAO.update(e, id); }

    @Override
    public void delete(int id) { bookDAO.delete(id); }

    @Override
    public List<Book> findAll() { return bookDAO.findAll(); }

    @Override
    public Book findById(int id) { return bookDAO.findById(id); }

    @Override
    public List<Book> searchByName(String name) {
        return bookDAO.searchByName(name);
    }
}