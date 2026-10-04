package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.*;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.NutritionService;
import com.fitnesstracker.service.UserService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.NutritionServiceImpl;
import com.fitnesstracker.service.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "NutritionServlet", urlPatterns = {"/user/nutrition"})
public class NutritionServlet extends HttpServlet {

    private final NutritionService nutritionService = new NutritionServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        int userId = currentUser.getId();

        // Refresh user details
        Optional<User> freshUser = userService.getUserById(userId);
        UserProfile userProfile = freshUser.map(User::getProfile).orElse(null);
        req.setAttribute("userProfile", userProfile);

        // Fetch Nutrition Profile
        Optional<NutritionProfile> profileOpt = nutritionService.getProfileByUserId(userId);
        
        if (profileOpt.isPresent()) {
            NutritionProfile profile = profileOpt.get();
            req.setAttribute("nutritionProfile", profile);

            // Fetch Target
            Optional<NutritionTarget> targetOpt = nutritionService.getTargetByUserId(userId);
            NutritionTarget target = targetOpt.orElse(null);
            req.setAttribute("nutritionTarget", target);

            // Fetch Active Meal Plan
            Optional<MealPlan> mealPlanOpt = nutritionService.getActiveMealPlan(userId);
            req.setAttribute("mealPlan", mealPlanOpt.orElse(null));

            // Fetch Today's Consumed Nutrition
            Date today = new Date(System.currentTimeMillis());
            List<NutritionLog> todayLogs = nutritionService.getTodayLogs(userId);
            Map<String, Integer> consumed = nutritionService.getDailyConsumedMacros(userId, today);
            
            req.setAttribute("todayLogs", todayLogs);
            req.setAttribute("consumedCalories", consumed.getOrDefault("calories", 0));
            req.setAttribute("consumedProtein", consumed.getOrDefault("protein", 0));
            req.setAttribute("consumedCarbs", consumed.getOrDefault("carbs", 0));
            req.setAttribute("consumedFat", consumed.getOrDefault("fat", 0));

            // Today's Water intake
            double todayWater = nutritionService.getTodayWater(userId);
            req.setAttribute("todayWater", todayWater);

            // Nutrition Trends for past 7 days
            List<Map<String, Object>> trends = nutritionService.getNutritionTrends(userId, 7);
            req.setAttribute("nutritionTrends", trends);

            // Plan History
            List<MealPlan> planHistory = nutritionService.getMealPlanHistory(userId);
            req.setAttribute("planHistory", planHistory);
        } else {
            req.setAttribute("nutritionProfile", null);
        }

        req.getRequestDispatcher("/user/nutrition.jsp").forward(req, resp);
    }
}
