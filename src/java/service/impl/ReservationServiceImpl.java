package service.impl;

import DAO.ReservationDAO;
import java.time.LocalDate;
import java.util.List;
import model.Book;
import model.Reservation;
import model.User;
import service.ReservationService;

public class ReservationServiceImpl extends ReservationService {
    private final ReservationDAO reservationDAO;
    private static ReservationServiceImpl instance;

    private ReservationServiceImpl() {
        reservationDAO = ReservationDAO.getInstance();
    }

    public static ReservationServiceImpl getInstance() {
        if (instance == null) {
            instance = new ReservationServiceImpl();
        }
        return instance;
    }

    @Override
    public void add(Reservation reservation) {
        reservationDAO.createReservation(reservation);
    }

    @Override
    public void add(int userCode, int bookCode) {
        createForUser(userCode, bookCode);
    }

    @Override
    public boolean createForUser(int userCode, int bookCode) {
        User user = new User();
        user.setUserCode(userCode);

        Book book = new Book();
        book.setBookCode(bookCode);

        Reservation reservation = new Reservation();
        reservation.setUser(user);
        reservation.setBook(book);
        reservation.setReserveDate(LocalDate.now().toString());
        reservation.setStatus("Đang chờ");
        reservation.setNotified(false);

        return reservationDAO.createReservation(reservation);
    }

    @Override
    public void update(Reservation reservation, int id) {
        reservation.setReservationCode(id);
        reservationDAO.update(reservation);
    }

    @Override
    public void delete(int id) {
        reservationDAO.delete(id);
    }

    @Override
    public List<Reservation> findAll() {
        return reservationDAO.findAll();
    }

    @Override
    public Reservation findById(int id) {
        return reservationDAO.findById(id);
    }

    @Override
    public boolean existsPendingReservation(int userCode, int bookCode) {
        return reservationDAO.existsPendingReservation(userCode, bookCode);
    }

    @Override
    public boolean existsPendingReservationExcluding(int userCode, int bookCode, int reservationCode) {
        return reservationDAO.existsPendingReservationExcluding(userCode, bookCode, reservationCode);
    }

    @Override
    public List<Reservation> searchByName(String name) {
        String keyword = name == null ? "" : name.toLowerCase();
        return reservationDAO.findAll().stream()
                .filter(r -> (r.getUser() != null && r.getUser().getFullName() != null
                        && r.getUser().getFullName().toLowerCase().contains(keyword))
                        || (r.getBook() != null && r.getBook().getTitle() != null
                        && r.getBook().getTitle().toLowerCase().contains(keyword)))
                .toList();
    }
}
