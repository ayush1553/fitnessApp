package com.fitnesstracker.model;

import java.io.Serializable;

/**
 * Abstract class modeling different types of physical activities.
 * Demonstrates Polymorphism and Strategy for accurate calorie estimation.
 */
public abstract class FitnessActivity implements Serializable {
    private static final long serialVersionUID = 1L;

    protected String activityName;
    protected double baseMetScore; // Metabolic Equivalent of Task baseline

    public FitnessActivity(String activityName, double baseMetScore) {
        this.activityName = activityName;
        this.baseMetScore = baseMetScore;
    }

    public String getActivityName() {
        return activityName;
    }

    public double getBaseMetScore() {
        return baseMetScore;
    }

    /**
     * Polymorphic calorie calculation algorithm:
     * Calories = (MET * 3.5 * weightKg / 200) * durationMinutes
     * Adjusted by exercise intensity factor.
     */
    public abstract int calculateCalories(int durationMinutes, double weightKg, String intensity);

    protected double getIntensityMultiplier(String intensity) {
        if ("High".equalsIgnoreCase(intensity)) {
            return 1.35;
        } else if ("Low".equalsIgnoreCase(intensity)) {
            return 0.75;
        }
        return 1.0; // Medium
    }
}
