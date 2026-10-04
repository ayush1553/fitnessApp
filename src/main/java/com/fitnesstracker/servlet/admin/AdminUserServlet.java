package com.fitnesstracker.servlet.admin;

import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.UserService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.UserServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserServlet", urlPatterns = {
        "/admin/users",
        "/admin-actions/user/status",
        "/admin-actions/user/role",
        "/admin-actions/user/delete"
})
public class AdminUserServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = req.getParameter("q");
        String role = req.getParameter("role");
        String status = req.getParameter("status");

        List<User> users;
        if (query != null || role != null || status != null) {
            users = userService.searchUsers(query, role, status);
        } else {
            users = userService.getAllUsers();
        }

        req.setAttribute("users", users);
        req.setAttribute("selectedQuery", query);
        req.setAttribute("selectedRole", role);
        req.setAttribute("selectedStatus", status);

        req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User admin = (User) session.getAttribute("currentUser");
        String path = req.getServletPath();

        try {
            int targetUserId = Integer.parseInt(req.getParameter("userId"));

            if ("/admin-actions/user/status".equals(path)) {
                String newStatus = req.getParameter("status");
                userService.updateUserStatus(targetUserId, newStatus);
                activityLogService.logActivity(admin.getId(), "USER_STATUS_CHANGE",
                        "Changed status of user ID " + targetUserId + " to " + newStatus, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("User status updated to " + newStatus));
            } else if ("/admin-actions/user/role".equals(path)) {
                String newRole = req.getParameter("role");
                userService.updateUserRole(targetUserId, newRole);
                activityLogService.logActivity(admin.getId(), "USER_ROLE_CHANGE",
                        "Changed role of user ID " + targetUserId + " to " + newRole, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("User role updated to " + newRole));
            } else if ("/admin-actions/user/delete".equals(path)) {
                if (targetUserId == admin.getId()) {
                    session.setAttribute("flashMessage", FlashMessage.error("You cannot delete your own admin account!"));
                } else {
                    userService.deleteUser(targetUserId);
                    activityLogService.logActivity(admin.getId(), "USER_DELETED",
                            "Deleted user ID: " + targetUserId, req.getRemoteAddr());
                    session.setAttribute("flashMessage", FlashMessage.success("User deleted successfully."));
                }
            }
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Admin user action failed: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
