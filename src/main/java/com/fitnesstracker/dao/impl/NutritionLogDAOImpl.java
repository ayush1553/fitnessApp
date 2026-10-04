package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.NutritionLogDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.NutritionLog;

import java.sql.*;
import java.util.*;
import java.sql.Date;

public class NutritionLogDAOImpl implements NutritionLogDAO {

    private NutritionLog mapRow(ResultSet rs) throws SQLException {
        NutritionLog log = new NutritionLog();
        log.setId(rs.getInt("id"));
        log.setUserId(rs.getInt("user_id"));
        log.setLogDate(rs.getDate("log_date"));
        log.setMealType(rs.getString("meal_type"));
        log.setFoodName(rs.getString("food_name"));
        log.setPortionSize(rs.getString("portion_size"));
        log.setCalories(rs.getInt("calories"));
        log.setProteinG(rs.getInt("protein_g"));
        log.setCarbsG(rs.getInt("carbs_g"));
        log.setFatG(rs.getInt("fat_g"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        return log;
    }

    @Override
    public NutritionLog save(NutritionLog entity) {
        String sql = "INSERT INTO nutrition_logs (user_id, log_date, meal_type, food_name, portion_size, calories, protein_g, protein_grams, carbs_g, carbs_grams, fat_g, fat_grams) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, entity.getUserId());
            ps.setDate(2, entity.getLogDate());
            ps.setString(3, entity.getMealType());
            ps.setString(4, entity.getFoodName());
            ps.setString(5, entity.getPortionSize());
            ps.setInt(6, entity.getCalories());
            ps.setInt(7, entity.getProteinG());
            ps.setInt(8, entity.getProteinG());
            ps.setInt(9, entity.getCarbsG());
            ps.setInt(10, entity.getCarbsG());
            ps.setInt(11, entity.getFatG());
            ps.setInt(12, entity.getFatG());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) entity.setId(rs.getInt(1));
                }
            }
            return entity;
        } catch (SQLException e) {
            throw new DatabaseException("Error creating nutrition log: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean update(NutritionLog entity) {
        String sql = "UPDATE nutrition_logs SET log_date = ?, meal_type = ?, food_name = ?, portion_size = ?, " +
                     "calories = ?, protein_g = ?, carbs_g = ?, fat_g = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, entity.getLogDate());
            ps.setString(2, entity.getMealType());
            ps.setString(3, entity.getFoodName());
            ps.setString(4, entity.getPortionSize());
            ps.setInt(5, entity.getCalories());
            ps.setInt(6, entity.getProteinG());
            ps.setInt(7, entity.getCarbsG());
            ps.setInt(8, entity.getFatG());
            ps.setInt(9, entity.getId());
            ps.setInt(10, entity.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating nutrition log ID: " + entity.getId(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM nutrition_logs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error deleting nutrition log ID: " + id, e);
        }
    }

    @Override
    public Optional<NutritionLog> findById(Integer id) {
        String sql = "SELECT * FROM nutrition_logs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding nutrition log ID: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<NutritionLog> findAll() {
        List<NutritionLog> list = new ArrayList<>();
        String sql = "SELECT * FROM nutrition_logs ORDER BY log_date DESC, created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error finding all nutrition logs", e);
        }
        return list;
    }

    @Override
    public List<NutritionLog> findByUserIdAndDate(int userId, Date date) {
        List<NutritionLog> list = new ArrayList<>();
        String sql = "SELECT * FROM nutrition_logs WHERE user_id = ? AND log_date = ? ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching nutrition logs for user " + userId + " on " + date, e);
        }
        return list;
    }

    @Override
    public List<NutritionLog> findByUserIdAndDateRange(int userId, Date startDate, Date endDate) {
        List<NutritionLog> list = new ArrayList<>();
        String sql = "SELECT * FROM nutrition_logs WHERE user_id = ? AND log_date BETWEEN ? AND ? ORDER BY log_date DESC, id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, startDate);
            ps.setDate(3, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching nutrition logs for date range", e);
        }
        return list;
    }

    @Override
    public Map<String, Integer> getDailyTotalMacros(int userId, Date date) {
        Map<String, Integer> totals = new HashMap<>();
        totals.put("calories", 0);
        totals.put("protein", 0);
        totals.put("carbs", 0);
        totals.put("fat", 0);

        String sql = "SELECT SUM(calories) as total_cal, SUM(protein_g) as total_pro, " +
                     "SUM(carbs_g) as total_carb, SUM(fat_g) as total_fat " +
                     "FROM nutrition_logs WHERE user_id = ? AND log_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totals.put("calories", rs.getInt("total_cal"));
                    totals.put("protein", rs.getInt("total_pro"));
                    totals.put("carbs", rs.getInt("total_carb"));
                    totals.put("fat", rs.getInt("total_fat"));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error calculating daily nutrition totals", e);
        }
        return totals;
    }

    @Override
    public List<Map<String, Object>> getDailyNutritionSummaryList(int userId, int days) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT log_date, SUM(calories) as total_cal, SUM(protein_g) as total_pro, " +
                     "SUM(carbs_g) as total_carb, SUM(fat_g) as total_fat " +
                     "FROM nutrition_logs WHERE user_id = ? AND log_date >= DATE_SUB(CURDATE(), INTERVAL ? DAY) " +
                     "GROUP BY log_date ORDER BY log_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> day = new HashMap<>();
                    day.put("logDate", rs.getDate("log_date"));
                    day.put("calories", rs.getInt("total_cal"));
                    day.put("protein", rs.getInt("total_pro"));
                    day.put("carbs", rs.getInt("total_carb"));
                    day.put("fat", rs.getInt("total_fat"));
                    list.add(day);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching nutrition summary list", e);
        }
        return list;
    }
}
