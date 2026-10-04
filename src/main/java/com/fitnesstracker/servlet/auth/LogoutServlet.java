package com.fitnesstracker.servlet.auth;

import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/auth/logout", "/logout"})
public class LogoutServlet extends HttpServlet {

    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user != null) {
                activityLogService.logActivity(user.getId(), "LOGOUT", "User logged out", req.getRemoteAddr());
            }
            session.invalidate();
        }

        HttpSession newSession = req.getSession(true);
        newSession.setAttribute("flashMessage", FlashMessage.info("You have been signed out successfully."));
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
