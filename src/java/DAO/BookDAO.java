package DAO;

import java.math.BigDecimal;
import model.Book;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BookDAO {
    private Connection connection;
    private static BookDAO instance;

    private BookDAO() {
        try {
            connection = MyConnection.getInstance();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static BookDAO getInstance() {
        if (instance == null) {
            instance = new BookDAO();
        }
        return instance;
    }

    public List<Book> findAll() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS catName FROM Books b LEFT JOIN Categories c ON b.category_code = c.categorycode";
        if (hasBookColumn("is_active")) {
            sql += " WHERE b.is_active = 1";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void add(Book book) {
        if (hasBookColumn("publisher")) {
            addFull(book);
            return;
        }

        String sql = "INSERT INTO Books (bookcode, title, author, category_code, publish_year, quantity, image) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, nextId("Books", "bookcode"));
            ps.setString(2, book.getTitle());
            ps.setString(3, book.getAuthor());
            ps.setInt(4, book.getCategory().getCategoryCode());
            ps.setString(5, book.getPublishYear());
            ps.setInt(6, book.getQuantity());
            ps.setString(7, book.getImage());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void addFull(Book book) {
        String sql = "INSERT INTO Books (bookcode, title, author, category_code, publisher, publish_year, price, page_count, shelf_location, quantity, image) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, nextId("Books", "bookcode"));
            fillBookStatement(ps, book, 2);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Book book, int id) {
        if (hasBookColumn("publisher")) {
            updateFull(book, id);
            return;
        }

        String sql = "UPDATE Books SET title = ?, author = ?, category_code = ?, publish_year = ?, quantity = ?, image = ? WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setInt(3, book.getCategory().getCategoryCode());
            ps.setString(4, book.getPublishYear());
            ps.setInt(5, book.getQuantity());
            ps.setString(6, book.getImage());
            ps.setInt(7, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateFull(Book book, int id) {
        String sql = "UPDATE Books SET title = ?, author = ?, category_code = ?, publisher = ?, publish_year = ?, " +
                "price = ?, page_count = ?, shelf_location = ?, quantity = ?, image = ? WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            fillBookStatement(ps, book, 1);
            ps.setInt(11, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void fillBookStatement(PreparedStatement ps, Book book, int startIndex) throws SQLException {
        ps.setString(startIndex, book.getTitle());
        ps.setString(startIndex + 1, book.getAuthor());
        ps.setInt(startIndex + 2, book.getCategory().getCategoryCode());
        ps.setString(startIndex + 3, book.getPublisher());
        ps.setString(startIndex + 4, book.getPublishYear());
        if (book.getPrice() == null) {
            ps.setBigDecimal(startIndex + 5, BigDecimal.ZERO);
        } else {
            ps.setBigDecimal(startIndex + 5, book.getPrice());
        }
        ps.setInt(startIndex + 6, book.getPageCount());
        ps.setString(startIndex + 7, book.getShelfLocation());
        ps.setInt(startIndex + 8, book.getQuantity());
        ps.setString(startIndex + 9, book.getImage());
    }

    public void delete(int id) {
        String sql = "DELETE FROM Books WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            if (hasBookColumn("is_active")) {
                softDelete(id);
                return;
            }
            deleteDependencies(id);
            retryDelete(id);
        }
    }

    private void softDelete(int id) {
        String sql = "UPDATE Books SET is_active = 0 WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    private void retryDelete(int id) {
        String sql = "DELETE FROM Books WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    private void deleteDependencies(int bookCode) {
        executeIfTableExists("DELETE FROM penalties WHERE borrowing_code IN (SELECT borrowingcode FROM borrowings WHERE book_bookcode = ?)", bookCode);
        executeIfTableExists("DELETE FROM borrowings WHERE book_bookcode = ?", bookCode);
        executeIfTableExists("DELETE FROM reservations WHERE book_code = ?", bookCode);
        executeIfTableExists("DELETE FROM book_imports WHERE book_code = ?", bookCode);
        executeIfTableExists("DELETE FROM book_authors WHERE book_code = ?", bookCode);
    }

    private void executeIfTableExists(String sql, int bookCode) {
        String tableName = extractTableName(sql);
        if (tableName.isEmpty() || !tableExists(tableName)) {
            return;
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookCode);
            ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    private String extractTableName(String sql) {
        String normalized = sql.toLowerCase();
        int fromIndex = normalized.indexOf("from ");
        if (fromIndex < 0) {
            return "";
        }
        String[] parts = normalized.substring(fromIndex + 5).trim().split("\\s+");
        if (parts.length == 0) {
            return "";
        }
        return parts[0].replace("`", "").trim();
    }

    public Book findById(int id) {
        String sql = "SELECT b.*, c.name AS catName FROM Books b LEFT JOIN Categories c ON b.category_code = c.categorycode WHERE b.bookcode = ?";
        if (hasBookColumn("is_active")) {
            sql += " AND b.is_active = 1";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBook(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Book> searchByName(String keyword) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS catName FROM Books b " +
                "LEFT JOIN Categories c ON b.category_code = c.categorycode " +
                "WHERE b.title LIKE ? OR b.author LIKE ? OR b.publish_year LIKE ?";
        if (hasBookColumn("publisher")) {
            sql += " OR b.publisher LIKE ?";
        }
        if (hasBookColumn("is_active")) {
            sql = "SELECT b.*, c.name AS catName FROM Books b " +
                    "LEFT JOIN Categories c ON b.category_code = c.categorycode " +
                    "WHERE b.is_active = 1 AND (b.title LIKE ? OR b.author LIKE ? OR b.publish_year LIKE ?";
            if (hasBookColumn("publisher")) {
                sql += " OR b.publisher LIKE ?";
            }
            sql += ")";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String pattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            if (hasBookColumn("publisher")) {
                ps.setString(4, pattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBook(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookCode(rs.getInt("bookcode"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setQuantity(rs.getInt("quantity"));
        book.setImage(normalizeImagePath(getStringIfExists(rs, "image")));
        book.setPublishYear(getStringIfExists(rs, "publish_year"));
        book.setPublisher(getStringIfExists(rs, "publisher"));
        book.setPrice(getBigDecimalIfExists(rs, "price"));
        book.setPageCount(getIntIfExists(rs, "page_count"));
        book.setShelfLocation(getStringIfExists(rs, "shelf_location"));
        book.setTotalImported(getIntIfExists(rs, "total_imported"));

        Category category = new Category(rs.getInt("category_code"), rs.getString("catName"));
        book.setCategory(category);
        return book;
    }

    public void updateQuantity(int bookCode, int updatedQty) {
        String sql = "UPDATE Books SET quantity = ? WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, updatedQty);
            ps.setInt(2, bookCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStock(int bookCode, int quantity) {
        String sql = "UPDATE Books SET quantity = quantity + ? WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, bookCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStockAfterImport(int bookCode, int quantity) {
        String sql = "UPDATE Books SET quantity = quantity + ?, total_imported = total_imported + ? WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, quantity);
            ps.setInt(3, bookCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateFullStock(int bookCode, int delta) {
        String sql = "UPDATE Books SET quantity = quantity + ? WHERE bookcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setInt(2, bookCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int countTotalBooksInStock() {
        String sql = "SELECT SUM(quantity) FROM Books";
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

    public int countBookTitles() {
        String sql = "SELECT COUNT(*) FROM Books";
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

    public List<Map<String, Object>> findBorrowStatistics() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.bookcode, b.title, b.author, b.publisher, b.publish_year, c.name AS category_name, " +
                "COUNT(br.borrowingcode) AS borrow_count " +
                "FROM Books b " +
                "LEFT JOIN Categories c ON b.category_code = c.categorycode " +
                "LEFT JOIN Borrowings br ON b.bookcode = br.book_bookcode " +
                "GROUP BY b.bookcode, b.title, b.author, b.publisher, b.publish_year, c.name " +
                "ORDER BY borrow_count DESC, b.title ASC";
        if (!hasBookColumn("publisher")) {
            sql = "SELECT b.bookcode, b.title, b.author, NULL AS publisher, b.publish_year, c.name AS category_name, " +
                    "COUNT(br.borrowingcode) AS borrow_count " +
                    "FROM Books b " +
                    "LEFT JOIN Categories c ON b.category_code = c.categorycode " +
                    "LEFT JOIN Borrowings br ON b.bookcode = br.book_bookcode " +
                    "GROUP BY b.bookcode, b.title, b.author, b.publish_year, c.name " +
                    "ORDER BY borrow_count DESC, b.title ASC";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("bookCode", rs.getInt("bookcode"));
                row.put("title", rs.getString("title"));
                row.put("author", rs.getString("author"));
                row.put("publisher", rs.getString("publisher"));
                row.put("publishYear", rs.getString("publish_year"));
                row.put("categoryName", rs.getString("category_name"));
                row.put("borrowCount", rs.getInt("borrow_count"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private boolean hasBookColumn(String columnName) {
        try {
            DatabaseMetaData metaData = connection.getMetaData();
            try (ResultSet rs = metaData.getColumns(null, null, "Books", columnName)) {
                if (rs.next()) return true;
            }
            try (ResultSet rs = metaData.getColumns(null, null, "books", columnName)) {
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

    private boolean tableExists(String tableName) {
        try {
            DatabaseMetaData metaData = connection.getMetaData();
            try (ResultSet rs = metaData.getTables(null, null, tableName, null)) {
                if (rs.next()) return true;
            }
            try (ResultSet rs = metaData.getTables(null, null, tableName.toUpperCase(), null)) {
                if (rs.next()) return true;
            }
            try (ResultSet rs = metaData.getTables(null, null, tableName.toLowerCase(), null)) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    private String normalizeImagePath(String rawPath) {
        if (rawPath == null) {
            return null;
        }
        String path = rawPath.trim().replace("\\", "/");
        if (path.isEmpty()) {
            return "";
        }
        int uploadIndex = path.toLowerCase().indexOf("uploads/");
        if (uploadIndex >= 0) {
            return path.substring(uploadIndex);
        }
        if (path.startsWith("/")) {
            return path.substring(1);
        }
        return path;
    }
}
