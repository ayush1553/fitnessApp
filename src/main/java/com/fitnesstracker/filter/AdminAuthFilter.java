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
 * Role-Based Access Control filter strictly reserving /admin/* and admin servlets for ADMIN role.
 */
@WebFilter(filterName = "AdminAuthFilter", urlPatterns = {"/admin/*", "/admin-actions/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("flashMessage", FlashMessage.warning("Admin authentication required."));
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (!currentUser.canPerformAdminActions()) {
            session.setAttribute("flashMessage", FlashMessage.error("Access denied. You do not possess administrator privileges."));
            res.sendRedirect(req.getContextPath() + "/user/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }
}
