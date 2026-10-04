package com.fitnesstracker.filter;

import com.fitnesstracker.model.User;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication filter protecting user-facing routes and actions.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/user/*", "/workout/*", "/goal/*", "/challenge/*", "/content/*", "/profile/*"})
public class AuthFilter implements Filter {

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

        chain.doFilter(request, response);
    }
}
