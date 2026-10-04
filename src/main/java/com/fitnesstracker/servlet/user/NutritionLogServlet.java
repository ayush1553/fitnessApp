package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.NutritionLog;
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
import java.sql.Date;

@WebServlet(name = "NutritionLogServlet", urlPatterns = {"/user/nutrition/log/add", "/user/nutrition/log/delete"})
public class NutritionLogServlet extends HttpServlet {

    private final NutritionService nutritionService = new NutritionServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        String path = req.getServletPath();

        try {
            if ("/user/nutrition/log/delete".equals(path)) {
                int logId = ValidationUtil.parsePositiveInt(req.getParameter("id"), 0);
                if (logId > 0) {
                    nutritionService.deleteNutritionLog(logId);
                    session.setAttribute("flashMessage", FlashMessage.success("Food log item removed."));
                }
            } else {
                String mealType = req.getParameter("mealType");
                String foodName = req.getParameter("foodName");
                String portionSize = req.getParameter("portionSize");
                int calories = ValidationUtil.parsePositiveInt(req.getParameter("calories"), 0);
                int proteinG = ValidationUtil.parsePositiveInt(req.getParameter("proteinG"), 0);
                int carbsG = ValidationUtil.parsePositiveInt(req.getParameter("carbsG"), 0);
                int fatG = ValidationUtil.parsePositiveInt(req.getParameter("fatG"), 0);
                String logDateStr = req.getParameter("logDate");

                if (foodName == null || foodName.trim().isEmpty()) {
                    session.setAttribute("flashMessage", FlashMessage.error("Food name is required."));
                    resp.sendRedirect(req.getContextPath() + "/user/nutrition");
                    return;
                }

                NutritionLog log = new NutritionLog();
                log.setUserId(currentUser.getId());
                log.setMealType(mealType != null ? mealType : "Snack");
                log.setFoodName(foodName.trim());
                log.setPortionSize(portionSize != null ? portionSize.trim() : "1 serving");
                log.setCalories(calories);
                log.setProteinG(proteinG);
                log.setCarbsG(carbsG);
                log.setFatG(fatG);

                if (logDateStr != null && !logDateStr.trim().isEmpty()) {
                    try {
                        log.setLogDate(Date.valueOf(logDateStr));
                    } catch (IllegalArgumentException e) {
                        log.setLogDate(new Date(System.currentTimeMillis()));
                    }
                } else {
                    log.setLogDate(new Date(System.currentTimeMillis()));
                }

                nutritionService.logFood(log);
                activityLogService.logActivity(currentUser.getId(), "FOOD_LOGGED", "Logged food: " + foodName + " (" + calories + " kcal)", req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Food logged successfully!"));
            }
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Action failed: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/nutrition");
    }
}
