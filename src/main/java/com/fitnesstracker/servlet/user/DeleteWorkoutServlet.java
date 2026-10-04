package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.WorkoutService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.WorkoutServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "DeleteWorkoutServlet", urlPatterns = {"/workout/delete"})
public class DeleteWorkoutServlet extends HttpServlet {

    private final WorkoutService workoutService = new WorkoutServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            int workoutId = Integer.parseInt(req.getParameter("id"));
            workoutService.deleteWorkout(workoutId, currentUser.getId());

            activityLogService.logActivity(currentUser.getId(), "WORKOUT_DELETED",
                    "Deleted workout record ID: " + workoutId, req.getRemoteAddr());

            session.setAttribute("flashMessage", FlashMessage.success("Workout record deleted successfully."));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to delete workout: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/workouts");
    }
}
