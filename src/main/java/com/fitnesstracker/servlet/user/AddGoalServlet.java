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

@WebServlet(name = "AddGoalServlet", urlPatterns = {"/goal/add"})
public class AddGoalServlet extends HttpServlet {

    private final GoalService goalService = new GoalServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            double target = ValidationUtil.parsePositiveDouble(req.getParameter("targetValue"), 0.0);
            double current = ValidationUtil.parsePositiveDouble(req.getParameter("currentValue"), 0.0);
            String unit = req.getParameter("unit");
            String deadlineStr = req.getParameter("deadline");

            Date deadline = DateUtil.parseSqlDate(deadlineStr);

            goalService.createGoal(currentUser.getId(), title, description,
                    BigDecimal.valueOf(target), BigDecimal.valueOf(current), unit, deadline);

            activityLogService.logActivity(currentUser.getId(), "GOAL_CREATED",
                    "Created goal: " + title + " (" + target + " " + unit + ")", req.getRemoteAddr());

            session.setAttribute("flashMessage", FlashMessage.success("Fitness goal created successfully!"));
        } catch (AppException e) {
            session.setAttribute("flashMessage", FlashMessage.error(e.getMessage()));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to create goal: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/goals");
    }
}
