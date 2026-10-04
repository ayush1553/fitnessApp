package com.fitnesstracker.model;

import java.sql.Timestamp;

public class NutritionTarget extends BaseEntity {
    private int userId;
    private int profileId;
    private int targetCalories;
    private int targetProteinG;
    private int targetCarbsG;
    private int targetFatG;
    private int proteinPct;
    private int carbsPct;
    private int fatPct;
    private double waterTargetL;
    private Timestamp calculatedAt;

    public NutritionTarget() {
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

    public int getTargetCalories() {
        return targetCalories;
    }

    public void setTargetCalories(int targetCalories) {
        this.targetCalories = targetCalories;
    }

    public int getTargetProteinG() {
        return targetProteinG;
    }

    public void setTargetProteinG(int targetProteinG) {
        this.targetProteinG = targetProteinG;
    }

    public int getTargetCarbsG() {
        return targetCarbsG;
    }

    public void setTargetCarbsG(int targetCarbsG) {
        this.targetCarbsG = targetCarbsG;
    }

    public int getTargetFatG() {
        return targetFatG;
    }

    public void setTargetFatG(int targetFatG) {
        this.targetFatG = targetFatG;
    }

    public int getProteinPct() {
        return proteinPct;
    }

    public void setProteinPct(int proteinPct) {
        this.proteinPct = proteinPct;
    }

    public int getCarbsPct() {
        return carbsPct;
    }

    public void setCarbsPct(int carbsPct) {
        this.carbsPct = carbsPct;
    }

    public int getFatPct() {
        return fatPct;
    }

    public void setFatPct(int fatPct) {
        this.fatPct = fatPct;
    }

    public double getWaterTargetL() {
        return waterTargetL;
    }

    public void setWaterTargetL(double waterTargetL) {
        this.waterTargetL = waterTargetL;
    }

    public Timestamp getCalculatedAt() {
        return calculatedAt;
    }

    public void setCalculatedAt(Timestamp calculatedAt) {
        this.calculatedAt = calculatedAt;
    }
}
