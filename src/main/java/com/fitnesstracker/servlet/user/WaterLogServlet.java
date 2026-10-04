package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.User;
import com.fitnesstracker.service.NutritionService;
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

@WebServlet(name = "WaterLogServlet", urlPatterns = {"/user/nutrition/water/add", "/user/nutrition/water/reset"})
public class WaterLogServlet extends HttpServlet {

    private final NutritionService nutritionService = new NutritionServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        String path = req.getServletPath();

        try {
            if ("/user/nutrition/water/reset".equals(path)) {
                nutritionService.resetTodayWater(currentUser.getId());
                session.setAttribute("flashMessage", FlashMessage.success("Today's water log reset to 0 L."));
            } else {
                double amount = ValidationUtil.parsePositiveDouble(req.getParameter("amountLiters"), 0.25);
                if (amount <= 0) amount = 0.25;
                nutritionService.logWater(currentUser.getId(), amount);
                session.setAttribute("flashMessage", FlashMessage.success("Hydration logged (+" + amount + " L)!"));
            }
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to log water: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/nutrition");
    }
}
