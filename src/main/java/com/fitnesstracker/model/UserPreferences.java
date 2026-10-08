package com.fitnesstracker.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing persistent user theme and UI preferences.
 */
public class UserPreferences implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String themeMode = "DARK";          // DARK, LIGHT, SYSTEM
    private String accentColor = "LIME";        // LIME, CYAN, EMERALD, PURPLE, BLUE
    private String glassIntensity = "MEDIUM";   // SUBTLE, MEDIUM, STRONG
    private boolean animationsEnabled = true;
    private boolean compactMode = false;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public UserPreferences() {
    }

    public UserPreferences(int userId) {
        this.userId = userId;
        this.themeMode = "DARK";
        this.accentColor = "LIME";
        this.glassIntensity = "MEDIUM";
        this.animationsEnabled = true;
        this.compactMode = false;
    }

    public UserPreferences(int id, int userId, String themeMode, String accentColor, 
                           String glassIntensity, boolean animationsEnabled, boolean compactMode, 
                           Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.userId = userId;
        this.themeMode = (themeMode != null && !themeMode.trim().isEmpty()) ? themeMode.toUpperCase() : "DARK";
        this.accentColor = (accentColor != null && !accentColor.trim().isEmpty()) ? accentColor.toUpperCase() : "LIME";
        this.glassIntensity = (glassIntensity != null && !glassIntensity.trim().isEmpty()) ? glassIntensity.toUpperCase() : "MEDIUM";
        this.animationsEnabled = animationsEnabled;
        this.compactMode = compactMode;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getThemeMode() {
        return themeMode;
    }

    public void setThemeMode(String themeMode) {
        this.themeMode = (themeMode != null && !themeMode.trim().isEmpty()) ? themeMode.toUpperCase() : "DARK";
    }

    public String getAccentColor() {
        return accentColor;
    }

    public void setAccentColor(String accentColor) {
        this.accentColor = (accentColor != null && !accentColor.trim().isEmpty()) ? accentColor.toUpperCase() : "LIME";
    }

    public String getGlassIntensity() {
        return glassIntensity;
    }

    public void setGlassIntensity(String glassIntensity) {
        this.glassIntensity = (glassIntensity != null && !glassIntensity.trim().isEmpty()) ? glassIntensity.toUpperCase() : "MEDIUM";
    }

    public boolean isAnimationsEnabled() {
        return animationsEnabled;
    }

    public void setAnimationsEnabled(boolean animationsEnabled) {
        this.animationsEnabled = animationsEnabled;
    }

    public boolean isCompactMode() {
        return compactMode;
    }

    public void setCompactMode(boolean compactMode) {
        this.compactMode = compactMode;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Helper lower-case getters for HTML data attributes
    public String getThemeModeLower() {
        return themeMode != null ? themeMode.toLowerCase() : "dark";
    }

    public String getAccentColorLower() {
        return accentColor != null ? accentColor.toLowerCase() : "lime";
    }

    public String getGlassIntensityLower() {
        return glassIntensity != null ? glassIntensity.toLowerCase() : "medium";
    }

    @Override
    public String toString() {
        return "UserPreferences{" +
                "id=" + id +
                ", userId=" + userId +
                ", themeMode='" + themeMode + '\'' +
                ", accentColor='" + accentColor + '\'' +
                ", glassIntensity='" + glassIntensity + '\'' +
                ", animationsEnabled=" + animationsEnabled +
                ", compactMode=" + compactMode +
                '}';
    }
}
