package com.fitnesstracker.model;

import java.util.ArrayList;
import java.util.List;

public class MealPlan extends BaseEntity {
    private int userId;
    private int profileId;
    private String planName;
    private int totalCalories;
    private int totalProteinG;
    private int totalCarbsG;
    private int totalFatG;
    private boolean isActive;
    private List<MealPlanItem> items = new ArrayList<>();

    public MealPlan() {
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    public String getPlanName() {
        return planName;
    }

    public void setPlanName(String planName) {
        this.planName = planName;
    }

    public int getTotalCalories() {
        return totalCalories;
    }

    public void setTotalCalories(int totalCalories) {
        this.totalCalories = totalCalories;
    }

    public int getTotalProteinG() {
        return totalProteinG;
    }

    public void setTotalProteinG(int totalProteinG) {
        this.totalProteinG = totalProteinG;
    }

    public int getTotalCarbsG() {
        return totalCarbsG;
    }

    public void setTotalCarbsG(int totalCarbsG) {
        this.totalCarbsG = totalCarbsG;
    }

    public int getTotalFatG() {
        return totalFatG;
    }

    public void setTotalFatG(int totalFatG) {
        this.totalFatG = totalFatG;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public List<MealPlanItem> getItems() {
        return items;
    }

    public void setItems(List<MealPlanItem> items) {
        this.items = items;
    }
}
