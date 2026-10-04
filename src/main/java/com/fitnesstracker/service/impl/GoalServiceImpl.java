package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.GoalDAO;
import com.fitnesstracker.dao.impl.GoalDAOImpl;
import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.Goal;
import com.fitnesstracker.service.GoalService;
import com.fitnesstracker.util.ValidationUtil;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Optional;

public class GoalServiceImpl implements GoalService {

    private final GoalDAO goalDAO;

    public GoalServiceImpl() {
        this.goalDAO = new GoalDAOImpl();
    }

    public GoalServiceImpl(GoalDAO goalDAO) {
        this.goalDAO = goalDAO;
    }

    @Override
    public Goal createGoal(Integer userId, String title, String description, BigDecimal targetValue, BigDecimal currentValue, String unit, Date deadline) {
        if (!ValidationUtil.isNotEmpty(title)) {
            throw new AppException("Goal title is required.");
        }
        if (targetValue == null || targetValue.compareTo(BigDecimal.ZERO) <= 0) {
            throw new AppException("Target value must be greater than zero.");
        }
        if (deadline == null) {
            throw new AppException("Deadline date is required.");
        }

        Goal goal = new Goal();
        goal.setUserId(userId);
        goal.setTitle(title.trim());
        goal.setDescription(description);
        goal.setTargetValue(targetValue);
        goal.setCurrentValue(currentValue != null ? currentValue : BigDecimal.ZERO);
        goal.setUnit(ValidationUtil.isNotEmpty(unit) ? unit.trim() : "km");
        goal.setDeadline(deadline);
        goal.setStatus(goal.getCurrentValue().compareTo(targetValue) >= 0 ? "COMPLETED" : "IN_PROGRESS");

        return goalDAO.save(goal);
    }

    @Override
    public boolean updateGoal(Integer goalId, Integer userId, String title, String description, BigDecimal targetValue, BigDecimal currentValue, String unit, Date deadline, String status) {
        Optional<Goal> opt = goalDAO.findById(goalId);
        if (opt.isEmpty() || !opt.get().getUserId().equals(userId)) {
            throw new AppException("Goal not found or permission denied.");
        }

        Goal goal = opt.get();
        if (ValidationUtil.isNotEmpty(title)) goal.setTitle(title.trim());
        goal.setDescription(description);
        if (targetValue != null && targetValue.compareTo(BigDecimal.ZERO) > 0) goal.setTargetValue(targetValue);
        if (currentValue != null) goal.setCurrentValue(currentValue);
        if (ValidationUtil.isNotEmpty(unit)) goal.setUnit(unit.trim());
        if (deadline != null) goal.setDeadline(deadline);
        if (ValidationUtil.isNotEmpty(status)) goal.setStatus(status);

        if (goal.getCurrentValue().compareTo(goal.getTargetValue()) >= 0) {
            goal.setStatus("COMPLETED");
        }

        return goalDAO.update(goal);
    }

    @Override
    public boolean updateProgress(Integer goalId, Integer userId, BigDecimal newCurrentValue) {
        Optional<Goal> opt = goalDAO.findById(goalId);
        if (opt.isEmpty() || !opt.get().getUserId().equals(userId)) {
            throw new AppException("Goal not found or access unauthorized.");
        }
        return goalDAO.updateProgress(goalId, newCurrentValue);
    }

    @Override
    public boolean completeGoal(Integer goalId, Integer userId) {
        Optional<Goal> opt = goalDAO.findById(goalId);
        if (opt.isEmpty() || !opt.get().getUserId().equals(userId)) {
            throw new AppException("Goal not found or access unauthorized.");
        }
        return goalDAO.completeGoal(goalId);
    }

    @Override
    public boolean deleteGoal(Integer goalId, Integer userId) {
        Optional<Goal> opt = goalDAO.findById(goalId);
        if (opt.isEmpty() || !opt.get().getUserId().equals(userId)) {
            throw new AppException("Goal not found or access unauthorized.");
        }
        return goalDAO.delete(goalId);
    }

    @Override
    public Optional<Goal> getGoalById(Integer goalId) {
        return goalDAO.findById(goalId);
    }

    @Override
    public List<Goal> getUserGoals(Integer userId) {
        return goalDAO.findByUserId(userId);
    }

    @Override
    public List<Goal> getActiveUserGoals(Integer userId) {
        return goalDAO.findActiveGoalsByUserId(userId);
    }

    @Override
    public int getCompletedGoalsCount(Integer userId) {
        return goalDAO.countCompletedGoalsByUserId(userId);
    }

    @Override
    public int getActiveGoalsCount(Integer userId) {
        return goalDAO.countActiveGoalsByUserId(userId);
    }

    @Override
    public int calculateOverallGoalCompletionPercentage(Integer userId) {
        List<Goal> goals = goalDAO.findByUserId(userId);
        if (goals.isEmpty()) return 0;
        int totalPct = 0;
        for (Goal g : goals) {
            totalPct += g.getProgressPercentage();
        }
        return totalPct / goals.size();
    }
}
