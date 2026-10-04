package com.fitnesstracker.servlet.user;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.GoalService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.GoalServiceImpl;
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
import java.math.BigDecimal;
import java.sql.Date;

@WebServlet(name = "UpdateGoalServlet", urlPatterns = {"/goal/update", "/goal/progress", "/goal/complete"})
public class UpdateGoalServlet extends HttpServlet {

    private final GoalService goalService = new GoalServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        String path = req.getServletPath();

        try {
            int goalId = Integer.parseInt(req.getParameter("id"));

            if ("/goal/complete".equals(path)) {
                goalService.completeGoal(goalId, currentUser.getId());
                activityLogService.logActivity(currentUser.getId(), "GOAL_COMPLETED", "Completed goal ID: " + goalId, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Congratulations! Goal marked as completed!"));
            } else if ("/goal/progress".equals(path)) {
                double progress = ValidationUtil.parsePositiveDouble(req.getParameter("currentValue"), 0.0);
                goalService.updateProgress(goalId, currentUser.getId(), BigDecimal.valueOf(progress));
                activityLogService.logActivity(currentUser.getId(), "GOAL_PROGRESS", "Updated progress for goal ID " + goalId + " to " + progress, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Goal progress updated successfully!"));
            } else {
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                double target = ValidationUtil.parsePositiveDouble(req.getParameter("targetValue"), 0.0);
                double current = ValidationUtil.parsePositiveDouble(req.getParameter("currentValue"), 0.0);
                String unit = req.getParameter("unit");
                String deadlineStr = req.getParameter("deadline");
                String status = req.getParameter("status");

                Date deadline = DateUtil.parseSqlDate(deadlineStr);

                goalService.updateGoal(goalId, currentUser.getId(), title, description,
                        BigDecimal.valueOf(target), BigDecimal.valueOf(current), unit, deadline, status);

                activityLogService.logActivity(currentUser.getId(), "GOAL_UPDATED", "Edited goal ID: " + goalId, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Goal updated successfully!"));
            }
        } catch (AppException e) {
            session.setAttribute("flashMessage", FlashMessage.error(e.getMessage()));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Operation failed: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/goals");
    }
}
