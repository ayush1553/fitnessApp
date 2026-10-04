package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.UserDAO;
import com.fitnesstracker.dao.UserProfileDAO;
import com.fitnesstracker.dao.WorkoutDAO;
import com.fitnesstracker.dao.impl.UserDAOImpl;
import com.fitnesstracker.dao.impl.UserProfileDAOImpl;
import com.fitnesstracker.dao.impl.WorkoutDAOImpl;
import com.fitnesstracker.exception.InvalidWorkoutException;
import com.fitnesstracker.model.FitnessActivity;
import com.fitnesstracker.model.UserProfile;
import com.fitnesstracker.model.Workout;
import com.fitnesstracker.model.WorkoutFactory;
import com.fitnesstracker.service.WorkoutService;
import com.fitnesstracker.util.ValidationUtil;

import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class WorkoutServiceImpl implements WorkoutService {

    private final WorkoutDAO workoutDAO;
    private final UserProfileDAO userProfileDAO;

    public WorkoutServiceImpl() {
        this.workoutDAO = new WorkoutDAOImpl();
        this.userProfileDAO = new UserProfileDAOImpl();
    }

    public WorkoutServiceImpl(WorkoutDAO workoutDAO, UserProfileDAO userProfileDAO) {
        this.workoutDAO = workoutDAO;
        this.userProfileDAO = userProfileDAO;
    }

    @Override
    public Workout logWorkout(Integer userId, String workoutType, Integer durationMinutes, String intensity, Integer caloriesBurned, Date workoutDate, String notes) {
        validateWorkoutData(workoutType, durationMinutes);

        if (workoutDate == null) {
            workoutDate = new Date(System.currentTimeMillis());
        }

        if (caloriesBurned == null || caloriesBurned <= 0) {
            Double weightKg = 70.0;
            Optional<UserProfile> profOpt = userProfileDAO.findByUserId(userId);
            if (profOpt.isPresent() && profOpt.get().getWeightKg() != null) {
                weightKg = profOpt.get().getWeightKg().doubleValue();
            }
            caloriesBurned = calculateEstimatedCalories(workoutType, durationMinutes, intensity, weightKg);
        }

        Workout workout = new Workout();
        workout.setUserId(userId);
        workout.setWorkoutType(workoutType);
        workout.setDurationMinutes(durationMinutes);
        workout.setIntensity(intensity != null ? intensity : "Medium");
        workout.setCaloriesBurned(caloriesBurned);
        workout.setWorkoutDate(workoutDate);
        workout.setNotes(notes);

        return workoutDAO.save(workout);
    }

    @Override
    public boolean updateWorkout(Integer workoutId, Integer userId, String workoutType, Integer durationMinutes, String intensity, Integer caloriesBurned, Date workoutDate, String notes) {
        validateWorkoutData(workoutType, durationMinutes);

        Optional<Workout> opt = workoutDAO.findById(workoutId);
        if (opt.isEmpty() || !opt.get().getUserId().equals(userId)) {
            throw new InvalidWorkoutException("Workout not found or permission denied.");
        }

        if (caloriesBurned == null || caloriesBurned <= 0) {
            Double weightKg = 70.0;
            Optional<UserProfile> profOpt = userProfileDAO.findByUserId(userId);
            if (profOpt.isPresent() && profOpt.get().getWeightKg() != null) {
                weightKg = profOpt.get().getWeightKg().doubleValue();
            }
            caloriesBurned = calculateEstimatedCalories(workoutType, durationMinutes, intensity, weightKg);
        }

        Workout workout = opt.get();
        workout.setWorkoutType(workoutType);
        workout.setDurationMinutes(durationMinutes);
        workout.setIntensity(intensity != null ? intensity : "Medium");
        workout.setCaloriesBurned(caloriesBurned);
        workout.setWorkoutDate(workoutDate != null ? workoutDate : workout.getWorkoutDate());
        workout.setNotes(notes);

        return workoutDAO.update(workout);
    }

    @Override
    public boolean deleteWorkout(Integer workoutId, Integer userId) {
        Optional<Workout> opt = workoutDAO.findById(workoutId);
        if (opt.isEmpty() || !opt.get().getUserId().equals(userId)) {
            throw new InvalidWorkoutException("Workout not found or access unauthorized.");
        }
        return workoutDAO.delete(workoutId);
    }

    @Override
    public Optional<Workout> getWorkoutById(Integer workoutId) {
        return workoutDAO.findById(workoutId);
    }

    @Override
    public List<Workout> getUserWorkouts(Integer userId) {
        return workoutDAO.findByUserId(userId);
    }

    @Override
    public List<Workout> getRecentUserWorkouts(Integer userId, int limit) {
        return workoutDAO.findRecentByUserId(userId, limit);
    }

    @Override
    public List<Workout> filterUserWorkouts(Integer userId, String type, String intensity, Date startDate, Date endDate, String sortBy, String sortDir) {
        return workoutDAO.findFilteredWorkouts(userId, type, intensity, startDate, endDate, sortBy, sortDir);
    }

    @Override
    public int calculateEstimatedCalories(String workoutType, int durationMinutes, String intensity, Double userWeightKg) {
        double weight = (userWeightKg != null && userWeightKg > 0) ? userWeightKg : 70.0;
        FitnessActivity activity = WorkoutFactory.createActivity(workoutType);
        return activity.calculateCalories(durationMinutes, weight, intensity);
    }

    @Override
    public int getTotalCaloriesBurned(Integer userId) {
        return workoutDAO.getTotalCaloriesBurnedByUserId(userId);
    }

    @Override
    public int getTotalWorkoutDuration(Integer userId) {
        return workoutDAO.getTotalDurationMinutesByUserId(userId);
    }

    @Override
    public int getTotalWorkoutCount(Integer userId) {
        return workoutDAO.countWorkoutsByUserId(userId);
    }

    @Override
    public int getSystemTotalWorkouts() {
        return workoutDAO.countTotalWorkouts();
    }

    @Override
    public Map<String, Integer> getWeeklyWorkoutDuration(Integer userId) {
        return workoutDAO.getWeeklyWorkoutDuration(userId);
    }

    @Override
    public Map<String, Integer> getMonthlyWorkoutDuration(Integer userId) {
        return workoutDAO.getMonthlyWorkoutDuration(userId);
    }

    @Override
    public Map<String, Integer> getWeeklyCaloriesBurned(Integer userId) {
        return workoutDAO.getWeeklyCaloriesBurned(userId);
    }

    @Override
    public Map<String, Integer> getWorkoutTypeDistribution(Integer userId) {
        return workoutDAO.getWorkoutTypeDistribution(userId);
    }

    @Override
    public Map<String, Integer> getGlobalWorkoutTypeStats() {
        return workoutDAO.getOverallWorkoutActivityStats();
    }

    private void validateWorkoutData(String type, Integer duration) {
        if (!ValidationUtil.isNotEmpty(type)) {
            throw new InvalidWorkoutException("Workout type is required.");
        }
        if (duration == null || duration <= 0 || duration > 1440) {
            throw new InvalidWorkoutException("Workout duration must be between 1 and 1440 minutes (24h).");
        }
    }
}
