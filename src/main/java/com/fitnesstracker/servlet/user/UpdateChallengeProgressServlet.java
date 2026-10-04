package com.fitnesstracker.servlet.user;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.ChallengeService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.ChallengeServiceImpl;
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

@WebServlet(name = "UpdateChallengeProgressServlet", urlPatterns = {"/challenge/progress", "/challenge/leave"})
public class UpdateChallengeProgressServlet extends HttpServlet {

    private final ChallengeService challengeService = new ChallengeServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        String path = req.getServletPath();

        try {
            int participantId = Integer.parseInt(req.getParameter("participantId"));

            if ("/challenge/leave".equals(path)) {
                challengeService.leaveChallenge(participantId, currentUser.getId());
                activityLogService.logActivity(currentUser.getId(), "CHALLENGE_LEFT", "Left challenge participant record ID: " + participantId, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.info("You have left the challenge."));
            } else {
                double progress = ValidationUtil.parsePositiveDouble(req.getParameter("progress"), 0.0);
                challengeService.updateParticipantProgress(participantId, currentUser.getId(), BigDecimal.valueOf(progress));
                activityLogService.logActivity(currentUser.getId(), "CHALLENGE_PROGRESS", "Updated challenge progress to " + progress, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Challenge progress updated!"));
            }
        } catch (AppException e) {
            session.setAttribute("flashMessage", FlashMessage.error(e.getMessage()));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Operation failed: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/challenges");
    }
}
