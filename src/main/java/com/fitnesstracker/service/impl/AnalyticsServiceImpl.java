package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.*;
import com.fitnesstracker.dao.impl.*;
import com.fitnesstracker.model.*;
import com.fitnesstracker.service.AnalyticsService;

import java.util.*;

public class AnalyticsServiceImpl implements AnalyticsService {

    private final WorkoutDAO workoutDAO;
    private final GoalDAO goalDAO;
    private final ChallengeDAO challengeDAO;
    private final ChallengeParticipantDAO participantDAO;
    private final FitnessContentDAO contentDAO;
    private final UserDAO userDAO;

    public AnalyticsServiceImpl() {
        this.workoutDAO = new WorkoutDAOImpl();
        this.goalDAO = new GoalDAOImpl();
        this.challengeDAO = new ChallengeDAOImpl();
        this.participantDAO = new ChallengeParticipantDAOImpl();
        this.contentDAO = new FitnessContentDAOImpl();
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public Map<String, Object> getUserDashboardSummary(Integer userId) {
        Map<String, Object> summary = new HashMap<>();

        int totalCalories = workoutDAO.getTotalCaloriesBurnedByUserId(userId);
        int totalDurationMinutes = workoutDAO.getTotalDurationMinutesByUserId(userId);
        int totalWorkouts = workoutDAO.countWorkoutsByUserId(userId);

        int activeGoals = goalDAO.countActiveGoalsByUserId(userId);
        int completedGoals = goalDAO.countCompletedGoalsByUserId(userId);
        int totalGoals = activeGoals + completedGoals;
        int goalCompletionPct = (totalGoals > 0) ? (int) Math.round(((double) completedGoals / totalGoals) * 100.0) : 0;

        // Duration formatted: Xh Ym
        int hours = totalDurationMinutes / 60;
        int mins = totalDurationMinutes % 60;
        String durationFormatted = (hours > 0 ? hours + "h " : "") + mins + "m";

        // Weekly & Monthly workout duration charts
        Map<String, Integer> weeklyDuration = workoutDAO.getWeeklyWorkoutDuration(userId);
        Map<String, Integer> monthlyDuration = workoutDAO.getMonthlyWorkoutDuration(userId);
        Map<String, Integer> weeklyCalories = workoutDAO.getWeeklyCaloriesBurned(userId);
        Map<String, Integer> workoutTypes = workoutDAO.getWorkoutTypeDistribution(userId);

        // Lists for UI sections
        List<Workout> recentWorkouts = workoutDAO.findRecentByUserId(userId, 5);
        List<Goal> activeGoalsList = goalDAO.findActiveGoalsByUserId(userId);
        List<Challenge> userChallenges = challengeDAO.findChallengesWithUserStatus(userId);
        List<Challenge> joinedChallenges = new ArrayList<>();
        for (Challenge c : userChallenges) {
            if (c.isUserJoined()) joinedChallenges.add(c);
        }

        // Summary metrics
        summary.put("totalCalories", totalCalories);
        summary.put("totalDurationMinutes", totalDurationMinutes);
        summary.put("durationFormatted", durationFormatted);
        summary.put("totalWorkouts", totalWorkouts);
        summary.put("goalCompletionPercentage", goalCompletionPct);
        summary.put("activeGoalsCount", activeGoals);
        summary.put("completedGoalsCount", completedGoals);

        // Charts
        summary.put("weeklyDurationMap", weeklyDuration);
        summary.put("monthlyDurationMap", monthlyDuration);
        summary.put("weeklyCaloriesMap", weeklyCalories);
        summary.put("workoutTypeMap", workoutTypes);

        // Entities
        summary.put("recentWorkouts", recentWorkouts);
        summary.put("activeGoals", activeGoalsList);
        summary.put("joinedChallenges", joinedChallenges);

        // Curated recommendations
        List<Map<String, String>> recommendations = new ArrayList<>();
        recommendations.add(Map.of("title", "Beginner Full Body Workout", "category", "Strength", "duration", "45 min", "difficulty", "Easy", "calories", "320 kcal", "icon", "fa-dumbbell"));
        recommendations.add(Map.of("title", "30-Minute Outdoor Running", "category", "Cardio", "duration", "30 min", "difficulty", "Medium", "calories", "350 kcal", "icon", "fa-person-running"));
        recommendations.add(Map.of("title", "Upper Body Hypertrophy", "category", "Strength", "duration", "55 min", "difficulty", "Hard", "calories", "440 kcal", "icon", "fa-weight-hanging"));
        recommendations.add(Map.of("title", "Core Strength & Stability", "category", "Conditioning", "duration", "25 min", "difficulty", "Medium", "calories", "180 kcal", "icon", "fa-fire"));
        recommendations.add(Map.of("title", "Evening Vinyasa Yoga Flow", "category", "Recovery", "duration", "35 min", "difficulty", "Easy", "calories", "140 kcal", "icon", "fa-spa"));
        summary.put("recommendations", recommendations);

        return summary;
    }

    @Override
    public Map<String, Object> getUserProgressAnalytics(Integer userId) {
        Map<String, Object> analytics = new HashMap<>();

        analytics.put("totalCalories", workoutDAO.getTotalCaloriesBurnedByUserId(userId));
        analytics.put("totalDurationMinutes", workoutDAO.getTotalDurationMinutesByUserId(userId));
        analytics.put("totalWorkouts", workoutDAO.countWorkoutsByUserId(userId));
        analytics.put("completedGoals", goalDAO.countCompletedGoalsByUserId(userId));
        analytics.put("completedChallenges", participantDAO.countCompletedChallengesByUserId(userId));

        analytics.put("weeklyDurationMap", workoutDAO.getWeeklyWorkoutDuration(userId));
        analytics.put("monthlyDurationMap", workoutDAO.getMonthlyWorkoutDuration(userId));
        analytics.put("weeklyCaloriesMap", workoutDAO.getWeeklyCaloriesBurned(userId));
        analytics.put("workoutTypeMap", workoutDAO.getWorkoutTypeDistribution(userId));

        analytics.put("goals", goalDAO.findByUserId(userId));
        analytics.put("participations", participantDAO.findByUserId(userId));

        return analytics;
    }

    @Override
    public Map<String, Object> getAdminDashboardSummary() {
        Map<String, Object> summary = new HashMap<>();

        summary.put("totalUsers", userDAO.countTotalUsers());
        summary.put("activeUsers", userDAO.countActiveUsers());
        summary.put("totalWorkouts", workoutDAO.countTotalWorkouts());
        summary.put("activeChallenges", challengeDAO.countActiveChallenges());
        summary.put("pendingContentCount", contentDAO.countPendingContent());

        summary.put("monthlyRegistrations", userDAO.getRegistrationStatsByMonth());
        summary.put("workoutActivityStats", workoutDAO.getOverallWorkoutActivityStats());
        summary.put("pendingContent", contentDAO.findPendingContent());

        return summary;
    }
}
