/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.impl;

import DAO.PenaltyDAO;
import model.Penalty;
import service.PenaltyService;
import java.util.List;

public class PenaltyServiceImpl extends PenaltyService {
    private final PenaltyDAO penaltyDAO;
    private static PenaltyServiceImpl instance;

    private PenaltyServiceImpl() {
        penaltyDAO = PenaltyDAO.getInstance();
    }

    public static PenaltyServiceImpl getInstance() {
        if (instance == null) {
            instance = new PenaltyServiceImpl();
        }
        return instance;
    }

    @Override
    public void add(Penalty e) {
        // Logic nghiệp vụ: Đảm bảo khi tạo phiếu phạt luôn ở trạng thái "Chưa thanh toán"
        if (e.getStatus() == null || e.getStatus().isEmpty()) {
            e.setStatus("Chưa thanh toán");
        }
        penaltyDAO.createPenalty(e);
    }

  @Override
public void update(Penalty e, int id) {
    // Đảm bảo đối tượng Penalty có ID đúng trước khi gửi xuống DAO
    e.setPenaltyCode(id); 
    
    // Gọi hàm update toàn bộ các trường thay vì chỉ updateStatus
    penaltyDAO.update(e); 
}

    @Override
    public void delete(int id) {
        // Xóa phiếu phạt nếu có sai sót dữ liệu
        penaltyDAO.delete(id);
    }

    @Override
    public List<Penalty> findAll() {
        // Trả về toàn bộ danh sách phiếu phạt để Admin quản lý
        return penaltyDAO.findAll();
    }

   @Override
public Penalty findById(int id) {
    // Phải gọi xuống DAO để lấy dữ liệu thay vì return null
    return penaltyDAO.findById(id); 
}

    // Thêm hàm lấy phiếu phạt theo UserID để hiển thị ở trang cá nhân của User
    public List<Penalty> getPenaltiesByUser(int userId) {
        return penaltyDAO.findByUserId(userId);
    }
}