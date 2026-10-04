package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.User;
import com.fitnesstracker.service.AnalyticsService;
import com.fitnesstracker.service.impl.AnalyticsServiceImpl;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/user/dashboard"})
public class DashboardServlet extends HttpServlet {

    private final AnalyticsService analyticsService = new AnalyticsServiceImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        Map<String, Object> summary = analyticsService.getUserDashboardSummary(currentUser.getId());

        // Pass structured metrics and collections to JSP
        req.setAttribute("summary", summary);
        req.setAttribute("recentWorkouts", summary.get("recentWorkouts"));
        req.setAttribute("activeGoals", summary.get("activeGoals"));
        req.setAttribute("joinedChallenges", summary.get("joinedChallenges"));
        req.setAttribute("recommendations", summary.get("recommendations"));

        // Convert chart map models to JSON strings for frontend Chart.js rendering
        req.setAttribute("weeklyDurationJson", gson.toJson(summary.get("weeklyDurationMap")));
        req.setAttribute("monthlyDurationJson", gson.toJson(summary.get("monthlyDurationMap")));
        req.setAttribute("weeklyCaloriesJson", gson.toJson(summary.get("weeklyCaloriesMap")));
        req.setAttribute("workoutTypeJson", gson.toJson(summary.get("workoutTypeMap")));

        req.getRequestDispatcher("/user/dashboard.jsp").forward(req, resp);
    }
}
