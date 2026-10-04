package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.Challenge;
import com.fitnesstracker.model.ChallengeParticipant;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ChallengeService;
import com.fitnesstracker.service.impl.ChallengeServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ChallengeServlet", urlPatterns = {"/user/challenges"})
public class ChallengeServlet extends HttpServlet {

    private final ChallengeService challengeService = new ChallengeServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        List<Challenge> challenges = challengeService.getChallengesForUser(currentUser.getId());
        List<ChallengeParticipant> userParticipations = challengeService.getUserParticipations(currentUser.getId());
        int completedCount = challengeService.getUserCompletedChallengesCount(currentUser.getId());

        req.setAttribute("challenges", challenges);
        req.setAttribute("userParticipations", userParticipations);
        req.setAttribute("completedCount", completedCount);

        req.getRequestDispatcher("/user/challenges.jsp").forward(req, resp);
    }
}
