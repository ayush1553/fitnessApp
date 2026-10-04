package com.fitnesstracker.model;

public class MealPlanItem extends BaseEntity {
    private int mealPlanId;
    private int mealNumber;
    private String mealName;
    private String foodItems;
    private int calories;
    private int proteinG;
    private int carbsG;
    private int fatG;
    private String notes;

    public MealPlanItem() {
    }

    public int getMealPlanId() {
        return mealPlanId;
    }

    public void setMealPlanId(int mealPlanId) {
        this.mealPlanId = mealPlanId;
    }

    public int getMealNumber() {
        return mealNumber;
    }

    public void setMealNumber(int mealNumber) {
        this.mealNumber = mealNumber;
    }

    public String getMealName() {
        return mealName;
    }

    public void setMealName(String mealName) {
        this.mealName = mealName;
    }

    public String getFoodItems() {
        return foodItems;
    }

    public void setFoodItems(String foodItems) {
        this.foodItems = foodItems;
    }

    public int getCalories() {
        return calories;
    }

    public void setCalories(int calories) {
        this.calories = calories;
    }

    public int getProteinG() {
        return proteinG;
    }

    public void setProteinG(int proteinG) {
        this.proteinG = proteinG;
    }

    public int getCarbsG() {
        return carbsG;
    }

    public void setCarbsG(int carbsG) {
        this.carbsG = carbsG;
    }

    public int getFatG() {
        return fatG;
    }

    public void setFatG(int fatG) {
        this.fatG = fatG;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}
