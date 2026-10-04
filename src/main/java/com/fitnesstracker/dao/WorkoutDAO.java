package com.fitnesstracker.dao;

import com.fitnesstracker.model.Workout;

import java.sql.Date;
import java.util.List;
import java.util.Map;

public interface WorkoutDAO extends GenericDAO<Workout, Integer> {

    List<Workout> findByUserId(Integer userId);

    List<Workout> findRecentByUserId(Integer userId, int limit);

    List<Workout> findFilteredWorkouts(Integer userId, String type, String intensity, Date startDate, Date endDate, String sortBy, String sortDir);

    int countTotalWorkouts();

    int countWorkoutsByUserId(Integer userId);

    int getTotalCaloriesBurnedByUserId(Integer userId);

    int getTotalDurationMinutesByUserId(Integer userId);

    Map<String, Integer> getWeeklyWorkoutDuration(Integer userId);

    Map<String, Integer> getMonthlyWorkoutDuration(Integer userId);

    Map<String, Integer> getWeeklyCaloriesBurned(Integer userId);

    Map<String, Integer> getWorkoutTypeDistribution(Integer userId);

    Map<String, Integer> getOverallWorkoutActivityStats();
}
