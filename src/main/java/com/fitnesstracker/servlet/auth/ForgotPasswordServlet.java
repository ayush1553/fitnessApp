package com.fitnesstracker.servlet.auth;

import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.PasswordResetService;
import com.fitnesstracker.service.UserService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.PasswordResetServiceImpl;
import com.fitnesstracker.service.impl.UserServiceImpl;
import com.fitnesstracker.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

/**
 * Servlet handling initial password reset requests.
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password", "/auth/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();
    private final PasswordResetService passwordResetService = new PasswordResetServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email != null) {
            req.setAttribute("email", email.trim());
        }
        req.getRequestDispatcher("/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String ip = req.getRemoteAddr();

        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("errorMessage", "Please enter a valid email address.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        String cleanEmail = email.toLowerCase().trim();
        Optional<User> userOpt = userService.getUserByEmail(cleanEmail);

        if (userOpt.isEmpty()) {
            // Security best practice: don't reveal email non-existence
            req.setAttribute("email", cleanEmail);
            req.getRequestDispatcher("/auth/forgot-password-sent.jsp").forward(req, resp);
            return;
        }

        User user = userOpt.get();

        // Rate limit check
        if (!passwordResetService.canRequestPasswordReset(user.getId())) {
            long remainingSecs = passwordResetService.getRemainingCooldownSeconds(user.getId());
            req.setAttribute("errorMessage", "Please wait " + remainingSecs + " seconds before requesting another reset email.");
            req.setAttribute("email", cleanEmail);
            req.setAttribute("cooldownRemaining", remainingSecs);
            req.getRequestDispatcher("/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
        passwordResetService.sendPasswordResetEmail(user, baseUrl);

        activityLogService.logActivity(user.getId(), "PASSWORD_RESET_REQUEST", "Password reset link requested for " + cleanEmail, ip);

        req.setAttribute("email", cleanEmail);
        req.getRequestDispatcher("/auth/forgot-password-sent.jsp").forward(req, resp);
    }
}
