package com.fitnesstracker.dao;

import com.fitnesstracker.model.NutritionProfile;
import com.fitnesstracker.model.NutritionTarget;

import java.util.Map;
import java.util.Optional;

public interface NutritionDAO {
    NutritionProfile saveProfile(NutritionProfile profile);
    boolean updateProfile(NutritionProfile profile);
    Optional<NutritionProfile> findProfileByUserId(int userId);
    
    NutritionTarget saveTarget(NutritionTarget target);
    boolean updateTarget(NutritionTarget target);
    Optional<NutritionTarget> findTargetByUserId(int userId);

    // Admin Aggregated Statistics
    Map<String, Object> getAggregatedStatistics();
}
