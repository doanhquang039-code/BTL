package DAO;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Book;
import model.Borrowing;
import model.BorrowingDetail;
import model.User;

public class BorrowingDAO {
    private Connection connection;
    private static BorrowingDAO instance;

    private BorrowingDAO() {
        try {
            connection = MyConnection.getInstance();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static BorrowingDAO getInstance() {
        if (instance == null) {
            instance = new BorrowingDAO();
        }
        return instance;
    }

    public void addBorrowing(Borrowing borrowing) {
        String sql = "INSERT INTO Borrowings (borrowingcode, user_code, book_bookcode, borrow_date, due_date, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, nextId("Borrowings", "borrowingcode"));
            ps.setInt(2, borrowing.getUser().getUserCode());
            ps.setInt(3, borrowing.getBook().getBookCode());
            ps.setString(4, borrowing.getBorrowDate());
            ps.setString(5, borrowing.getDueDate());
            ps.setString(6, borrowing.getStatus() == null ? "Đang mượn" : borrowing.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Borrowing> findAll() {
        return findBySql(baseSelect() + " ORDER BY br.borrowingcode DESC");
    }

    public Borrowing findById(int id) {
        String sql = baseSelect() + " WHERE br.borrowingcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBorrowing(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Borrowing findByIdAndUserCode(int id, int userCode) {
        String sql = baseSelect() + " WHERE br.borrowingcode = ? AND br.user_code = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBorrowing(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public BorrowingDetail findDetailById(int id) {
        String sql = baseSelect() + " WHERE br.borrowingcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBorrowingDetail(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Borrowing> findByUserCode(int userCode) {
        List<Borrowing> list = new ArrayList<>();
        String sql = baseSelect() + " WHERE br.user_code = ? ORDER BY br.borrowingcode DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userCode);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBorrowing(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Borrowing> findActiveByUserCode(int userCode) {
        List<Borrowing> list = new ArrayList<>();
        String sql = baseSelect() + " WHERE br.user_code = ? AND br.status = 'Đang mượn' ORDER BY br.borrowingcode DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userCode);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBorrowing(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Borrowing> findPendingRequests() {
        return findBySql(baseSelect() + " WHERE br.status IN ('Chờ duyệt', 'Chờ duyệt trả') ORDER BY br.borrowingcode DESC");
    }

    public List<Borrowing> searchByName(String keyword) {
        List<Borrowing> list = new ArrayList<>();
        String pattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";
        String sql = baseSelect() + " WHERE u.fullname LIKE ? OR bk.title LIKE ? ORDER BY br.borrowingcode DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBorrowing(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean hasPendingRequest(int userCode, int bookCode) {
        String sql = "SELECT 1 FROM Borrowings WHERE user_code = ? AND book_bookcode = ? AND status = 'Chờ duyệt'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userCode);
            ps.setInt(2, bookCode);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void update(Borrowing borrowing) {
        String sql = "UPDATE Borrowings SET user_code = ?, book_bookcode = ?, borrow_date = ?, due_date = ?, status = ? WHERE borrowingcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, borrowing.getUser().getUserCode());
            ps.setInt(2, borrowing.getBook().getBookCode());
            ps.setString(3, borrowing.getBorrowDate());
            ps.setString(4, borrowing.getDueDate());
            ps.setString(5, borrowing.getStatus());
            ps.setInt(6, borrowing.getBorrowingCode());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(int borrowingCode, String status) {
        String sql = "UPDATE Borrowings SET status = ?, return_date = CASE WHEN ? = 'Đã trả' THEN CURRENT_DATE ELSE return_date END WHERE borrowingcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setInt(3, borrowingCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateReturnInfo(int borrowingCode, String status, String returnDate) {
        String sql = "UPDATE Borrowings SET status = ?, return_date = ? WHERE borrowingcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, returnDate);
            ps.setInt(3, borrowingCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateReturnRequestStatus(int borrowingCode, String status) {
        String sql = "UPDATE Borrowings SET status = ?, return_date = CASE WHEN ? = 'Đang mượn' THEN NULL ELSE return_date END WHERE borrowingcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setInt(3, borrowingCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Borrowings WHERE borrowingcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int countPendingApprovals() {
        String sql = "SELECT COUNT(*) FROM Borrowings WHERE status IN ('Chờ duyệt', 'Chờ duyệt trả')";
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

    public int countTodayBorrows() {
        String sql = "SELECT COUNT(*) FROM Borrowings WHERE DATE(borrow_date) = CURRENT_DATE";
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

    private List<Borrowing> findBySql(String sql) {
        List<Borrowing> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBorrowing(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private String baseSelect() {
        String userAddressSelect = hasUserColumn("address") ? "u.address" : "NULL";
        String userIdentitySelect = hasUserColumn("identity_number") ? "u.identity_number" : "NULL";
        return "SELECT br.*, u.fullname, u.username, " + userAddressSelect + " AS address, " + userIdentitySelect + " AS identity_number, bk.title, bk.quantity " +
                "FROM Borrowings br " +
                "LEFT JOIN Users u ON br.user_code = u.usercode " +
                "LEFT JOIN Books bk ON br.book_bookcode = bk.bookcode";
    }

    private Borrowing mapBorrowing(ResultSet rs) throws SQLException {
        Borrowing borrowing = new Borrowing();
        borrowing.setBorrowingCode(rs.getInt("borrowingcode"));

        User user = new User();
        user.setUserCode(rs.getInt("user_code"));
        user.setFullName(rs.getString("fullname"));
        borrowing.setUser(user);

        Book book = new Book();
        book.setBookCode(rs.getInt("book_bookcode"));
        book.setTitle(rs.getString("title"));
        book.setQuantity(rs.getInt("quantity"));
        borrowing.setBook(book);

        borrowing.setBorrowDate(rs.getString("borrow_date"));
        borrowing.setDueDate(rs.getString("due_date"));
        borrowing.setReturnDate(getStringIfExists(rs, "return_date"));
        borrowing.setStatus(rs.getString("status"));
        return borrowing;
    }

    private BorrowingDetail mapBorrowingDetail(ResultSet rs) throws SQLException {
        BorrowingDetail detail = new BorrowingDetail();
        detail.setBorrowingCode(rs.getInt("borrowingcode"));

        User user = new User();
        user.setUserCode(rs.getInt("user_code"));
        user.setFullName(rs.getString("fullname"));
        detail.setUser(user);

        Book book = new Book();
        book.setBookCode(rs.getInt("book_bookcode"));
        book.setTitle(rs.getString("title"));
        book.setQuantity(rs.getInt("quantity"));
        detail.setBook(book);

        detail.setBorrowDate(rs.getString("borrow_date"));
        detail.setDueDate(rs.getString("due_date"));
        detail.setReturnDate(getStringIfExists(rs, "return_date"));
        detail.setStatus(rs.getString("status"));
        detail.setUsername(getStringIfExists(rs, "username"));
        detail.setUserAddress(getStringIfExists(rs, "address"));
        detail.setIdentityNumber(getStringIfExists(rs, "identity_number"));
        return detail;
    }

    private boolean hasUserColumn(String columnName) {
        try {
            DatabaseMetaData metaData = connection.getMetaData();
            try (ResultSet rs = metaData.getColumns(null, null, "Users", columnName)) {
                if (rs.next()) {
                    return true;
                }
            }
            try (ResultSet rs = metaData.getColumns(null, null, "users", columnName)) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnLabel(i)) || columnName.equalsIgnoreCase(metaData.getColumnName(i))) {
                return true;
            }
        }
        return false;
    }

    private String getStringIfExists(ResultSet rs, String columnName) throws SQLException {
        return hasColumn(rs, columnName) ? rs.getString(columnName) : null;
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
