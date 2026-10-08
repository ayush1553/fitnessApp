package com.fitnesstracker.filter;

import com.fitnesstracker.model.User;
import com.fitnesstracker.model.UserPreferences;
import com.fitnesstracker.service.UserPreferencesService;
import com.fitnesstracker.service.impl.UserPreferencesServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication filter protecting user-facing routes, actions, and ensuring theme preferences are loaded.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/user/*", "/workout/*", "/goal/*", "/challenge/*", "/content/*", "/profile/*", "/customize/*"})
public class AuthFilter implements Filter {

    private final UserPreferencesService preferencesService = new UserPreferencesServiceImpl();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("flashMessage", FlashMessage.warning("Please sign in to access that page."));
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Check if user is active
        if (!currentUser.isActive()) {
            if (session != null) session.invalidate();
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("flashMessage", FlashMessage.error("Your account has been deactivated. Please contact support."));
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Ensure user preferences are loaded into session
        if (session != null && session.getAttribute("userPreferences") == null) {
            UserPreferences prefs = preferencesService.getByUserId(currentUser.getId());
            session.setAttribute("userPreferences", prefs);
        }

        chain.doFilter(request, response);
    }
}
