package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.GoalDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.Goal;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class GoalDAOImpl implements GoalDAO {

    private Goal mapRow(ResultSet rs) throws SQLException {
        Goal g = new Goal();
        g.setId(rs.getInt("id"));
        g.setUserId(rs.getInt("user_id"));
        g.setTitle(rs.getString("title"));
        g.setDescription(rs.getString("description"));
        g.setTargetValue(rs.getBigDecimal("target_value"));
        g.setCurrentValue(rs.getBigDecimal("current_value"));
        g.setUnit(rs.getString("unit"));
        g.setDeadline(rs.getDate("deadline"));
        g.setStatus(rs.getString("status"));
        g.setCreatedAt(rs.getTimestamp("created_at"));
        g.setUpdatedAt(rs.getTimestamp("updated_at"));
        return g;
    }

    @Override
    public Goal save(Goal goal) {
        String sql = "INSERT INTO goals (user_id, title, description, target_value, current_value, unit, deadline, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, goal.getUserId());
            ps.setString(2, goal.getTitle());
            ps.setString(3, goal.getDescription());
            ps.setBigDecimal(4, goal.getTargetValue());
            ps.setBigDecimal(5, goal.getCurrentValue() != null ? goal.getCurrentValue() : BigDecimal.ZERO);
            ps.setString(6, goal.getUnit());
            ps.setDate(7, goal.getDeadline());
            ps.setString(8, goal.getStatus() != null ? goal.getStatus() : "IN_PROGRESS");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) goal.setId(rs.getInt(1));
                }
            }
            return goal;
        } catch (SQLException e) {
            throw new DatabaseException("Error creating goal", e);
        }
    }

    @Override
    public boolean update(Goal goal) {
        String sql = "UPDATE goals SET title = ?, description = ?, target_value = ?, current_value = ?, unit = ?, " +
                     "deadline = ?, status = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, goal.getTitle());
            ps.setString(2, goal.getDescription());
            ps.setBigDecimal(3, goal.getTargetValue());
            ps.setBigDecimal(4, goal.getCurrentValue());
            ps.setString(5, goal.getUnit());
            ps.setDate(6, goal.getDeadline());
            ps.setString(7, goal.getStatus());
            ps.setInt(8, goal.getId());
            ps.setInt(9, goal.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating goal ID: " + goal.getId(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM goals WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error deleting goal ID: " + id, e);
        }
    }

    @Override
    public Optional<Goal> findById(Integer id) {
        String sql = "SELECT * FROM goals WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding goal by ID: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Goal> findAll() {
        List<Goal> list = new ArrayList<>();
        String sql = "SELECT * FROM goals ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error finding all goals", e);
        }
        return list;
    }

    @Override
    public List<Goal> findByUserId(Integer userId) {
        List<Goal> list = new ArrayList<>();
        String sql = "SELECT * FROM goals WHERE user_id = ? ORDER BY deadline ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding goals for user ID: " + userId, e);
        }
        return list;
    }

    @Override
    public List<Goal> findActiveGoalsByUserId(Integer userId) {
        List<Goal> list = new ArrayList<>();
        String sql = "SELECT * FROM goals WHERE user_id = ? AND status = 'IN_PROGRESS' ORDER BY deadline ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding active goals for user: " + userId, e);
        }
        return list;
    }

    @Override
    public boolean updateProgress(Integer goalId, BigDecimal newCurrentValue) {
        String sql = "UPDATE goals SET current_value = ?, " +
                     "status = CASE WHEN current_value >= target_value THEN 'COMPLETED' ELSE status END " +
                     "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, newCurrentValue);
            ps.setInt(2, goalId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating goal progress for ID: " + goalId, e);
        }
    }

    @Override
    public boolean completeGoal(Integer goalId) {
        String sql = "UPDATE goals SET status = 'COMPLETED', current_value = target_value WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, goalId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error completing goal ID: " + goalId, e);
        }
    }

    @Override
    public int countCompletedGoalsByUserId(Integer userId) {
        String sql = "SELECT COUNT(*) FROM goals WHERE user_id = ? AND status = 'COMPLETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting completed goals", e);
        }
        return 0;
    }

    @Override
    public int countActiveGoalsByUserId(Integer userId) {
        String sql = "SELECT COUNT(*) FROM goals WHERE user_id = ? AND status = 'IN_PROGRESS'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting active goals", e);
        }
        return 0;
    }
}
