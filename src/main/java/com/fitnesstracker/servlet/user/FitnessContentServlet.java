package com.fitnesstracker.servlet.user;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.Exercise;
import com.fitnesstracker.model.FitnessContent;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.ExerciseService;
import com.fitnesstracker.service.FitnessContentService;
import com.fitnesstracker.service.SystemSettingsService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.ExerciseServiceImpl;
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
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "FitnessContentServlet", urlPatterns = {"/user/content", "/content/submit"})
public class FitnessContentServlet extends HttpServlet {

    private final FitnessContentService contentService = new FitnessContentServiceImpl();
    private final ExerciseService exerciseService = new ExerciseServiceImpl();
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

        String tab = req.getParameter("tab");
        final String currentTab = (tab == null || tab.trim().isEmpty()) ? "exercises" : tab.trim().toLowerCase();
        
        String tempSubtab = req.getParameter("subtab");
        if (tempSubtab == null || tempSubtab.trim().isEmpty()) {
            tempSubtab = req.getParameter("category");
        }
        final String currentSubtab = (tempSubtab == null || tempSubtab.trim().isEmpty()) ? "All" : tempSubtab.trim();

        // Search Query
        String tempSearchQuery = req.getParameter("search");
        if (tempSearchQuery == null) {
            tempSearchQuery = req.getParameter("q");
        }
        final String searchQuery = (tempSearchQuery != null && !tempSearchQuery.trim().isEmpty()) ? tempSearchQuery.trim() : null;

        // Fetch all active exercises and all approved content for counts and filtering
        List<Exercise> allActiveExercises = exerciseService.getActiveExercises();
        List<FitnessContent> allApprovedContent = contentService.getApprovedContent();

        // 1. Calculate Global Section Counts (for primary tab badges)
        long totalExerciseCount = allActiveExercises.size();
        
        List<FitnessContent> allWorkoutGuides = allApprovedContent.stream()
                .filter(c -> "Workout Routines".equalsIgnoreCase(c.getCategory()) || "Cardio & Endurance".equalsIgnoreCase(c.getCategory()) || "Workout".equalsIgnoreCase(c.getCategory()))
                .collect(Collectors.toList());
        long totalWorkoutCount = allWorkoutGuides.size();

        List<FitnessContent> allNutritionGuides = allApprovedContent.stream()
                .filter(c -> "Nutrition & Diet".equalsIgnoreCase(c.getCategory()) || "Nutrition".equalsIgnoreCase(c.getCategory()))
                .collect(Collectors.toList());
        long totalNutritionCount = allNutritionGuides.size();

        List<FitnessContent> allRecoveryGuides = allApprovedContent.stream()
                .filter(c -> "Recovery & Wellness".equalsIgnoreCase(c.getCategory()) || "Recovery".equalsIgnoreCase(c.getCategory()))
                .collect(Collectors.toList());
        long totalRecoveryCount = allRecoveryGuides.size();

        long totalArticleCount = allApprovedContent.size();

        // 2. Filter Content based on Tab, Subtab, and Search Query
        List<Exercise> exercises;
        if (searchQuery != null && !searchQuery.isEmpty()) {
            exercises = exerciseService.searchExercises(searchQuery, !"All".equalsIgnoreCase(currentSubtab) ? currentSubtab : null);
        } else if (!"All".equalsIgnoreCase(currentSubtab) && "exercises".equalsIgnoreCase(currentTab)) {
            exercises = exerciseService.getActiveExercisesByCategory(currentSubtab);
        } else {
            exercises = allActiveExercises;
        }

        // Helper search filter for FitnessContent
        java.util.function.Predicate<FitnessContent> matchesSearch = c -> {
            if (searchQuery == null || searchQuery.isEmpty()) return true;
            String q = searchQuery.toLowerCase();
            return (c.getTitle() != null && c.getTitle().toLowerCase().contains(q))
                    || (c.getDescription() != null && c.getDescription().toLowerCase().contains(q))
                    || (c.getCategory() != null && c.getCategory().toLowerCase().contains(q))
                    || (c.getSubcategory() != null && c.getSubcategory().toLowerCase().contains(q));
        };

        // Filter Workout Guides
        List<FitnessContent> workoutGuides = allWorkoutGuides.stream()
                .filter(matchesSearch)
                .filter(c -> {
                    if (!"workouts".equalsIgnoreCase(currentTab) || "All".equalsIgnoreCase(currentSubtab)) return true;
                    String sub = c.getSubcategory() != null ? c.getSubcategory() : "";
                    String cat = c.getCategory() != null ? c.getCategory() : "";
                    return currentSubtab.equalsIgnoreCase(sub) || currentSubtab.equalsIgnoreCase(cat)
                            || ("Gym".equalsIgnoreCase(currentSubtab) && sub.toLowerCase().contains("gym"))
                            || ("Home".equalsIgnoreCase(currentSubtab) && sub.toLowerCase().contains("home"))
                            || ("Cardio".equalsIgnoreCase(currentSubtab) && (sub.toLowerCase().contains("cardio") || cat.toLowerCase().contains("cardio")));
                })
                .collect(Collectors.toList());

