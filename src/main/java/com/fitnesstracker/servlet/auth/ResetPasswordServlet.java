package com.fitnesstracker.servlet.auth;

import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.PasswordResetService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.PasswordResetServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet handling token validation and password reset form submission.
 */
@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password", "/auth/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    private final PasswordResetService passwordResetService = new PasswordResetServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");

        if (token == null || token.trim().isEmpty() || !passwordResetService.validateResetToken(token.trim())) {
            req.setAttribute("errorTitle", "Invalid or Expired Reset Link");
            req.setAttribute("errorMessage", "This password reset link is invalid, has already been used, or has expired (links are valid for 1 hour).");
            req.getRequestDispatcher("/auth/reset-password-error.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("token", token.trim());
        req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String ip = req.getRemoteAddr();

        if (token == null || token.trim().isEmpty() || !passwordResetService.validateResetToken(token.trim())) {
            req.setAttribute("errorTitle", "Invalid or Expired Reset Link");
            req.setAttribute("errorMessage", "This password reset link is invalid, has already been used, or has expired.");
            req.getRequestDispatcher("/auth/reset-password-error.jsp").forward(req, resp);
            return;
        }

        if (password == null || password.length() < 6) {
            req.setAttribute("token", token);
            req.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("token", token);
            req.setAttribute("errorMessage", "Passwords do not match. Please verify your password.");
            req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, resp);
            return;
        }

        boolean resetSuccess = passwordResetService.resetPassword(token.trim(), password);

        if (resetSuccess) {
            activityLogService.logActivity(null, "PASSWORD_RESET_SUCCESS", "Password reset successfully via token", ip);
            HttpSession session = req.getSession(true);
            session.setAttribute("flashMessage", FlashMessage.success("Password reset successful! Please sign in with your new password."));
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            req.setAttribute("errorTitle", "Password Reset Failed");
            req.setAttribute("errorMessage", "Failed to reset password. The link may have expired or already been used.");
            req.getRequestDispatcher("/auth/reset-password-error.jsp").forward(req, resp);
        }
    }
}
