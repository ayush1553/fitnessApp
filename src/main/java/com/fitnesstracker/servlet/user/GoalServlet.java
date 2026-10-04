package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.Goal;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.GoalService;
import com.fitnesstracker.service.impl.GoalServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GoalServlet", urlPatterns = {"/user/goals"})
public class GoalServlet extends HttpServlet {

    private final GoalService goalService = new GoalServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        List<Goal> goals = goalService.getUserGoals(currentUser.getId());
        int activeCount = goalService.getActiveGoalsCount(currentUser.getId());
        int completedCount = goalService.getCompletedGoalsCount(currentUser.getId());
        int overallPct = goalService.calculateOverallGoalCompletionPercentage(currentUser.getId());

        req.setAttribute("goals", goals);
        req.setAttribute("activeCount", activeCount);
        req.setAttribute("completedCount", completedCount);
        req.setAttribute("overallPct", overallPct);

        req.getRequestDispatcher("/user/goals.jsp").forward(req, resp);
    }
}
