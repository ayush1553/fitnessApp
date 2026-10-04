package com.fitnesstracker.model;

/**
 * Concrete implementation of a regular end-user of the fitness application.
 */
public class RegularUser extends User {
    private static final long serialVersionUID = 1L;

    public RegularUser() {
        super();
        this.role = "USER";
        this.status = "ACTIVE";
    }

    public RegularUser(Integer id, String name, String email, String password, String status) {
        super(id, name, email, password, "USER", status);
    }

    @Override
    public String getRoleName() {
        return "Standard Member";
    }

    @Override
    public String getDashboardRoute() {
        return "/user/dashboard";
    }

    @Override
    public boolean canPerformAdminActions() {
        return false;
    }

    @Override
    public double calculateDailyCalorieRecommendation() {
        // Harris-Benedict revised baseline calculation
        if (profile != null && profile.getWeightKg() != null && profile.getHeightCm() != null && profile.getAge() != null) {
            double weight = profile.getWeightKg().doubleValue();
            double height = profile.getHeightCm().doubleValue();
            int age = profile.getAge();
            // Baseline BMR estimate
            double bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
            
            String level = profile.getActivityLevel();
            if ("VERY_ACTIVE".equalsIgnoreCase(level)) {
                return Math.round(bmr * 1.725);
            } else if ("MODERATELY_ACTIVE".equalsIgnoreCase(level)) {
                return Math.round(bmr * 1.55);
            } else if ("LIGHTLY_ACTIVE".equalsIgnoreCase(level)) {
                return Math.round(bmr * 1.375);
            } else {
                return Math.round(bmr * 1.2);
            }
        }
        return 2200.0; // Default standard baseline
    }
}
