package controller;

import DAO.UserDAO;
import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User current = (User) request.getSession().getAttribute("userSession");
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User profileUser = UserDAO.getInstance().findById(current.getUserCode());
        if (profileUser == null) {
            profileUser = current;
        } else {
            // Keep role/session-critical fields stable when DB value is unexpectedly empty.
            if (profileUser.getRole() == null || profileUser.getRole().trim().isEmpty()) {
                profileUser.setRole(current.getRole());
            }
            if (profileUser.getUsername() == null || profileUser.getUsername().trim().isEmpty()) {
                profileUser.setUsername(current.getUsername());
            }
        }

        request.setAttribute("profileUser", profileUser);
        request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User current = (User) session.getAttribute("userSession");
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = UserDAO.getInstance().findById(current.getUserCode());
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/profile?msg=error");
            return;
        }

        user.setFullName(request.getParameter("fullName"));
        user.setPassword(emptyToDefault(request.getParameter("password"), user.getPassword()));
        user.setBirthDate(request.getParameter("birthDate"));
        user.setPosition(request.getParameter("position"));
        user.setAddress(request.getParameter("address"));
        user.setIdentityNumber(request.getParameter("identityNumber"));
        user.setCardIssueDate(request.getParameter("cardIssueDate"));
        user.setCardExpiryDate(request.getParameter("cardExpiryDate"));
        user.setDepositAmount(parseBigDecimal(request.getParameter("depositAmount")));
        user.setMaxBorrowBooks(parseInt(request.getParameter("maxBorrowBooks"), 5));
        if (user.getRole() == null || user.getRole().trim().isEmpty()) {
            user.setRole(current.getRole());
        }

        UserDAO.getInstance().update(user);

        User refreshedUser = UserDAO.getInstance().findById(current.getUserCode());
        if (refreshedUser == null) {
            refreshedUser = user;
        }
        if (refreshedUser.getRole() == null || refreshedUser.getRole().trim().isEmpty()) {
            refreshedUser.setRole(current.getRole());
        }
        session.setAttribute("userSession", refreshedUser);
        response.sendRedirect(request.getContextPath() + "/profile?msg=updated");
    }

    private String emptyToDefault(String value, String defaultValue) {
        return value == null || value.trim().isEmpty() ? defaultValue : value.trim();
    }

    private BigDecimal parseBigDecimal(String value) {
        if (value == null || value.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

    private int parseInt(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
