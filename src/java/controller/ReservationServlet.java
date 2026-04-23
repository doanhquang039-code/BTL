package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Book;
import model.User;
import service.BookService;
import service.ReservationService;
import service.UserService;
import service.impl.BookServiceImpl;
import service.impl.ReservationServiceImpl;
import service.impl.UserServiceImpl;

@WebServlet(name = "ReservationServlet", urlPatterns = {"/reservations"})
public class ReservationServlet extends HttpServlet {
    private final ReservationService resService = ReservationServiceImpl.getInstance();
    private final UserService userService = UserServiceImpl.getInstance();
    private final BookService bookService = BookServiceImpl.getInstance();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("userSession");
        if (user == null || !canManageReservations(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String keyword = trimToEmpty(request.getParameter("keyword")).toLowerCase();
        String status = trimToEmpty(request.getParameter("status"));
        String startsWith = trimToEmpty(request.getParameter("startsWith")).toUpperCase();
        int page = parseInt(request.getParameter("page"), 1);
        int editId = parseInt(request.getParameter("editId"), 0);

        List<model.Reservation> allReservations = resService.findAll();
        List<User> users = userService.findAll().stream()
                .filter(u -> u.getRole() != null && u.getRole().equalsIgnoreCase("user"))
                .collect(Collectors.toList());
        List<Book> books = bookService.findAll();
        List<String> statusOptions = buildStatusOptions(allReservations);
        List<model.Reservation> reservations = allReservations;
        if (!keyword.isEmpty()) {
            reservations = reservations.stream()
                    .filter(r -> (r.getUser() != null && r.getUser().getFullName() != null
                            && r.getUser().getFullName().toLowerCase().contains(keyword))
                            || (r.getBook() != null && r.getBook().getTitle() != null
                            && r.getBook().getTitle().toLowerCase().contains(keyword))
                            || String.valueOf(r.getReservationCode()).contains(keyword))
                    .collect(Collectors.toList());
        }
        if (!status.isEmpty()) {
            reservations = reservations.stream()
                    .filter(r -> r.getStatus() != null && r.getStatus().equalsIgnoreCase(status))
                    .collect(Collectors.toList());
        }
        if (!startsWith.isEmpty()) {
            reservations = reservations.stream()
                    .filter(r -> r.getBook() != null
                            && r.getBook().getTitle() != null
                            && r.getBook().getTitle().toUpperCase().startsWith(startsWith))
                    .collect(Collectors.toList());
        }

        int totalItems = reservations.size();
        int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
        page = Math.max(1, Math.min(page, totalPages));
        int fromIndex = (page - 1) * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalItems);
        List<model.Reservation> paged = totalItems == 0 ? List.of() : reservations.subList(fromIndex, toIndex);

        request.setAttribute("keyword", request.getParameter("keyword"));
        request.setAttribute("status", status);
        request.setAttribute("statusOptions", statusOptions);
        request.setAttribute("startsWith", startsWith);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("users", users);
        request.setAttribute("books", books);
        request.setAttribute("editReservation", editId > 0 ? resService.findById(editId) : null);
        request.setAttribute("formUserCode", parseInt(request.getParameter("userCode"), 0));
        request.setAttribute("formBookCode", parseInt(request.getParameter("bookCode"), 0));
        request.setAttribute("reservations", paged);
        request.getRequestDispatcher("/admin/reservation_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("userSession");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (canManageReservations(user)) {
            String action = trimToEmpty(request.getParameter("action"));
            if ("delete".equalsIgnoreCase(action)) {
                handleAdminDelete(request, response);
                return;
            }
            if ("update".equalsIgnoreCase(action)) {
                handleAdminUpdate(request, response);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/reservations?msg=khongHoTroTaoMoi");
            return;
        }

        if (!"user".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/books?msg=chiDocGia");
            return;
        }

        int bookCode = parseInt(request.getParameter("bookCode"), 0);
        if (bookCode <= 0) {
            response.sendRedirect(request.getContextPath() + "/books?msg=khongHopLe");
            return;
        }

        Book selectedBook = bookService.findById(bookCode);
        if (selectedBook == null) {
            response.sendRedirect(request.getContextPath() + "/books?msg=khongHopLe");
            return;
        }

        if (selectedBook.getQuantity() > 0) {
            response.sendRedirect(request.getContextPath() + "/books?msg=sachConTrongKho");
            return;
        }

        if (resService.existsPendingReservation(user.getUserCode(), bookCode)) {
            response.sendRedirect(request.getContextPath() + "/books?msg=daCoDatTruoc");
            return;
        }

        boolean created = resService.createForUser(user.getUserCode(), bookCode);
        if (!created) {
            response.sendRedirect(request.getContextPath() + "/books?msg=datTruocThatBai");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/books?msg=datTruocThanhCong");
    }

    private void handleAdminDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int reservationCode = parseInt(request.getParameter("reservationCode"), 0);
        if (reservationCode <= 0 || resService.findById(reservationCode) == null) {
            response.sendRedirect(request.getContextPath() + "/reservations?msg=maKhongHopLe");
            return;
        }
        resService.delete(reservationCode);
        response.sendRedirect(request.getContextPath() + "/reservations?msg=xoaThanhCong");
    }

    private void handleAdminUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int reservationCode = parseInt(request.getParameter("reservationCode"), 0);
        int userCode = parseInt(request.getParameter("userCode"), 0);
        int bookCode = parseInt(request.getParameter("bookCode"), 0);
        String status = trimToEmpty(request.getParameter("status"));

        if (reservationCode <= 0 || userCode <= 0 || bookCode <= 0 || status.isEmpty()) {
            response.sendRedirect(buildReservationRedirectUrl(request, "thieuDuLieuCapNhat", userCode, bookCode)
                    + "&editId=" + reservationCode);
            return;
        }

        model.Reservation existing = resService.findById(reservationCode);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/reservations?msg=maKhongHopLe");
            return;
        }

