package com.fitnesstracker.model;

public class CyclingActivity extends FitnessActivity {
    private static final long serialVersionUID = 1L;

    public CyclingActivity() {
        super("Cycling", 7.5);
    }

    @Override
    public int calculateCalories(int durationMinutes, double weightKg, String intensity) {
        double met = baseMetScore * getIntensityMultiplier(intensity);
        double calories = (met * 3.5 * weightKg / 200.0) * durationMinutes;
        return (int) Math.round(calories);
    }
}
