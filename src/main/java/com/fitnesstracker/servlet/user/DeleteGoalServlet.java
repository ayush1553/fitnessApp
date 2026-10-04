package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.GoalService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.GoalServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "DeleteGoalServlet", urlPatterns = {"/goal/delete"})
public class DeleteGoalServlet extends HttpServlet {

    private final GoalService goalService = new GoalServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            int goalId = Integer.parseInt(req.getParameter("id"));
            goalService.deleteGoal(goalId, currentUser.getId());

            activityLogService.logActivity(currentUser.getId(), "GOAL_DELETED", "Deleted goal ID: " + goalId, req.getRemoteAddr());
            session.setAttribute("flashMessage", FlashMessage.success("Goal deleted successfully."));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to delete goal: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/goals");
    }
}
