package com.fitnesstracker.model;

public class SwimmingActivity extends FitnessActivity {
    private static final long serialVersionUID = 1L;

    public SwimmingActivity() {
        super("Swimming", 8.0);
    }

    @Override
    public int calculateCalories(int durationMinutes, double weightKg, String intensity) {
        double met = baseMetScore * getIntensityMultiplier(intensity);
        double calories = (met * 3.5 * weightKg / 200.0) * durationMinutes;
        return (int) Math.round(calories);
    }
}
