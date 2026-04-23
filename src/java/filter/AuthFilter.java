package filter;

import DAO.UserDAO;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebFilter(urlPatterns = {
    "/admin/*",
    "/manager/*",
    "/user/*",
    "/admin-dashboard",
    "/dashboard",
    "/manager-dash",
    "/manager-report",
    "/user-dashboard",
    "/approvals",
    "/borrow-request",
    "/history",
    "/profile",
    "/users",
    "/imports",
    "/penalties",
    "/reservations",
    "/borrows",
    "/categories",
    "/statistics",
    "/books"
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization required.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("userSession") : null;
        String path = req.getServletPath();
        String role = resolveRole(user, session);

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (isAdminArea(path) && !"admin".equalsIgnoreCase(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (isManagerArea(path) && !("manager".equalsIgnoreCase(role) || "admin".equalsIgnoreCase(role))) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (isUserArea(path) && !"user".equalsIgnoreCase(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No resource cleanup required.
    }

    private boolean isAdminArea(String path) {
        return path.startsWith("/admin/")
                || "/admin-dashboard".equals(path)
                || "/dashboard".equals(path)
                || "/users".equals(path)
                || "/imports".equals(path)
                || "/borrows".equals(path)
                || "/statistics".equals(path)
                || "/categories".equals(path);
    }

    private boolean isManagerArea(String path) {
        return path.startsWith("/manager/")
                || "/manager-dash".equals(path)
                || "/manager-report".equals(path)
                || "/approvals".equals(path)
                || "/penalties".equals(path);
    }

    private boolean isUserArea(String path) {
        return path.startsWith("/user/")
                || "/user-dashboard".equals(path)
                || "/history".equals(path)
                || "/profile".equals(path);
    }

    private String normalizeRole(String role) {
        if (role == null) {
            return "";
        }
        return role.trim().toLowerCase();
    }

    private String resolveRole(User sessionUser, HttpSession session) {
        if (sessionUser == null) {
            return "";
        }

        User dbUser = UserDAO.getInstance().findById(sessionUser.getUserCode());
        if (dbUser != null) {
            if (session != null) {
                session.setAttribute("userSession", dbUser);
            }
            return normalizeRole(dbUser.getRole());
        }

        return normalizeRole(sessionUser.getRole());
    }
}
