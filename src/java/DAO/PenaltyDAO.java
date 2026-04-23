package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Borrowing;
import model.Penalty;
import model.User;

public class PenaltyDAO {
    private Connection connection;
    private static PenaltyDAO instance;

    private PenaltyDAO() {
        try {
            connection = MyConnection.getInstance();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static PenaltyDAO getInstance() {
        if (instance == null) {
            instance = new PenaltyDAO();
        }
        return instance;
    }

    public void createPenalty(Penalty penalty) {
        String sql = "INSERT INTO Penalties (penaltiecode, user_code, borrowing_code, amount, reason, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, nextId("Penalties", "penaltiecode"));
            ps.setInt(2, penalty.getUser().getUserCode());
            setBorrowingCode(ps, 3, penalty);
            ps.setBigDecimal(4, penalty.getAmount());
            ps.setString(5, penalty.getReason());
            ps.setString(6, penalty.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Penalty> findAll() {
        List<Penalty> list = new ArrayList<>();
        String sql = "SELECT p.*, u.fullname, b.borrowingcode " +
                "FROM Penalties p " +
                "LEFT JOIN Users u ON p.user_code = u.usercode " +
                "LEFT JOIN Borrowings b ON p.borrowing_code = b.borrowingcode " +
                "ORDER BY p.penaltiecode DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapPenalty(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void update(Penalty penalty) {
        String sql = "UPDATE Penalties SET user_code = ?, borrowing_code = ?, amount = ?, reason = ?, status = ? WHERE penaltiecode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, penalty.getUser().getUserCode());
            setBorrowingCode(ps, 2, penalty);
            ps.setBigDecimal(3, penalty.getAmount());
            ps.setString(4, penalty.getReason());
            ps.setString(5, penalty.getStatus());
            ps.setInt(6, penalty.getPenaltyCode());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int penaltyCode) {
        String sql = "DELETE FROM Penalties WHERE penaltiecode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, penaltyCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Penalty> findByUserId(int userId) {
        List<Penalty> list = new ArrayList<>();
        String sql = "SELECT p.*, u.fullname, b.borrowingcode " +
                "FROM Penalties p " +
                "JOIN Users u ON p.user_code = u.usercode " +
                "LEFT JOIN Borrowings b ON p.borrowing_code = b.borrowingcode " +
                "WHERE p.user_code = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPenalty(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Penalty findById(int id) {
        String sql = "SELECT p.*, u.fullname, b.borrowingcode " +
                "FROM Penalties p " +
                "LEFT JOIN Users u ON p.user_code = u.usercode " +
                "LEFT JOIN Borrowings b ON p.borrowing_code = b.borrowingcode " +
                "WHERE p.penaltiecode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPenalty(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countActivePenalties() {
        String sql = "SELECT COUNT(*) FROM Penalties WHERE status IS NULL OR status <> 'Da thanh toan'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countOverdueBooks() {
        String sql = "SELECT COUNT(*) FROM Borrowings WHERE due_date < CURRENT_DATE AND return_date IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void setBorrowingCode(PreparedStatement ps, int index, Penalty penalty) throws SQLException {
        if (penalty.getBorrowing() == null || penalty.getBorrowing().getBorrowingCode() <= 0) {
            ps.setNull(index, Types.INTEGER);
        } else {
            ps.setInt(index, penalty.getBorrowing().getBorrowingCode());
        }
    }

    private Penalty mapPenalty(ResultSet rs) throws SQLException {
        Penalty penalty = new Penalty();
        penalty.setPenaltyCode(rs.getInt("penaltiecode"));

        User user = new User();
        user.setUserCode(rs.getInt("user_code"));
        user.setFullName(rs.getString("fullname"));
        penalty.setUser(user);

        Borrowing borrowing = new Borrowing();
        borrowing.setBorrowingCode(rs.getInt("borrowing_code"));
        penalty.setBorrowing(borrowing);

        penalty.setAmount(rs.getBigDecimal("amount"));
        penalty.setReason(rs.getString("reason"));
        penalty.setStatus(rs.getString("status"));
        return penalty;
    }

    private int nextId(String tableName, String idColumn) {
        String sql = "SELECT COALESCE(MAX(" + idColumn + "), 0) + 1 FROM " + tableName;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }
}
