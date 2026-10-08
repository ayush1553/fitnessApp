package com.fitnesstracker.servlet.auth;

import com.fitnesstracker.exception.UnauthorizedException;
import com.fitnesstracker.model.User;
import com.fitnesstracker.model.UserPreferences;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.UserPreferencesService;
import com.fitnesstracker.service.UserService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.UserPreferencesServiceImpl;
import com.fitnesstracker.service.impl.UserServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/auth/login", "/login"})
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();
    private final UserPreferencesService preferencesService = new UserPreferencesServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            resp.sendRedirect(req.getContextPath() + user.getDashboardRoute());
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String ip = req.getRemoteAddr();

        try {
            User user = userService.login(email, password);
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);

            // Load and persist theme preferences into session
            UserPreferences prefs = preferencesService.getByUserId(user.getId());
            session.setAttribute("userPreferences", prefs);

            activityLogService.logActivity(user.getId(), "LOGIN", "Logged in successfully", ip);

            session.setAttribute("flashMessage", FlashMessage.success("Welcome back, " + user.getName() + "!"));
            resp.sendRedirect(req.getContextPath() + user.getDashboardRoute());
        } catch (com.fitnesstracker.exception.UnverifiedEmailException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("unverifiedEmail", e.getEmail());
            req.setAttribute("email", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (UnauthorizedException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("email", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "An unexpected error occurred during login. Please try again.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
