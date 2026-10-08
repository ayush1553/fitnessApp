package com.fitnesstracker.servlet.auth;

import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.EmailVerificationService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.EmailVerificationServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet handling user email verification link clicks.
 */
@WebServlet(name = "VerifyEmailServlet", urlPatterns = {"/verify-email", "/auth/verify-email"})
public class VerifyEmailServlet extends HttpServlet {

    private final EmailVerificationService verificationService = new EmailVerificationServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String ip = req.getRemoteAddr();

        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("errorTitle", "Invalid Verification Link");
            req.setAttribute("errorMessage", "The verification link provided is missing or malformed. Please request a new link.");
            req.getRequestDispatcher("/auth/email-verification-error.jsp").forward(req, resp);
            return;
        }

        try {
            boolean success = verificationService.verifyToken(token.trim());
            if (success) {
                activityLogService.logActivity(null, "EMAIL_VERIFY", "Email address verified successfully via token", ip);
                req.setAttribute("successMessage", "Your FitFlow account is now fully verified. You can log in and begin your fitness journey.");
                req.getRequestDispatcher("/auth/email-verification-success.jsp").forward(req, resp);
            } else {
                req.setAttribute("errorTitle", "Verification Link Expired or Invalid");
                req.setAttribute("errorMessage", "This verification link is invalid, has already been used, or has expired (links are valid for 24 hours).");
                req.getRequestDispatcher("/auth/email-verification-error.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("errorTitle", "Verification Error");
            req.setAttribute("errorMessage", "An error occurred while verifying your email. Please try requesting a new verification link.");
            req.getRequestDispatcher("/auth/email-verification-error.jsp").forward(req, resp);
        }
    }
}
