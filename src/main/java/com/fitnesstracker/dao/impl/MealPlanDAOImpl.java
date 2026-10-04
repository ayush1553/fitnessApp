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
        try { p.setProfileId(rs.getInt("profile_id")); } catch (Exception ignored) {}
        try { p.setPlanName(rs.getString("plan_name")); } catch (Exception ignored) {}
        try {
            int cal = rs.getInt("total_calories");
            if (cal <= 0) cal = rs.getInt("daily_calories");
            p.setTotalCalories(cal);
        } catch (Exception ignored) {}
        try { p.setTotalProteinG(rs.getInt("total_protein_g")); } catch (Exception ignored) {}
        try { p.setTotalCarbsG(rs.getInt("total_carbs_g")); } catch (Exception ignored) {}
        try { p.setTotalFatG(rs.getInt("total_fat_g")); } catch (Exception ignored) {}
        try { p.setActive(rs.getBoolean("is_active")); } catch (Exception ignored) {}
        try { p.setCreatedAt(rs.getTimestamp("created_at")); } catch (Exception ignored) {}
        return p;
    }

    private MealPlanItem mapItemRow(ResultSet rs) throws SQLException {
        MealPlanItem item = new MealPlanItem();
        item.setId(rs.getInt("id"));
        item.setMealPlanId(rs.getInt("meal_plan_id"));
        try { item.setMealNumber(rs.getInt("meal_number")); } catch (Exception ignored) {}
        try { item.setMealName(rs.getString("meal_name")); } catch (Exception ignored) {}
        try { item.setFoodItems(rs.getString("food_items")); } catch (Exception ignored) {}
        try { item.setCalories(rs.getInt("calories")); } catch (Exception ignored) {}
        try {
            int pro = rs.getInt("protein_g");
            if (pro <= 0) pro = rs.getInt("protein_grams");
            item.setProteinG(pro);
        } catch (Exception ignored) {}
        try {
            int carb = rs.getInt("carbs_g");
            if (carb <= 0) carb = rs.getInt("carbs_grams");
            item.setCarbsG(carb);
        } catch (Exception ignored) {}
        try {
            int fat = rs.getInt("fat_g");
            if (fat <= 0) fat = rs.getInt("fat_grams");
            item.setFatG(fat);
        } catch (Exception ignored) {}
        try { item.setNotes(rs.getString("notes")); } catch (Exception ignored) {}
        try { item.setCreatedAt(rs.getTimestamp("created_at")); } catch (Exception ignored) {}
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
