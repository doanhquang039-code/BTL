package DAO;

import java.math.BigDecimal;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private Connection connection;
    private static UserDAO instance;

    private UserDAO() {
        try {
            connection = MyConnection.getInstance();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static UserDAO getInstance() {
        if (instance == null) {
            instance = new UserDAO();
        }
        return instance;
    }

    private void refreshConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = MyConnection.getInstance();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public User checkLogin(String username, String password) {
        refreshConnection();
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> findAll() {
        refreshConnection();
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void add(User user) {
        refreshConnection();
        if (hasUserColumn("birth_date")) {
            addFull(user);
            return;
        }

        String sql = "INSERT INTO Users (usercode, username, password, fullname, role) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, nextId("Users", "usercode"));
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getRole());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void addFull(User user) {
        String sql = "INSERT INTO Users (usercode, username, password, fullname, role, birth_date, position, address, identity_number, card_issue_date, card_expiry_date, deposit_amount, max_borrow_books) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, nextId("Users", "usercode"));
            fillUserStatement(ps, user, 2);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(User user) {
        refreshConnection();
        if (hasUserColumn("birth_date")) {
            updateFull(user);
            return;
        }

        String sql = "UPDATE Users SET fullname = ?, role = ?, password = ? WHERE usercode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getRole());
            ps.setString(3, user.getPassword());
            ps.setInt(4, user.getUserCode());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateFull(User user) {
        String sql = "UPDATE Users SET username = ?, password = ?, fullname = ?, role = ?, birth_date = ?, position = ?, address = ?, " +
                "identity_number = ?, card_issue_date = ?, card_expiry_date = ?, deposit_amount = ?, max_borrow_books = ? WHERE usercode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            fillUserStatement(ps, user, 1);
            ps.setInt(13, user.getUserCode());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        refreshConnection();
        String sql = "DELETE FROM Users WHERE usercode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public User findById(int id) {
        refreshConnection();
        String sql = "SELECT * FROM Users WHERE usercode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> searchByName(String name) {
        refreshConnection();
        List<User> list = new ArrayList<>();
        String keyword = name == null ? "" : name.trim();
        String sql = "SELECT * FROM Users WHERE fullname LIKE ? OR username LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean checkUsernameExists(String username) {
        refreshConnection();
        String sql = "SELECT 1 FROM Users WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countTotalUsers() {
        refreshConnection();
        String sql = "SELECT COUNT(*) FROM Users WHERE role <> 'Admin'";
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

    public void register(User user) {
        refreshConnection();
        String sql = "INSERT INTO Users (usercode, username, password, fullname, role) VALUES (?, ?, ?, ?, 'user')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, nextId("Users", "usercode"));
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFullName());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int countAll() {
        refreshConnection();
        String sql = "SELECT COUNT(*) FROM Users";
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

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserCode(rs.getInt("usercode"));
        user.setUsername(rs.getString("username"));
        user.setPassword(getStringIfExists(rs, "password"));
        user.setFullName(rs.getString("fullname"));
        user.setRole(rs.getString("role"));
        user.setBirthDate(getStringIfExists(rs, "birth_date"));
        user.setPosition(getStringIfExists(rs, "position"));
        user.setAddress(getStringIfExists(rs, "address"));
        user.setIdentityNumber(getStringIfExists(rs, "identity_number"));
        user.setCardIssueDate(getStringIfExists(rs, "card_issue_date"));
        user.setCardExpiryDate(getStringIfExists(rs, "card_expiry_date"));
        user.setDepositAmount(getBigDecimalIfExists(rs, "deposit_amount"));
        user.setMaxBorrowBooks(getIntIfExists(rs, "max_borrow_books"));
        return user;
    }

    private void fillUserStatement(PreparedStatement ps, User user, int startIndex) throws SQLException {
        ps.setString(startIndex, user.getUsername());
        ps.setString(startIndex + 1, user.getPassword());
        ps.setString(startIndex + 2, user.getFullName());
        ps.setString(startIndex + 3, user.getRole());
        setDateOrNull(ps, startIndex + 4, user.getBirthDate());
        ps.setString(startIndex + 5, user.getPosition());
        ps.setString(startIndex + 6, user.getAddress());
        ps.setString(startIndex + 7, user.getIdentityNumber());
        setDateOrNull(ps, startIndex + 8, user.getCardIssueDate());
        setDateOrNull(ps, startIndex + 9, user.getCardExpiryDate());
        ps.setBigDecimal(startIndex + 10, user.getDepositAmount() == null ? BigDecimal.ZERO : user.getDepositAmount());
        ps.setInt(startIndex + 11, user.getMaxBorrowBooks() <= 0 ? 5 : user.getMaxBorrowBooks());
    }

    private void setDateOrNull(PreparedStatement ps, int index, String value) throws SQLException {
        if (value == null || value.trim().isEmpty()) {
            ps.setNull(index, Types.DATE);
        } else {
            ps.setDate(index, Date.valueOf(value.trim()));
        }
    }

    private boolean hasUserColumn(String columnName) {
        try {
            DatabaseMetaData metaData = connection.getMetaData();
            try (ResultSet rs = metaData.getColumns(null, null, "Users", columnName)) {
                if (rs.next()) return true;
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

    private BigDecimal getBigDecimalIfExists(ResultSet rs, String columnName) throws SQLException {
        return hasColumn(rs, columnName) ? rs.getBigDecimal(columnName) : BigDecimal.ZERO;
    }

    private int getIntIfExists(ResultSet rs, String columnName) throws SQLException {
        return hasColumn(rs, columnName) ? rs.getInt(columnName) : 0;
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
