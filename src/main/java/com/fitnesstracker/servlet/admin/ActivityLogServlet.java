package com.fitnesstracker.servlet.admin;

import com.fitnesstracker.model.ActivityLog;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ActivityLogServlet", urlPatterns = {"/admin/activity"})
public class ActivityLogServlet extends HttpServlet {

    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ActivityLog> logs = activityLogService.getRecentLogs(50);
        req.setAttribute("logs", logs);
        req.getRequestDispatcher("/admin/activity.jsp").forward(req, resp);
    }
}