        // Filter Nutrition Guides
        List<FitnessContent> nutritionGuides = allNutritionGuides.stream()
                .filter(matchesSearch)
                .filter(c -> {
                    if (!"nutrition".equalsIgnoreCase(currentTab) || "All".equalsIgnoreCase(currentSubtab)) return true;
                    String sub = c.getSubcategory() != null ? c.getSubcategory() : "";
                    if ("Healthy Fats".equalsIgnoreCase(currentSubtab) || "Fats".equalsIgnoreCase(currentSubtab)) {
                        return sub.toLowerCase().contains("fat");
                    }
                    return currentSubtab.equalsIgnoreCase(sub);
                })
                .collect(Collectors.toList());

        // Filter Recovery Guides
        List<FitnessContent> recoveryGuides = allRecoveryGuides.stream()
                .filter(matchesSearch)
                .filter(c -> {
                    if (!"recovery".equalsIgnoreCase(currentTab) || "All".equalsIgnoreCase(currentSubtab)) return true;
                    String sub = c.getSubcategory() != null ? c.getSubcategory() : "";
                    return currentSubtab.equalsIgnoreCase(sub);
                })
                .collect(Collectors.toList());

        // Filter Fitness Articles (Community & Hub)
        List<FitnessContent> fitnessArticles = allApprovedContent.stream()
                .filter(matchesSearch)
                .filter(c -> {
                    if (!"articles".equalsIgnoreCase(currentTab) || "All".equalsIgnoreCase(currentSubtab)) return true;
                    String sub = c.getSubcategory() != null ? c.getSubcategory() : "";
                    String cat = c.getCategory() != null ? c.getCategory() : "";
                    if ("Fitness Science".equalsIgnoreCase(currentSubtab) || "Science".equalsIgnoreCase(currentSubtab)) {
                        return sub.toLowerCase().contains("science") || cat.toLowerCase().contains("science") || (c.getTitle() != null && c.getTitle().toLowerCase().contains("science"));
                    }
                    if ("Workout".equalsIgnoreCase(currentSubtab)) {
                        return sub.toLowerCase().contains("workout") || cat.toLowerCase().contains("workout");
                    }
                    if ("Nutrition".equalsIgnoreCase(currentSubtab)) {
                        return sub.toLowerCase().contains("nutrition") || cat.toLowerCase().contains("nutrition") || sub.toLowerCase().contains("protein");
                    }
                    if ("Recovery".equalsIgnoreCase(currentSubtab)) {
                        return sub.toLowerCase().contains("recovery") || cat.toLowerCase().contains("recovery") || sub.toLowerCase().contains("sleep");
                    }
                    if ("Motivation".equalsIgnoreCase(currentSubtab)) {
                        return sub.toLowerCase().contains("motivation") || cat.toLowerCase().contains("motivation") || (c.getTitle() != null && c.getTitle().toLowerCase().contains("fatigue"));
                    }
                    return currentSubtab.equalsIgnoreCase(sub) || currentSubtab.equalsIgnoreCase(cat);
                })
                .collect(Collectors.toList());

        List<FitnessContent> userSubmissions = contentService.getUserSubmissions(currentUser.getId());

        req.setAttribute("activeTab", currentTab);
        req.setAttribute("activeSubtab", currentSubtab);
        req.setAttribute("searchQuery", searchQuery);
        
        // Dynamic counts for tab badges
        req.setAttribute("totalExerciseCount", totalExerciseCount);
        req.setAttribute("totalWorkoutCount", totalWorkoutCount);
        req.setAttribute("totalNutritionCount", totalNutritionCount);
        req.setAttribute("totalRecoveryCount", totalRecoveryCount);
        req.setAttribute("totalArticleCount", totalArticleCount);

        // Filtered collections
        req.setAttribute("exercises", exercises);
        req.setAttribute("workoutGuides", workoutGuides);
        req.setAttribute("nutritionGuides", nutritionGuides);
        req.setAttribute("recoveryGuides", recoveryGuides);
        req.setAttribute("fitnessArticles", fitnessArticles);
        req.setAttribute("allApprovedArticles", allApprovedContent);
        req.setAttribute("userSubmissions", userSubmissions);

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

        resp.sendRedirect(req.getContextPath() + "/user/content?tab=articles");
    }
}
