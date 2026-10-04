package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.MealPlanDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.MealPlan;
import com.fitnesstracker.model.MealPlanItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class MealPlanDAOImpl implements MealPlanDAO {

    private MealPlan mapPlanRow(ResultSet rs) throws SQLException {
        MealPlan p = new MealPlan();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getInt("user_id"));
        p.setProfileId(rs.getInt("profile_id"));
        p.setPlanName(rs.getString("plan_name"));
        p.setTotalCalories(rs.getInt("total_calories"));
        p.setTotalProteinG(rs.getInt("total_protein_g"));
        p.setTotalCarbsG(rs.getInt("total_carbs_g"));
        p.setTotalFatG(rs.getInt("total_fat_g"));
        p.setActive(rs.getBoolean("is_active"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }

    private MealPlanItem mapItemRow(ResultSet rs) throws SQLException {
        MealPlanItem item = new MealPlanItem();
        item.setId(rs.getInt("id"));
        item.setMealPlanId(rs.getInt("meal_plan_id"));
        item.setMealNumber(rs.getInt("meal_number"));
        item.setMealName(rs.getString("meal_name"));
        item.setFoodItems(rs.getString("food_items"));
        item.setCalories(rs.getInt("calories"));
        item.setProteinG(rs.getInt("protein_g"));
        item.setCarbsG(rs.getInt("carbs_g"));
        item.setFatG(rs.getInt("fat_g"));
        item.setNotes(rs.getString("notes"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        return item;
    }

    @Override
    public MealPlan save(MealPlan plan) {
        String sqlPlan = "INSERT INTO meal_plans (user_id, profile_id, plan_name, total_calories, daily_calories, " +
                         "total_protein_g, total_carbs_g, total_fat_g, is_active, plan_date) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_DATE)";
        String sqlItem = "INSERT INTO meal_plan_items (meal_plan_id, meal_number, meal_type, meal_name, food_items, " +
                         "calories, protein_g, protein_grams, carbs_g, carbs_grams, fat_g, fat_grams, notes) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Deactivate previous active plans for this user if this plan is active
            if (plan.isActive()) {
                String deactSql = "UPDATE meal_plans SET is_active = FALSE WHERE user_id = ?";
                try (PreparedStatement deactPs = conn.prepareStatement(deactSql)) {
                    deactPs.setInt(1, plan.getUserId());
                    deactPs.executeUpdate();
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlPlan, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, plan.getUserId());
                ps.setInt(2, plan.getProfileId());
                ps.setString(3, plan.getPlanName());
                ps.setInt(4, plan.getTotalCalories());
                ps.setInt(5, plan.getTotalCalories());
                ps.setInt(6, plan.getTotalProteinG());
                ps.setInt(7, plan.getTotalCarbsG());
                ps.setInt(8, plan.getTotalFatG());
                ps.setBoolean(9, plan.isActive());

                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        plan.setId(rs.getInt(1));
                    }
                }
            }

            if (plan.getItems() != null && !plan.getItems().isEmpty()) {
                try (PreparedStatement psItem = conn.prepareStatement(sqlItem, Statement.RETURN_GENERATED_KEYS)) {
                    for (MealPlanItem item : plan.getItems()) {
                        item.setMealPlanId(plan.getId());
                        psItem.setInt(1, item.getMealPlanId());
                        psItem.setInt(2, item.getMealNumber());
                        psItem.setString(3, item.getMealName().toUpperCase().replace(" ", "_"));
                        psItem.setString(4, item.getMealName());
                        psItem.setString(5, item.getFoodItems());
                        psItem.setInt(6, item.getCalories());
                        psItem.setInt(7, item.getProteinG());
                        psItem.setInt(8, item.getProteinG());
                        psItem.setInt(9, item.getCarbsG());
                        psItem.setInt(10, item.getCarbsG());
                        psItem.setInt(11, item.getFatG());
                        psItem.setInt(12, item.getFatG());
                        psItem.setString(13, item.getNotes());
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }
            }

            conn.commit();
            return plan;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            throw new DatabaseException("Error saving meal plan: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {}
            }
        }
    }

    @Override
    public Optional<MealPlan> findActiveByUserId(int userId) {
        String sql = "SELECT * FROM meal_plans WHERE user_id = ? AND is_active = TRUE ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MealPlan plan = mapPlanRow(rs);
                    plan.setItems(findItemsByPlanId(plan.getId()));
                    return Optional.of(plan);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching active meal plan for user: " + userId, e);
        }
        return Optional.empty();
    }

    @Override
    public List<MealPlan> findHistoryByUserId(int userId) {
        List<MealPlan> list = new ArrayList<>();
        String sql = "SELECT * FROM meal_plans WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MealPlan plan = mapPlanRow(rs);
                    plan.setItems(findItemsByPlanId(plan.getId()));
                    list.add(plan);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching meal plan history for user: " + userId, e);
        }
        return list;
    }

    @Override
    public boolean deactivateAllByUserId(int userId) {
        String sql = "UPDATE meal_plans SET is_active = FALSE WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error deactivating meal plans for user: " + userId, e);
        }
    }

    @Override
    public List<MealPlanItem> findItemsByPlanId(int planId) {
        List<MealPlanItem> list = new ArrayList<>();
        String sql = "SELECT * FROM meal_plan_items WHERE meal_plan_id = ? ORDER BY meal_number ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, planId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItemRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching meal plan items for plan: " + planId, e);
        }
        return list;
    }
}
