package com.fitnesstracker.model;

import java.sql.Date;

/**
 * Model representing a user's logged workout session.
 */
public class Workout extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String workoutType;
    private Integer durationMinutes;
    private String intensity; // Low, Medium, High
    private Integer caloriesBurned;
    private Date workoutDate;
    private String notes;

    public Workout() {
        super();
        this.intensity = "Medium";
    }

    public Workout(Integer id, Integer userId, String workoutType, Integer durationMinutes, String intensity, Integer caloriesBurned, Date workoutDate, String notes) {
        super(id);
        this.userId = userId;
        this.workoutType = workoutType;
        this.durationMinutes = durationMinutes;
        this.intensity = intensity;
        this.caloriesBurned = caloriesBurned;
        this.workoutDate = workoutDate;
        this.notes = notes;
    }

    /**
     * Gets the polymorphic activity handler for this workout instance.
     */
    public FitnessActivity getActivity() {
        return WorkoutFactory.createActivity(this.workoutType);
    }

    // Getters and Setters
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getWorkoutType() {
        return workoutType;
    }

    public void setWorkoutType(String workoutType) {
        this.workoutType = workoutType;
    }

    public Integer getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(Integer durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getIntensity() {
        return intensity;
    }

    public void setIntensity(String intensity) {
        this.intensity = intensity;
    }

    public Integer getCaloriesBurned() {
        return caloriesBurned;
    }

    public void setCaloriesBurned(Integer caloriesBurned) {
        this.caloriesBurned = caloriesBurned;
    }

    public Date getWorkoutDate() {
        return workoutDate;
    }

    public void setWorkoutDate(Date workoutDate) {
        this.workoutDate = workoutDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}
