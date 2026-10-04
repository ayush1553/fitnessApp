package com.fitnesstracker.dao;

import com.fitnesstracker.model.Goal;

import java.math.BigDecimal;
import java.util.List;

public interface GoalDAO extends GenericDAO<Goal, Integer> {

    List<Goal> findByUserId(Integer userId);

    List<Goal> findActiveGoalsByUserId(Integer userId);

    boolean updateProgress(Integer goalId, BigDecimal newCurrentValue);

    boolean completeGoal(Integer goalId);

    int countCompletedGoalsByUserId(Integer userId);

    int countActiveGoalsByUserId(Integer userId);
}
