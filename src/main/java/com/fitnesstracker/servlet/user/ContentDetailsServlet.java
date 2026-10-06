package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.FitnessContent;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.FitnessContentService;
import com.fitnesstracker.service.impl.FitnessContentServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ContentDetailsServlet", urlPatterns = {"/user/content/view", "/content/view"})
public class ContentDetailsServlet extends HttpServlet {

    private final FitnessContentService contentService = new FitnessContentServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user/content");
            return;
        }

        int contentId;
        try {
            contentId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid article identifier specified.");
            req.getRequestDispatcher("/404.jsp").forward(req, resp);
            return;
        }

        Optional<FitnessContent> optContent = contentService.getContentById(contentId);
        if (optContent.isEmpty()) {
            req.setAttribute("errorMessage", "The requested fitness article could not be found.");
            req.getRequestDispatcher("/404.jsp").forward(req, resp);
            return;
        }

        FitnessContent content = optContent.get();

        // Permission check: only approved articles or author/admin can view pending/rejected content
        boolean isAuthor = currentUser.getId().equals(content.getUserId());
        boolean isAdmin = "ADMIN".equalsIgnoreCase(currentUser.getRole());
        boolean isApproved = "APPROVED".equalsIgnoreCase(content.getStatus());

        if (!isApproved && !isAuthor && !isAdmin) {
            session.setAttribute("flashMessage", FlashMessage.error("This article is currently pending moderation and is not yet available."));
            resp.sendRedirect(req.getContextPath() + "/user/content");
            return;
        }

        // Fetch related articles in the same category
        List<FitnessContent> relatedArticles = contentService.getRelatedContent(content.getId(), content.getCategory(), 3);

        req.setAttribute("content", content);
        req.setAttribute("relatedArticles", relatedArticles);

        req.getRequestDispatcher("/user/content-details.jsp").forward(req, resp);
    }
}
