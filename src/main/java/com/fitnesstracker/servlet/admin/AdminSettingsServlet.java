package com.fitnesstracker.servlet.admin;

import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.SystemSettingsService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.SystemSettingsServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AdminSettingsServlet", urlPatterns = {"/admin/settings", "/admin-actions/settings/save"})
public class AdminSettingsServlet extends HttpServlet {

    private final SystemSettingsService settingsService = new SystemSettingsServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, String> settings = settingsService.getAllSettings();
        req.setAttribute("settings", settings);
        req.getRequestDispatcher("/admin/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User admin = (User) session.getAttribute("currentUser");

        try {
            Map<String, String> settings = new HashMap<>();
            settings.put("app_name", req.getParameter("app_name"));
            settings.put("allow_registration", req.getParameter("allow_registration") != null ? "true" : "false");
            settings.put("challenges_enabled", req.getParameter("challenges_enabled") != null ? "true" : "false");
            settings.put("content_moderation", req.getParameter("content_moderation") != null ? "true" : "false");
            settings.put("max_challenge_days", req.getParameter("max_challenge_days"));
            settings.put("default_calorie_target", req.getParameter("default_calorie_target"));

            settingsService.updateSettings(settings);

            activityLogService.logActivity(admin.getId(), "SETTINGS_UPDATED",
                    "Updated application system configuration parameters", req.getRemoteAddr());

            session.setAttribute("flashMessage", FlashMessage.success("System configurations updated successfully!"));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to update system settings: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/settings");
    }
}
