package com.fitnesstracker.servlet.user;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.NutritionProfile;
import com.fitnesstracker.model.NutritionTarget;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.NutritionService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.NutritionServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import com.fitnesstracker.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "NutritionProfileServlet", urlPatterns = {"/user/nutrition/setup", "/user/nutrition/profile/update"})
public class NutritionProfileServlet extends HttpServlet {

    private final NutritionService nutritionService = new NutritionServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            int age = ValidationUtil.parsePositiveInt(req.getParameter("age"), 0);
            String sex = req.getParameter("sex");
            double heightCm = ValidationUtil.parsePositiveDouble(req.getParameter("heightCm"), 0.0);
            double weightKg = ValidationUtil.parsePositiveDouble(req.getParameter("weightKg"), 0.0);
            String activityLevel = req.getParameter("activityLevel");
            String fitnessGoal = req.getParameter("fitnessGoal");
            String dietPreference = req.getParameter("dietPreference");
            String foodExclusions = req.getParameter("foodExclusions");
            int mealsPerDay = ValidationUtil.parsePositiveInt(req.getParameter("mealsPerDay"), 4);

            if (age <= 0 || heightCm <= 0 || weightKg <= 0) {
                throw new AppException("Please enter valid age, height, and weight values.");
            }
            if (sex == null || sex.trim().isEmpty()) {
                sex = "Male";
            }
            if (activityLevel == null || activityLevel.trim().isEmpty()) {
                activityLevel = "Moderately Active";
            }
            if (fitnessGoal == null || fitnessGoal.trim().isEmpty()) {
                fitnessGoal = "Maintenance";
            }
            if (dietPreference == null || dietPreference.trim().isEmpty()) {
                dietPreference = "Non-Vegetarian";
            }

            NutritionProfile profile = new NutritionProfile();
            profile.setUserId(currentUser.getId());
            profile.setAge(age);
            profile.setSex(sex);
            profile.setHeightCm(heightCm);
            profile.setWeightKg(weightKg);
            profile.setActivityLevel(activityLevel);
            profile.setFitnessGoal(fitnessGoal);
            profile.setDietPreference(dietPreference);
            profile.setFoodExclusions(foodExclusions != null ? foodExclusions.trim() : "");
            profile.setMealsPerDay(mealsPerDay);

            NutritionProfile savedProfile = nutritionService.saveOrUpdateProfile(profile);
            NutritionTarget target = nutritionService.calculateAndSaveTargets(savedProfile);
            nutritionService.generateAndSaveMealPlan(savedProfile, target);

            activityLogService.logActivity(currentUser.getId(), "NUTRITION_SETUP", "Configured personalized nutrition plan", req.getRemoteAddr());
            session.setAttribute("flashMessage", FlashMessage.success("Personalized nutrition plan & targets generated successfully!"));

        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to generate plan: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/nutrition");
    }
}
