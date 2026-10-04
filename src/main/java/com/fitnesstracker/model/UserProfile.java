package com.fitnesstracker.model;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * User biometric and fitness preference profile.
 */
public class UserProfile extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Integer userId;
    private Integer age;
    private BigDecimal heightCm;
    private BigDecimal weightKg;
    private String fitnessGoal;
    private String activityLevel;
    private String profileImage;

    public UserProfile() {
        super();
        this.fitnessGoal = "Stay fit and active";
        this.activityLevel = "MODERATELY_ACTIVE";
        this.profileImage = "default-avatar.png";
    }

    public UserProfile(Integer userId, Integer age, BigDecimal heightCm, BigDecimal weightKg, String fitnessGoal, String activityLevel, String profileImage) {
        this.userId = userId;
        this.age = age;
        this.heightCm = heightCm;
        this.weightKg = weightKg;
        this.fitnessGoal = fitnessGoal;
        this.activityLevel = activityLevel;
        this.profileImage = (profileImage != null && !profileImage.trim().isEmpty()) ? profileImage : "default-avatar.png";
    }

    /**
     * Calculates Body Mass Index (BMI = kg / m^2)
     */
    public Double calculateBMI() {
        if (heightCm == null || weightKg == null || heightCm.doubleValue() <= 0 || weightKg.doubleValue() <= 0) {
            return null;
        }
        double heightM = heightCm.doubleValue() / 100.0;
        double bmi = weightKg.doubleValue() / (heightM * heightM);
        return BigDecimal.valueOf(bmi).setScale(1, RoundingMode.HALF_UP).doubleValue();
    }

    public String getBMICategory() {
        Double bmi = calculateBMI();
        if (bmi == null) return "Unknown";
        if (bmi < 18.5) return "Underweight";
        if (bmi < 25.0) return "Normal Weight";
        if (bmi < 30.0) return "Overweight";
        return "Obese";
    }

    // Getters and Setters
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public BigDecimal getHeightCm() {
        return heightCm;
    }

    public void setHeightCm(BigDecimal heightCm) {
        this.heightCm = heightCm;
    }

    public BigDecimal getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(BigDecimal weightKg) {
        this.weightKg = weightKg;
    }

    public String getFitnessGoal() {
        return fitnessGoal;
    }

    public void setFitnessGoal(String fitnessGoal) {
        this.fitnessGoal = fitnessGoal;
    }

    public String getActivityLevel() {
        return activityLevel;
    }

    public void setActivityLevel(String activityLevel) {
        this.activityLevel = activityLevel;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }
}
