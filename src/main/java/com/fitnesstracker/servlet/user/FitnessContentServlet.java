package com.fitnesstracker.servlet.user;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.FitnessContent;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.FitnessContentService;
import com.fitnesstracker.service.SystemSettingsService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.FitnessContentServiceImpl;
import com.fitnesstracker.service.impl.SystemSettingsServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "FitnessContentServlet", urlPatterns = {"/user/content", "/content/submit"})
public class FitnessContentServlet extends HttpServlet {

    private final FitnessContentService contentService = new FitnessContentServiceImpl();
    private final SystemSettingsService settingsService = new SystemSettingsServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        String category = req.getParameter("category");
        String searchQuery = req.getParameter("search");
        if (searchQuery == null) {
            searchQuery = req.getParameter("q");
        }

        List<FitnessContent> articles;
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            articles = contentService.searchApprovedContent(searchQuery.trim(), category);
        } else if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            articles = contentService.getApprovedContentByCategory(category.trim());
        } else {
            articles = contentService.getApprovedContent();
        }

        List<FitnessContent> userSubmissions = contentService.getUserSubmissions(currentUser.getId());

        req.setAttribute("articles", articles);
        req.setAttribute("userSubmissions", userSubmissions);
        req.setAttribute("selectedCategory", category);
        req.setAttribute("searchQuery", searchQuery);

        req.getRequestDispatcher("/user/content.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        try {
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String contentBody = req.getParameter("contentBody");
            String category = req.getParameter("category");
            String imageUrl = req.getParameter("imageUrl");

            if (contentBody == null || contentBody.trim().isEmpty()) {
                contentBody = description;
            }

            FitnessContent content = contentService.submitContent(currentUser.getId(), title, description, contentBody, category, imageUrl);

            boolean requiresModeration = settingsService.isContentModerationEnabled();
            if (!requiresModeration) {
                contentService.approveContent(content.getId());
            }

            activityLogService.logActivity(currentUser.getId(), "CONTENT_SUBMITTED",
                    "Submitted article: " + title + " (Status: " + (requiresModeration ? "Pending" : "Approved") + ")", req.getRemoteAddr());

            if (requiresModeration) {
                session.setAttribute("flashMessage", FlashMessage.info("Your fitness article has been submitted for admin review."));
            } else {
                session.setAttribute("flashMessage", FlashMessage.success("Your article has been published successfully!"));
            }
        } catch (AppException e) {
            session.setAttribute("flashMessage", FlashMessage.error(e.getMessage()));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to submit content: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/content");
    }
}
