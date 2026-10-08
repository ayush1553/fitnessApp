package com.fitnesstracker.servlet.auth;

import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.EmailVerificationService;
import com.fitnesstracker.service.UserService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.EmailVerificationServiceImpl;
import com.fitnesstracker.service.impl.UserServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import com.fitnesstracker.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

/**
 * Servlet for requesting a fresh email verification link with rate limiting.
 */
@WebServlet(name = "ResendVerificationServlet", urlPatterns = {"/resend-verification", "/auth/resend-verification"})
public class ResendVerificationServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();
    private final EmailVerificationService verificationService = new EmailVerificationServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email != null) {
            req.setAttribute("email", email.trim());
        }
        req.getRequestDispatcher("/auth/resend-verification.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String ip = req.getRemoteAddr();

        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("errorMessage", "Please enter a valid email address.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/auth/resend-verification.jsp").forward(req, resp);
            return;
        }

        String cleanEmail = email.toLowerCase().trim();
        Optional<User> userOpt = userService.getUserByEmail(cleanEmail);

        if (userOpt.isEmpty()) {
            // Security best practice: don't reveal email non-existence, or give clear guidance
            req.setAttribute("successMessage", "If an unverified account is registered under " + cleanEmail + ", a new verification link has been sent.");
            req.setAttribute("email", cleanEmail);
            req.getRequestDispatcher("/auth/register-success.jsp").forward(req, resp);
            return;
        }

        User user = userOpt.get();

        if (user.isEmailVerified()) {
            req.setAttribute("infoMessage", "This account is already verified. You can log in right away.");
            req.setAttribute("email", cleanEmail);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Check cooldown (60s rate limit)
        if (!verificationService.canResendVerification(user.getId())) {
            long remainingSecs = verificationService.getRemainingCooldownSeconds(user.getId());
            req.setAttribute("errorMessage", "Please wait " + remainingSecs + " seconds before requesting another verification email.");
            req.setAttribute("email", cleanEmail);
            req.setAttribute("cooldownRemaining", remainingSecs);
            req.getRequestDispatcher("/auth/resend-verification.jsp").forward(req, resp);
            return;
        }

        // Build application base URL
        String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
        boolean sent = verificationService.sendVerificationEmail(user, baseUrl);

        activityLogService.logActivity(user.getId(), "EMAIL_RESEND", "Verification email requested for " + cleanEmail, ip);

        req.setAttribute("email", cleanEmail);
        req.setAttribute("successMessage", "A new verification link has been dispatched to " + cleanEmail + ". Please check your inbox or spam folder.");
        req.getRequestDispatcher("/auth/register-success.jsp").forward(req, resp);
    }
}
