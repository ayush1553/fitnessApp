package com.fitnesstracker.service;

import com.fitnesstracker.model.Workout;

import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface WorkoutService {

    Workout logWorkout(Integer userId, String workoutType, Integer durationMinutes, String intensity, Integer caloriesBurned, Date workoutDate, String notes);

    boolean updateWorkout(Integer workoutId, Integer userId, String workoutType, Integer durationMinutes, String intensity, Integer caloriesBurned, Date workoutDate, String notes);

    boolean deleteWorkout(Integer workoutId, Integer userId);

    Optional<Workout> getWorkoutById(Integer workoutId);

    List<Workout> getUserWorkouts(Integer userId);

    List<Workout> getRecentUserWorkouts(Integer userId, int limit);

    List<Workout> filterUserWorkouts(Integer userId, String type, String intensity, Date startDate, Date endDate, String sortBy, String sortDir);

    int calculateEstimatedCalories(String workoutType, int durationMinutes, String intensity, Double userWeightKg);

    int getTotalCaloriesBurned(Integer userId);

    int getTotalWorkoutDuration(Integer userId);

    int getTotalWorkoutCount(Integer userId);

    int getSystemTotalWorkouts();

    Map<String, Integer> getWeeklyWorkoutDuration(Integer userId);

    Map<String, Integer> getMonthlyWorkoutDuration(Integer userId);

    Map<String, Integer> getWeeklyCaloriesBurned(Integer userId);

    Map<String, Integer> getWorkoutTypeDistribution(Integer userId);

    Map<String, Integer> getGlobalWorkoutTypeStats();
}
