package com.fitnesstracker.servlet.user;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.WorkoutService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.WorkoutServiceImpl;
import com.fitnesstracker.util.DateUtil;
import com.fitnesstracker.util.FlashMessage;
import com.fitnesstracker.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "UpdateWorkoutServlet", urlPatterns = {"/workout/update"})
public class UpdateWorkoutServlet extends HttpServlet {

    private final WorkoutService workoutService = new WorkoutServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            int workoutId = Integer.parseInt(req.getParameter("id"));
            String workoutType = req.getParameter("workoutType");
            int durationMinutes = ValidationUtil.parsePositiveInt(req.getParameter("durationMinutes"), 0);
            String intensity = req.getParameter("intensity");
            int caloriesBurned = ValidationUtil.parsePositiveInt(req.getParameter("caloriesBurned"), 0);
            String dateStr = req.getParameter("workoutDate");
            String notes = req.getParameter("notes");

            Date workoutDate = DateUtil.parseSqlDate(dateStr);

            workoutService.updateWorkout(workoutId, currentUser.getId(), workoutType, durationMinutes, intensity, caloriesBurned, workoutDate, notes);

            activityLogService.logActivity(currentUser.getId(), "WORKOUT_UPDATED",
                    "Updated workout ID " + workoutId + " (" + workoutType + ")", req.getRemoteAddr());

            session.setAttribute("flashMessage", FlashMessage.success("Workout updated successfully!"));
        } catch (AppException e) {
            session.setAttribute("flashMessage", FlashMessage.error(e.getMessage()));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to update workout: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/workouts");
    }
}