        User selectedUser = userService.findById(userCode);
        Book selectedBook = bookService.findById(bookCode);
        if (selectedUser == null || selectedUser.getRole() == null || !selectedUser.getRole().equalsIgnoreCase("user")
                || selectedBook == null) {
            response.sendRedirect(buildReservationRedirectUrl(request, "duLieuCapNhatKhongHopLe", userCode, bookCode)
                    + "&editId=" + reservationCode);
            return;
        }

        if ("Đang chờ".equalsIgnoreCase(status)
                && resService.existsPendingReservationExcluding(userCode, bookCode, reservationCode)) {
            response.sendRedirect(buildReservationRedirectUrl(request, "trungYeuCau", userCode, bookCode)
                    + "&editId=" + reservationCode);
            return;
        }

        model.Reservation updated = new model.Reservation();
        updated.setUser(selectedUser);
        updated.setBook(selectedBook);
        updated.setReserveDate(existing.getReserveDate());
        updated.setStatus(status);
        updated.setNotified(existing.isNotified());
        resService.update(updated, reservationCode);
        response.sendRedirect(request.getContextPath() + "/reservations?msg=capNhatThanhCong");
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(trimToEmpty(value));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private List<String> buildStatusOptions(List<model.Reservation> reservations) {
        Map<String, String> normalizedMap = new LinkedHashMap<>();
        for (model.Reservation reservation : reservations) {
            String currentStatus = reservation.getStatus();
            if (currentStatus == null || currentStatus.trim().isEmpty()) {
                continue;
            }
            String normalized = currentStatus.trim().toLowerCase();
            normalizedMap.putIfAbsent(normalized, currentStatus.trim());
        }
        return new ArrayList<>(normalizedMap.values());
    }

    private String buildReservationRedirectUrl(HttpServletRequest request, String msg, int userCode, int bookCode) {
        String encodedMsg = URLEncoder.encode(msg, StandardCharsets.UTF_8);
        return request.getContextPath() + "/reservations?msg=" + encodedMsg
                + "&userCode=" + userCode + "&bookCode=" + bookCode;
    }

    private boolean canManageReservations(User user) {
        return user != null
                && ("admin".equalsIgnoreCase(user.getRole())
                || "manager".equalsIgnoreCase(user.getRole()));
    }
}
