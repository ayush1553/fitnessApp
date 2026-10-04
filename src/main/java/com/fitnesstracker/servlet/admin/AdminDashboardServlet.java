package com.fitnesstracker.servlet.admin;

import com.fitnesstracker.model.ActivityLog;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.AnalyticsService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.AnalyticsServiceImpl;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final AnalyticsService analyticsService = new AnalyticsServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> summary = analyticsService.getAdminDashboardSummary();
        List<ActivityLog> recentLogs = activityLogService.getRecentLogs(8);

        req.setAttribute("summary", summary);
        req.setAttribute("recentLogs", recentLogs);
        req.setAttribute("pendingContent", summary.get("pendingContent"));

        req.setAttribute("monthlyRegistrationsJson", gson.toJson(summary.get("monthlyRegistrations")));
        req.setAttribute("workoutActivityStatsJson", gson.toJson(summary.get("workoutActivityStats")));

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}
