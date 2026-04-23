package controller;

import DAO.BookDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Category;
import service.impl.CategoryServiceImpl;

@WebServlet(name = "StatisticServlet", urlPatterns = {"/statistics"})
public class StatisticServlet extends HttpServlet {
    private static final int PAGE_SIZE = 10;
    private final CategoryServiceImpl categoryService = CategoryServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = trimToEmpty(request.getParameter("keyword")).toLowerCase();
        String category = trimToEmpty(request.getParameter("category")).toLowerCase();
        String startsWith = trimToEmpty(request.getParameter("startsWith")).toUpperCase();
        int minBorrow = parseInt(request.getParameter("minBorrow"), 0);
        int page = parseInt(request.getParameter("page"), 1);

        List<Map<String, Object>> stats = BookDAO.getInstance().findBorrowStatistics();
        stats = stats.stream()
                .filter(row -> {
                    String title = valueOf(row.get("title")).toLowerCase();
                    String author = valueOf(row.get("author")).toLowerCase();
                    String publisher = valueOf(row.get("publisher")).toLowerCase();
                    String categoryName = valueOf(row.get("categoryName")).toLowerCase();
                    int borrowCount = parseInt(valueOf(row.get("borrowCount")), 0);

                    boolean keywordMatched = keyword.isEmpty()
                            || title.contains(keyword)
                            || author.contains(keyword)
                            || publisher.contains(keyword);
                    boolean categoryMatched = category.isEmpty() || categoryName.contains(category);
                    boolean countMatched = borrowCount >= minBorrow;
                    boolean startsWithMatched = startsWith.isEmpty() || title.toUpperCase().startsWith(startsWith);
                    return keywordMatched && categoryMatched && countMatched && startsWithMatched;
                })
                .collect(Collectors.toList());

        int totalItems = stats.size();
        int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
        page = Math.max(1, Math.min(page, totalPages));
        int fromIndex = (page - 1) * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalItems);
        List<Map<String, Object>> paged = totalItems == 0 ? List.of() : stats.subList(fromIndex, toIndex);

        request.setAttribute("keyword", request.getParameter("keyword"));
        request.setAttribute("category", request.getParameter("category"));
        request.setAttribute("startsWith", startsWith);
        request.setAttribute("minBorrow", minBorrow);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("totalItems", totalItems);
        List<Category> categories = categoryService.findAll();
        request.setAttribute("categories", categories);
        request.setAttribute("bookStats", paged);
        request.getRequestDispatcher("/admin/statistics.jsp").forward(request, response);
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private String valueOf(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(trimToEmpty(value));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
