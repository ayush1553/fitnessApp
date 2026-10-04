package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.MealPlanDAO;
import com.fitnesstracker.dao.NutritionDAO;
import com.fitnesstracker.dao.NutritionLogDAO;
import com.fitnesstracker.dao.WaterLogDAO;
import com.fitnesstracker.dao.impl.MealPlanDAOImpl;
import com.fitnesstracker.dao.impl.NutritionDAOImpl;
import com.fitnesstracker.dao.impl.NutritionLogDAOImpl;
import com.fitnesstracker.dao.impl.WaterLogDAOImpl;
import com.fitnesstracker.exception.InvalidNutritionProfileException;
import com.fitnesstracker.model.*;
import com.fitnesstracker.service.NutritionCalculator;
import com.fitnesstracker.service.NutritionService;

import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class NutritionServiceImpl implements NutritionService {

    private final NutritionDAO nutritionDAO;
    private final MealPlanDAO mealPlanDAO;
    private final NutritionLogDAO nutritionLogDAO;
    private final WaterLogDAO waterLogDAO;
    private final NutritionCalculator calculator;

    public NutritionServiceImpl() {
        this.nutritionDAO = new NutritionDAOImpl();
        this.mealPlanDAO = new MealPlanDAOImpl();
        this.nutritionLogDAO = new NutritionLogDAOImpl();
        this.waterLogDAO = new WaterLogDAOImpl();
        this.calculator = new StandardNutritionCalculator();
    }

    public NutritionServiceImpl(NutritionDAO nutritionDAO, MealPlanDAO mealPlanDAO,
                                NutritionLogDAO nutritionLogDAO, WaterLogDAO waterLogDAO,
                                NutritionCalculator calculator) {
        this.nutritionDAO = nutritionDAO;
        this.mealPlanDAO = mealPlanDAO;
        this.nutritionLogDAO = nutritionLogDAO;
        this.waterLogDAO = waterLogDAO;
        this.calculator = calculator;
    }

    private void validateProfile(NutritionProfile profile) {
        if (profile == null) {
            throw new InvalidNutritionProfileException("Nutrition profile cannot be null");
        }
        if (profile.getAge() <= 0 || profile.getAge() > 120) {
            throw new InvalidNutritionProfileException("Age must be between 1 and 120");
        }
        if (profile.getHeightCm() <= 50 || profile.getHeightCm() > 280) {
            throw new InvalidNutritionProfileException("Height must be between 50cm and 280cm");
        }
        if (profile.getWeightKg() <= 20 || profile.getWeightKg() > 400) {
            throw new InvalidNutritionProfileException("Weight must be between 20kg and 400kg");
        }
        if (profile.getFitnessGoal() == null || profile.getFitnessGoal().trim().isEmpty()) {
            throw new InvalidNutritionProfileException("Fitness goal is required");
        }
        if (profile.getActivityLevel() == null || profile.getActivityLevel().trim().isEmpty()) {
            throw new InvalidNutritionProfileException("Activity level is required");
        }
        if (profile.getDietPreference() == null || profile.getDietPreference().trim().isEmpty()) {
            throw new InvalidNutritionProfileException("Diet preference is required");
        }
    }

    @Override
    public Optional<NutritionProfile> getProfileByUserId(int userId) {
        return nutritionDAO.findProfileByUserId(userId);
    }

    @Override
    public NutritionProfile saveOrUpdateProfile(NutritionProfile profile) {
        validateProfile(profile);

        // Compute BMR & TDEE
        double bmr = calculator.calculateBMR(profile);
        double tdee = calculator.calculateTDEE(profile);
        profile.setBmr(Math.round(bmr * 10.0) / 10.0);
        profile.setTdee(Math.round(tdee * 10.0) / 10.0);

        return nutritionDAO.saveProfile(profile);
    }

    @Override
    public NutritionTarget calculateAndSaveTargets(NutritionProfile profile) {
        NutritionTarget target = calculator.calculateTarget(profile);
        target.setProfileId(profile.getId());
        return nutritionDAO.saveTarget(target);
    }

    @Override
    public Optional<NutritionTarget> getTargetByUserId(int userId) {
        return nutritionDAO.findTargetByUserId(userId);
    }

    @Override
    public MealPlan generateAndSaveMealPlan(NutritionProfile profile, NutritionTarget target) {
        MealPlan plan = calculator.generateMealPlan(profile, target);
        return mealPlanDAO.save(plan);
    }

    @Override
    public Optional<MealPlan> getActiveMealPlan(int userId) {
        return mealPlanDAO.findActiveByUserId(userId);
    }

    @Override
    public List<MealPlan> getMealPlanHistory(int userId) {
        return mealPlanDAO.findHistoryByUserId(userId);
    }

    @Override
    public NutritionLog logFood(NutritionLog log) {
        if (log.getCalories() < 0 || log.getProteinG() < 0 || log.getCarbsG() < 0 || log.getFatG() < 0) {
            throw new IllegalArgumentException("Macro and calorie values cannot be negative");
        }
        if (log.getLogDate() == null) {
            log.setLogDate(new Date(System.currentTimeMillis()));
        }
        return nutritionLogDAO.save(log);
    }

    @Override
    public boolean deleteNutritionLog(int logId) {
        return nutritionLogDAO.delete(logId);
    }

    @Override
    public List<NutritionLog> getTodayLogs(int userId) {
        Date today = new Date(System.currentTimeMillis());
        return nutritionLogDAO.findByUserIdAndDate(userId, today);
    }

    @Override
    public List<NutritionLog> getLogsByDate(int userId, Date date) {
        return nutritionLogDAO.findByUserIdAndDate(userId, date);
    }

    @Override
    public List<NutritionLog> getLogsByRange(int userId, Date start, Date end) {
        return nutritionLogDAO.findByUserIdAndDateRange(userId, start, end);
    }

    @Override
    public Map<String, Integer> getDailyConsumedMacros(int userId, Date date) {
        return nutritionLogDAO.getDailyTotalMacros(userId, date);
    }

    @Override
    public WaterLog logWater(int userId, double liters) {
        WaterLog log = new WaterLog();
        log.setUserId(userId);
        log.setLogDate(new Date(System.currentTimeMillis()));
        log.setAmountLiters(liters);
        log.setLogTime(new Time(System.currentTimeMillis()));
        return waterLogDAO.save(log);
    }

    @Override
    public double getTodayWater(int userId) {
        Date today = new Date(System.currentTimeMillis());
        return waterLogDAO.getTotalWaterByUserIdAndDate(userId, today);
    }

    @Override
    public boolean resetTodayWater(int userId) {
        Date today = new Date(System.currentTimeMillis());
        return waterLogDAO.deleteByUserIdAndDate(userId, today);
    }

    @Override
    public List<Map<String, Object>> getNutritionTrends(int userId, int days) {
        return nutritionLogDAO.getDailyNutritionSummaryList(userId, days);
    }

    @Override
    public Map<String, Object> getAggregatedStatistics() {
        return nutritionDAO.getAggregatedStatistics();
    }
}
