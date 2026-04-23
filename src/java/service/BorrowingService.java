package service;

import common.Activity;
import common.Search;
import model.Borrowing;
import model.BorrowingDetail;

public abstract class BorrowingService implements Activity<Borrowing>, Search<Borrowing> {
    public abstract void borrowBook(int userCode, int bookCode);
    public abstract void requestBorrowBook(int userCode, int bookCode);
    public abstract void requestBorrowBook(Borrowing borrowing);
    public abstract void approveBorrowRequest(int borrowingCode);
    public abstract void rejectBorrowRequest(int borrowingCode);
    public abstract void approveReturnRequest(int borrowingCode);
    public abstract void rejectReturnRequest(int borrowingCode);
    public abstract void returnBook(int id);
    public abstract void returnBook(int id, String returnDate, String status);
    public abstract BorrowingDetail findDetailById(int id);
}
