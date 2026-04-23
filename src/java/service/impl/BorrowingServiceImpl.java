package service.impl;

import DAO.BookDAO;
import DAO.BorrowingDAO;
import java.time.LocalDate;
import java.util.List;
import model.Book;
import model.Borrowing;
import model.BorrowingDetail;
import model.User;
import service.BorrowingService;

public class BorrowingServiceImpl extends BorrowingService {
    private final BorrowingDAO borrowingDAO;
    private final BookDAO bookDAO;
    private static BorrowingServiceImpl instance;

    private BorrowingServiceImpl() {
        borrowingDAO = BorrowingDAO.getInstance();
        bookDAO = BookDAO.getInstance();
    }

    public static BorrowingServiceImpl getInstance() {
        if (instance == null) {
            instance = new BorrowingServiceImpl();
        }
        return instance;
    }

    @Override
    public void add(Borrowing borrowing) {
        Book book = bookDAO.findById(borrowing.getBook().getBookCode());
        if (book == null || book.getQuantity() <= 0) {
            return;
        }

        borrowingDAO.addBorrowing(borrowing);
        bookDAO.updateQuantity(book.getBookCode(), book.getQuantity() - 1);
    }

    @Override
    public void update(Borrowing borrowing, int id) {
        Borrowing oldBorrowing = borrowingDAO.findById(id);
        if (oldBorrowing == null) {
            return;
        }

        borrowing.setBorrowingCode(id);
        if (oldBorrowing.getBook().getBookCode() != borrowing.getBook().getBookCode()) {
            Book oldBook = bookDAO.findById(oldBorrowing.getBook().getBookCode());
            Book newBook = bookDAO.findById(borrowing.getBook().getBookCode());
            if (oldBook != null) {
                bookDAO.updateQuantity(oldBook.getBookCode(), oldBook.getQuantity() + 1);
            }
            if (newBook != null && newBook.getQuantity() > 0) {
                bookDAO.updateQuantity(newBook.getBookCode(), newBook.getQuantity() - 1);
            }
        }

        borrowingDAO.update(borrowing);
    }

    @Override
    public void delete(int id) {
        borrowingDAO.delete(id);
    }

    @Override
    public List<Borrowing> findAll() {
        return borrowingDAO.findAll();
    }

    @Override
    public Borrowing findById(int id) {
        return borrowingDAO.findById(id);
    }

    @Override
    public BorrowingDetail findDetailById(int id) {
        return borrowingDAO.findDetailById(id);
    }

    @Override
    public List<Borrowing> searchByName(String name) {
        return borrowingDAO.searchByName(name);
    }

    @Override
    public void borrowBook(int userCode, int bookCode) {
        Book book = bookDAO.findById(bookCode);
        if (book == null || book.getQuantity() <= 0) {
            return;
        }

        User user = new User();
        user.setUserCode(userCode);

        Borrowing borrowing = new Borrowing();
        borrowing.setUser(user);
        borrowing.setBook(book);
        borrowing.setBorrowDate(LocalDate.now().toString());
        borrowing.setDueDate(LocalDate.now().plusDays(14).toString());
        borrowing.setStatus("Đang mượn");

        borrowingDAO.addBorrowing(borrowing);
        bookDAO.updateQuantity(bookCode, book.getQuantity() - 1);
    }

    @Override
    public void requestBorrowBook(int userCode, int bookCode) {
        Book book = bookDAO.findById(bookCode);
        if (book == null || book.getQuantity() <= 0 || borrowingDAO.hasPendingRequest(userCode, bookCode)) {
            return;
        }

        User user = new User();
        user.setUserCode(userCode);

        Borrowing borrowing = new Borrowing();
        borrowing.setUser(user);
        borrowing.setBook(book);
        borrowing.setBorrowDate(LocalDate.now().toString());
        borrowing.setDueDate(LocalDate.now().plusDays(14).toString());
        borrowing.setStatus("Chờ duyệt");

        borrowingDAO.addBorrowing(borrowing);
    }

    @Override
    public void requestBorrowBook(Borrowing borrowing) {
        if (borrowing == null || borrowing.getUser() == null || borrowing.getBook() == null) {
            return;
        }
        int userCode = borrowing.getUser().getUserCode();
        int bookCode = borrowing.getBook().getBookCode();
        Book book = bookDAO.findById(bookCode);
        if (book == null || book.getQuantity() <= 0 || borrowingDAO.hasPendingRequest(userCode, bookCode)) {
            return;
        }

        if (borrowing.getBorrowDate() == null || borrowing.getBorrowDate().trim().isEmpty()) {
            borrowing.setBorrowDate(LocalDate.now().toString());
        }
        if (borrowing.getDueDate() == null || borrowing.getDueDate().trim().isEmpty()) {
            borrowing.setDueDate(LocalDate.now().plusDays(14).toString());
        }
        if (borrowing.getStatus() == null || borrowing.getStatus().trim().isEmpty()) {
            borrowing.setStatus("Chờ duyệt");
        }
        borrowing.setBook(book);
        borrowingDAO.addBorrowing(borrowing);
    }

    @Override
    public void approveBorrowRequest(int borrowingCode) {
        Borrowing borrowing = borrowingDAO.findById(borrowingCode);
        if (borrowing == null || borrowing.getBook() == null) {
            return;
        }

        Book book = bookDAO.findById(borrowing.getBook().getBookCode());
        if (book == null || book.getQuantity() <= 0) {
            borrowingDAO.updateStatus(borrowingCode, "Từ chối");
            return;
        }

        borrowingDAO.updateStatus(borrowingCode, "Đang mượn");
        bookDAO.updateQuantity(book.getBookCode(), book.getQuantity() - 1);
    }

    @Override
    public void rejectBorrowRequest(int borrowingCode) {
        borrowingDAO.updateStatus(borrowingCode, "Từ chối");
    }

    @Override
    public void approveReturnRequest(int borrowingCode) {
        Borrowing borrowing = borrowingDAO.findById(borrowingCode);
        if (borrowing == null || borrowing.getBook() == null) {
            return;
        }

        Book book = bookDAO.findById(borrowing.getBook().getBookCode());
        if (book != null) {
            bookDAO.updateQuantity(book.getBookCode(), book.getQuantity() + 1);
        }
        borrowingDAO.updateReturnRequestStatus(borrowingCode, "Đã trả");
    }

    @Override
    public void rejectReturnRequest(int borrowingCode) {
        borrowingDAO.updateReturnRequestStatus(borrowingCode, "Đang mượn");
    }

    @Override
    public void returnBook(int id) {
        Borrowing borrowing = borrowingDAO.findById(id);
        if (borrowing == null || borrowing.getBook() == null) {
            return;
        }

        Book book = bookDAO.findById(borrowing.getBook().getBookCode());
        if (book != null) {
            bookDAO.updateQuantity(book.getBookCode(), book.getQuantity() + 1);
        }
        borrowingDAO.updateStatus(id, "Đã trả");
    }

    @Override
    public void returnBook(int id, String returnDate, String status) {
        Borrowing borrowing = borrowingDAO.findById(id);
        if (borrowing == null || borrowing.getBook() == null) {
            return;
        }

        String finalStatus = (status == null || status.trim().isEmpty()) ? "Chờ duyệt trả" : status.trim();
        String finalReturnDate = (returnDate == null || returnDate.trim().isEmpty())
                ? LocalDate.now().toString()
                : returnDate.trim();
        borrowingDAO.updateReturnInfo(id, finalStatus, finalReturnDate);
    }
}
