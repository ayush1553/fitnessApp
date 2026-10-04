package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.NutritionProfile;
import com.fitnesstracker.model.NutritionTarget;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.NutritionService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.NutritionServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "GenerateDietPlanServlet", urlPatterns = {"/user/nutrition/generate-plan"})
public class GenerateDietPlanServlet extends HttpServlet {

    private final NutritionService nutritionService = new NutritionServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            Optional<NutritionProfile> profileOpt = nutritionService.getProfileByUserId(currentUser.getId());
            if (profileOpt.isPresent()) {
                NutritionProfile profile = profileOpt.get();

                // Check for quick goal or meals update if provided in form
                String newGoal = req.getParameter("fitnessGoal");
                String newDiet = req.getParameter("dietPreference");
                String exclusions = req.getParameter("foodExclusions");
                String mealsParam = req.getParameter("mealsPerDay");

                if (newGoal != null && !newGoal.trim().isEmpty()) {
                    profile.setFitnessGoal(newGoal);
                }
                if (newDiet != null && !newDiet.trim().isEmpty()) {
                    profile.setDietPreference(newDiet);
                }
                if (exclusions != null) {
                    profile.setFoodExclusions(exclusions.trim());
                }
                if (mealsParam != null && !mealsParam.trim().isEmpty()) {
                    try {
                        profile.setMealsPerDay(Integer.parseInt(mealsParam));
                    } catch (NumberFormatException ignored) {}
                }

                NutritionProfile updated = nutritionService.saveOrUpdateProfile(profile);
                NutritionTarget target = nutritionService.calculateAndSaveTargets(updated);
                nutritionService.generateAndSaveMealPlan(updated, target);

                activityLogService.logActivity(currentUser.getId(), "DIET_PLAN_REGENERATED", "Regenerated personalized meal plan", req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("New personalized meal plan generated successfully!"));
            } else {
                session.setAttribute("flashMessage", FlashMessage.error("Please complete your nutrition setup first."));
            }
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to generate meal plan: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/nutrition");
    }
}
