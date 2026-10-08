package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.User;
import com.fitnesstracker.model.UserPreferences;
import com.fitnesstracker.service.UserPreferencesService;
import com.fitnesstracker.service.impl.UserPreferencesServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller handling user theme customization, live preference updates, and factory resets.
 */
@WebServlet(name = "CustomizeServlet", urlPatterns = {"/user/customize", "/customize"})
public class CustomizeServlet extends HttpServlet {

    private final UserPreferencesService preferencesService = new UserPreferencesServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        UserPreferences prefs = preferencesService.getByUserId(currentUser.getId());
        req.setAttribute("preferences", prefs);
        session.setAttribute("userPreferences", prefs);

        req.getRequestDispatcher("/user/customize.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("reset".equalsIgnoreCase(action)) {
            UserPreferences defaultPrefs = preferencesService.resetToDefault(currentUser.getId());
            session.setAttribute("userPreferences", defaultPrefs);
            session.setAttribute("flashMessage", FlashMessage.success("Theme preferences restored to factory default."));
            resp.sendRedirect(req.getContextPath() + "/user/customize");
            return;
        }

        String themeMode = req.getParameter("themeMode");
        String accentColor = req.getParameter("accentColor");
        String glassIntensity = req.getParameter("glassIntensity");
        
        boolean animationsEnabled = "true".equalsIgnoreCase(req.getParameter("animationsEnabled")) || 
                                    "on".equalsIgnoreCase(req.getParameter("animationsEnabled"));
        boolean compactMode = "true".equalsIgnoreCase(req.getParameter("compactMode")) || 
                              "on".equalsIgnoreCase(req.getParameter("compactMode"));

        UserPreferences prefs = new UserPreferences();
        prefs.setUserId(currentUser.getId());
        prefs.setThemeMode(themeMode);
        prefs.setAccentColor(accentColor);
        prefs.setGlassIntensity(glassIntensity);
        prefs.setAnimationsEnabled(animationsEnabled);
        prefs.setCompactMode(compactMode);

        UserPreferences savedPrefs = preferencesService.saveOrUpdate(prefs);
        session.setAttribute("userPreferences", savedPrefs);
        session.setAttribute("flashMessage", FlashMessage.success("Appearance updated successfully."));

        resp.sendRedirect(req.getContextPath() + "/user/customize");
    }
}
