package com.fitnesstracker.servlet.admin;

import com.fitnesstracker.service.AnalyticsService;
import com.fitnesstracker.service.impl.AnalyticsServiceImpl;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "AdminStatisticsServlet", urlPatterns = {"/admin/statistics"})
public class AdminStatisticsServlet extends HttpServlet {

    private final AnalyticsService analyticsService = new AnalyticsServiceImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> summary = analyticsService.getAdminDashboardSummary();

        req.setAttribute("summary", summary);
        req.setAttribute("monthlyRegistrationsJson", gson.toJson(summary.get("monthlyRegistrations")));
        req.setAttribute("workoutActivityStatsJson", gson.toJson(summary.get("workoutActivityStats")));

        req.getRequestDispatcher("/admin/statistics.jsp").forward(req, resp);
    }
}
