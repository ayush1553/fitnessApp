package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.User;
import com.fitnesstracker.model.Workout;
import com.fitnesstracker.service.WorkoutService;
import com.fitnesstracker.service.impl.WorkoutServiceImpl;
import com.fitnesstracker.util.DateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "WorkoutServlet", urlPatterns = {"/user/workouts", "/workout/list"})
public class WorkoutServlet extends HttpServlet {

    private final WorkoutService workoutService = new WorkoutServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        String type = req.getParameter("type");
        String intensity = req.getParameter("intensity");
        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");
        String sortBy = req.getParameter("sortBy");
        String sortDir = req.getParameter("sortDir");

        Date startDate = (startDateStr != null && !startDateStr.trim().isEmpty()) ? DateUtil.parseSqlDate(startDateStr) : null;
        Date endDate = (endDateStr != null && !endDateStr.trim().isEmpty()) ? DateUtil.parseSqlDate(endDateStr) : null;

        List<Workout> workouts;
        if (type != null || intensity != null || startDate != null || endDate != null || sortBy != null) {
            workouts = workoutService.filterUserWorkouts(currentUser.getId(), type, intensity, startDate, endDate, sortBy, sortDir);
        } else {
            workouts = workoutService.getUserWorkouts(currentUser.getId());
        }

        int totalCalories = workoutService.getTotalCaloriesBurned(currentUser.getId());
        int totalMinutes = workoutService.getTotalWorkoutDuration(currentUser.getId());
        int totalCount = workoutService.getTotalWorkoutCount(currentUser.getId());

        req.setAttribute("workouts", workouts);
        req.setAttribute("totalCalories", totalCalories);
        req.setAttribute("totalMinutes", totalMinutes);
        req.setAttribute("totalCount", totalCount);

        // Retain search filters
        req.setAttribute("selectedType", type);
        req.setAttribute("selectedIntensity", intensity);
        req.setAttribute("selectedStartDate", startDateStr);
        req.setAttribute("selectedEndDate", endDateStr);
        req.setAttribute("selectedSortBy", sortBy);
        req.setAttribute("selectedSortDir", sortDir);

        req.getRequestDispatcher("/user/workouts.jsp").forward(req, resp);
    }
}
