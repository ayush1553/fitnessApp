package com.fitnesstracker.service;

import com.fitnesstracker.model.Goal;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Optional;

public interface GoalService {

    Goal createGoal(Integer userId, String title, String description, BigDecimal targetValue, BigDecimal currentValue, String unit, Date deadline);

    boolean updateGoal(Integer goalId, Integer userId, String title, String description, BigDecimal targetValue, BigDecimal currentValue, String unit, Date deadline, String status);

    boolean updateProgress(Integer goalId, Integer userId, BigDecimal newCurrentValue);

    boolean completeGoal(Integer goalId, Integer userId);

    boolean deleteGoal(Integer goalId, Integer userId);

    Optional<Goal> getGoalById(Integer goalId);

    List<Goal> getUserGoals(Integer userId);

    List<Goal> getActiveUserGoals(Integer userId);

    int getCompletedGoalsCount(Integer userId);

    int getActiveGoalsCount(Integer userId);

    int calculateOverallGoalCompletionPercentage(Integer userId);
}
