/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import DAO.ReservationDAO;
import model.Reservation;
import service.ReservationService;
import java.util.List;

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
    public void add(Reservation e) {
        // Mặc định khi đặt chỗ sẽ để ngày hiện tại và trạng thái "Đang chờ"
        reservationDAO.createReservation(e);
    }

  @Override
    public void update(Reservation e, int id) {
        // Đảm bảo đối tượng Reservation có đúng ID (khóa chính) trước khi update
        e.setReservationCode(id);
        
        // Gọi hàm update toàn bộ thuộc tính từ DAO
        reservationDAO.update(e);
    }
    @Override
    public void delete(int id) {
        // Hủy lượt đặt trước nếu người dùng không còn nhu cầu
        reservationDAO.delete(id);
    }

    @Override
    public List<Reservation> findAll() {
        // Lấy toàn bộ danh sách đặt chỗ để Admin theo dõi
        return reservationDAO.findAll();
    }

    @Override
    public Reservation findById(int id) {
        // Nếu cần tìm một lượt đặt chỗ cụ thể để sửa
        // Bạn có thể bổ sung findById vào DAO nếu cần thiết
        return null;
    }

    @Override
    public List<Reservation> searchByName(String name) {
        // Có thể triển khai tìm kiếm trong danh sách findAll() bằng Java Stream
        return null;
    }
}