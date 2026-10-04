package com.fitnesstracker.model;

import java.sql.Date;

public class NutritionLog extends BaseEntity {
    private int userId;
    private Date logDate;
    private String mealType;
    private String foodName;
    private String portionSize;
    private int calories;
    private int proteinG;
    private int carbsG;
    private int fatG;

    public NutritionLog() {
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getLogDate() {
        return logDate;
    }

    public void setLogDate(Date logDate) {
        this.logDate = logDate;
    }

    public String getMealType() {
        return mealType;
    }

    public void setMealType(String mealType) {
        this.mealType = mealType;
    }

    public String getFoodName() {
        return foodName;
    }

    public void setFoodName(String foodName) {
        this.foodName = foodName;
    }

    public String getPortionSize() {
        return portionSize;
    }

    public void setPortionSize(String portionSize) {
        this.portionSize = portionSize;
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
}
