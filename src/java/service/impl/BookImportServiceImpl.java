/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import DAO.BookImportDAO;
import model.BookImport;
import service.BookImportService;
import java.util.List;

public class BookImportServiceImpl extends BookImportService {
    private final BookImportDAO importDAO;
    private static BookImportServiceImpl instance;

    private BookImportServiceImpl() {
        importDAO = BookImportDAO.getInstance();
    }

    public static BookImportServiceImpl getInstance() {
        if (instance == null) instance = new BookImportServiceImpl();
        return instance;
    }

    @Override
    public void add(BookImport e) {
        importDAO.addImport(e);
        // Logic bổ sung: Có thể gọi BookDAO.updateQuantity() tại đây
    }

    // Trong service.impl.BookImportServiceImpl
@Override
public void update(BookImport e, int id) {
    importDAO.update(e); // Phải gọi DAO
}

@Override
public void delete(int id) {
    importDAO.delete(id); // Phải gọi DAO
}

@Override
public BookImport findById(int id) {
    return importDAO.findById(id); // KHÔNG ĐƯỢC return null ở đây
}

    @Override
    public List<BookImport> findAll() { return importDAO.findAll(); }

   
}