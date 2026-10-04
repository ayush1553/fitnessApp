package com.fitnesstracker.servlet.user;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.exception.DuplicateResourceException;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.ChallengeService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.ChallengeServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "JoinChallengeServlet", urlPatterns = {"/challenge/join"})
public class JoinChallengeServlet extends HttpServlet {

    private final ChallengeService challengeService = new ChallengeServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            int challengeId = Integer.parseInt(req.getParameter("challengeId"));
            challengeService.joinChallenge(currentUser.getId(), challengeId);

            activityLogService.logActivity(currentUser.getId(), "CHALLENGE_JOINED", "Joined challenge ID: " + challengeId, req.getRemoteAddr());
            session.setAttribute("flashMessage", FlashMessage.success("Successfully enrolled in the challenge! Let's crush those targets!"));
        } catch (DuplicateResourceException e) {
            session.setAttribute("flashMessage", FlashMessage.warning(e.getMessage()));
        } catch (AppException e) {
            session.setAttribute("flashMessage", FlashMessage.error(e.getMessage()));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to join challenge: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/challenges");
    }
}
