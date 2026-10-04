package com.fitnesstracker.servlet.admin;

import com.fitnesstracker.model.FitnessContent;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.FitnessContentService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
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

@WebServlet(name = "AdminContentServlet", urlPatterns = {
        "/admin/content",
        "/admin-actions/content/approve",
        "/admin-actions/content/reject",
        "/admin-actions/content/delete"
})
public class AdminContentServlet extends HttpServlet {

    private final FitnessContentService contentService = new FitnessContentServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<FitnessContent> allContent = contentService.getAllSubmissions();
        int pendingCount = contentService.getPendingContentCount();

        req.setAttribute("allContent", allContent);
        req.setAttribute("pendingCount", pendingCount);

        req.getRequestDispatcher("/admin/content.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User admin = (User) session.getAttribute("currentUser");
        String path = req.getServletPath();

        try {
            int contentId = Integer.parseInt(req.getParameter("contentId"));

            if ("/admin-actions/content/approve".equals(path)) {
                contentService.approveContent(contentId);
                activityLogService.logActivity(admin.getId(), "CONTENT_APPROVED",
                        "Approved fitness content ID: " + contentId, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Content submission approved!"));
            } else if ("/admin-actions/content/reject".equals(path)) {
                String reason = req.getParameter("reason");
                contentService.rejectContent(contentId, reason);
                activityLogService.logActivity(admin.getId(), "CONTENT_REJECTED",
                        "Rejected fitness content ID: " + contentId + " (Reason: " + reason + ")", req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.info("Content submission rejected."));
            } else if ("/admin-actions/content/delete".equals(path)) {
                contentService.deleteContent(contentId);
                activityLogService.logActivity(admin.getId(), "CONTENT_DELETED",
                        "Deleted fitness content ID: " + contentId, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Content deleted successfully."));
            }
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Content action failed: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/content");
    }
}
