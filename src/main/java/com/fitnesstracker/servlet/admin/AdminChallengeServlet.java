package com.fitnesstracker.servlet.admin;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.Challenge;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.ChallengeService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.ChallengeServiceImpl;
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
import java.util.List;

@WebServlet(name = "AdminChallengeServlet", urlPatterns = {
        "/admin/challenges",
        "/admin-actions/challenge/create",
        "/admin-actions/challenge/update",
        "/admin-actions/challenge/delete",
        "/admin-actions/challenge/status"
})
public class AdminChallengeServlet extends HttpServlet {

    private final ChallengeService challengeService = new ChallengeServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Challenge> challenges = challengeService.getAllChallenges();
        int activeCount = challengeService.getActiveChallengeCount();

        req.setAttribute("challenges", challenges);
        req.setAttribute("activeCount", activeCount);

        req.getRequestDispatcher("/admin/challenges.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User admin = (User) session.getAttribute("currentUser");
        String path = req.getServletPath();

        try {
            if ("/admin-actions/challenge/create".equals(path)) {
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String category = req.getParameter("category");
                double target = ValidationUtil.parsePositiveDouble(req.getParameter("targetValue"), 0.0);
                String unit = req.getParameter("unit");
                Date startDate = DateUtil.parseSqlDate(req.getParameter("startDate"));
                Date endDate = DateUtil.parseSqlDate(req.getParameter("endDate"));

                challengeService.createChallenge(title, description, category, BigDecimal.valueOf(target), unit, startDate, endDate);
                activityLogService.logActivity(admin.getId(), "CHALLENGE_CREATED", "Created challenge: " + title, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("New challenge published successfully!"));
            } else if ("/admin-actions/challenge/update".equals(path)) {
                int challengeId = Integer.parseInt(req.getParameter("id"));
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String category = req.getParameter("category");
                double target = ValidationUtil.parsePositiveDouble(req.getParameter("targetValue"), 0.0);
                String unit = req.getParameter("unit");
                Date startDate = DateUtil.parseSqlDate(req.getParameter("startDate"));
                Date endDate = DateUtil.parseSqlDate(req.getParameter("endDate"));
                String status = req.getParameter("status");

                challengeService.updateChallenge(challengeId, title, description, category, BigDecimal.valueOf(target), unit, startDate, endDate, status);
                activityLogService.logActivity(admin.getId(), "CHALLENGE_UPDATED", "Updated challenge ID: " + challengeId, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Challenge updated successfully!"));
            } else if ("/admin-actions/challenge/status".equals(path)) {
                int challengeId = Integer.parseInt(req.getParameter("id"));
                String status = req.getParameter("status");
                challengeService.getChallengeById(challengeId).ifPresent(c -> {
                    challengeService.updateChallenge(c.getId(), c.getTitle(), c.getDescription(), c.getCategory(), c.getTargetValue(), c.getUnit(), c.getStartDate(), c.getEndDate(), status);
                });
                activityLogService.logActivity(admin.getId(), "CHALLENGE_STATUS", "Set challenge ID " + challengeId + " status to " + status, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Challenge status changed to " + status));
            } else if ("/admin-actions/challenge/delete".equals(path)) {
                int challengeId = Integer.parseInt(req.getParameter("id"));
                challengeService.deleteChallenge(challengeId);
                activityLogService.logActivity(admin.getId(), "CHALLENGE_DELETED", "Deleted challenge ID: " + challengeId, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Challenge deleted successfully."));
            }
        } catch (AppException e) {
            session.setAttribute("flashMessage", FlashMessage.error(e.getMessage()));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Challenge management error: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/challenges");
    }
}
