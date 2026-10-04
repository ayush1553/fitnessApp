package com.fitnesstracker.service;

import com.fitnesstracker.model.*;

import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface NutritionService {
    Optional<NutritionProfile> getProfileByUserId(int userId);
    NutritionProfile saveOrUpdateProfile(NutritionProfile profile);
    NutritionTarget calculateAndSaveTargets(NutritionProfile profile);
    Optional<NutritionTarget> getTargetByUserId(int userId);
    
    MealPlan generateAndSaveMealPlan(NutritionProfile profile, NutritionTarget target);
    Optional<MealPlan> getActiveMealPlan(int userId);
    List<MealPlan> getMealPlanHistory(int userId);
    
    NutritionLog logFood(NutritionLog log);
    boolean deleteNutritionLog(int logId);
    List<NutritionLog> getTodayLogs(int userId);
    List<NutritionLog> getLogsByDate(int userId, Date date);
    List<NutritionLog> getLogsByRange(int userId, Date start, Date end);
    Map<String, Integer> getDailyConsumedMacros(int userId, Date date);
    
    WaterLog logWater(int userId, double liters);
    double getTodayWater(int userId);
    boolean resetTodayWater(int userId);
    
    List<Map<String, Object>> getNutritionTrends(int userId, int days);
    Map<String, Object> getAggregatedStatistics();
}
