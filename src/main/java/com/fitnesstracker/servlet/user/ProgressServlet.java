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

@WebServlet(name = "ProgressServlet", urlPatterns = {"/user/progress"})
public class ProgressServlet extends HttpServlet {

    private final AnalyticsService analyticsService = new AnalyticsServiceImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        Map<String, Object> analytics = analyticsService.getUserProgressAnalytics(currentUser.getId());

        req.setAttribute("analytics", analytics);
        req.setAttribute("goals", analytics.get("goals"));
        req.setAttribute("participations", analytics.get("participations"));

        // JSON stringify for charts
        req.setAttribute("weeklyDurationJson", gson.toJson(analytics.get("weeklyDurationMap")));
        req.setAttribute("monthlyDurationJson", gson.toJson(analytics.get("monthlyDurationMap")));
        req.setAttribute("weeklyCaloriesJson", gson.toJson(analytics.get("weeklyCaloriesMap")));
        req.setAttribute("workoutTypeJson", gson.toJson(analytics.get("workoutTypeMap")));

        req.getRequestDispatcher("/user/progress.jsp").forward(req, resp);
    }
}
