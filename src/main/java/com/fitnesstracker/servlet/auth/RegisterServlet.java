package com.fitnesstracker.servlet.auth;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.exception.DuplicateResourceException;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.SystemSettingsService;
import com.fitnesstracker.service.UserService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.SystemSettingsServiceImpl;
import com.fitnesstracker.service.impl.UserServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/auth/register", "/register"})
public class RegisterServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();
    private final SystemSettingsService settingsService = new SystemSettingsServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();
    private final com.fitnesstracker.service.EmailVerificationService verificationService = new com.fitnesstracker.service.impl.EmailVerificationServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!settingsService.isRegistrationAllowed()) {
            req.setAttribute("errorMessage", "New user registrations are currently disabled by the administrator.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String ip = req.getRemoteAddr();

        if (password == null || !password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Passwords do not match. Please verify your password.");
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        try {
            User newUser = userService.register(name, email, password);
            activityLogService.logActivity(newUser.getId(), "USER_REGISTER", "New account registered: " + email, ip);

            // Dispatch SMTP Email Verification
            String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
            verificationService.sendVerificationEmail(newUser, baseUrl);

            req.setAttribute("email", email);
            req.setAttribute("userName", name);
            req.setAttribute("successMessage", "Account created successfully! We've sent a verification email to " + email + ". Please check your inbox to activate your account.");
            req.getRequestDispatcher("/auth/register-success.jsp").forward(req, resp);
        } catch (DuplicateResourceException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } catch (AppException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "An error occurred during registration. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
