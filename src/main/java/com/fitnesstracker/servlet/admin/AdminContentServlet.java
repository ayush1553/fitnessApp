package com.fitnesstracker.servlet.admin;

import com.fitnesstracker.model.Exercise;
import com.fitnesstracker.model.FitnessContent;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.ExerciseService;
import com.fitnesstracker.service.FitnessContentService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.ExerciseServiceImpl;
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
        "/admin-actions/content/delete",
        "/admin-actions/exercise/create",
        "/admin-actions/exercise/delete",
        "/admin-actions/exercise/toggle"
})
public class AdminContentServlet extends HttpServlet {

    private final FitnessContentService contentService = new FitnessContentServiceImpl();
    private final ExerciseService exerciseService = new ExerciseServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<FitnessContent> allContent = contentService.getAllSubmissions();
        int pendingCount = contentService.getPendingContentCount();
        List<Exercise> allExercises = exerciseService.getAllExercisesAdmin();

        req.setAttribute("allContent", allContent);
        req.setAttribute("pendingCount", pendingCount);
        req.setAttribute("allExercises", allExercises);

        req.getRequestDispatcher("/admin/content.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User admin = (User) session.getAttribute("currentUser");
        String path = req.getServletPath();

        try {
            if ("/admin-actions/exercise/create".equals(path)) {
                String name = req.getParameter("name");
                String category = req.getParameter("category");
                String difficulty = req.getParameter("difficulty");
                String equipment = req.getParameter("equipment");
                String targetMuscles = req.getParameter("targetMuscles");
                String secondaryMuscles = req.getParameter("secondaryMuscles");
                String description = req.getParameter("description");
                String instructions = req.getParameter("instructions");
                String commonMistakes = req.getParameter("commonMistakes");
                String formTips = req.getParameter("formTips");
                int defaultSets = Integer.parseInt(req.getParameter("defaultSets"));
                String defaultReps = req.getParameter("defaultReps");
                int defaultDuration = Integer.parseInt(req.getParameter("defaultDurationSeconds"));
                String videoUrl = req.getParameter("videoUrl");
                String thumbnailUrl = req.getParameter("thumbnailUrl");

                exerciseService.createExercise(name, category, difficulty, equipment, targetMuscles,
                        secondaryMuscles, description, instructions, commonMistakes, formTips,
                        defaultSets, defaultReps, defaultDuration, videoUrl, thumbnailUrl);

                activityLogService.logActivity(admin.getId(), "EXERCISE_CREATED",
                        "Created exercise: " + name, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("New exercise created successfully!"));
            } else if ("/admin-actions/exercise/delete".equals(path)) {
                int exId = Integer.parseInt(req.getParameter("exerciseId"));
                exerciseService.deleteExercise(exId);
                activityLogService.logActivity(admin.getId(), "EXERCISE_DELETED",
                        "Deleted exercise ID: " + exId, req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Exercise deleted successfully!"));
            } else if ("/admin-actions/exercise/toggle".equals(path)) {
                int exId = Integer.parseInt(req.getParameter("exerciseId"));
                String status = req.getParameter("status");
                exerciseService.toggleStatus(exId, status);
                session.setAttribute("flashMessage", FlashMessage.success("Exercise status updated!"));
            } else {
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
            }
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Action failed: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/admin/content");
    }
}
