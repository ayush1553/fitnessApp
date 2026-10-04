package com.fitnesstracker.dao;

import com.fitnesstracker.model.MealPlan;
import com.fitnesstracker.model.MealPlanItem;

import java.util.List;
import java.util.Optional;

public interface MealPlanDAO {
    MealPlan save(MealPlan plan);
    Optional<MealPlan> findActiveByUserId(int userId);
    List<MealPlan> findHistoryByUserId(int userId);
    boolean deactivateAllByUserId(int userId);
    List<MealPlanItem> findItemsByPlanId(int planId);
}
