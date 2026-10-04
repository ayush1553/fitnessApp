package com.fitnesstracker.service;

import com.fitnesstracker.model.NutritionProfile;
import com.fitnesstracker.model.NutritionTarget;
import com.fitnesstracker.model.MealPlan;

public interface NutritionCalculator {
    double calculateBMR(NutritionProfile profile);
    double calculateTDEE(NutritionProfile profile);
    NutritionTarget calculateTarget(NutritionProfile profile);
    MealPlan generateMealPlan(NutritionProfile profile, NutritionTarget target);
}
