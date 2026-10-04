package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.NutritionDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.NutritionProfile;
import com.fitnesstracker.model.NutritionTarget;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class NutritionDAOImpl implements NutritionDAO {

    private NutritionProfile mapProfileRow(ResultSet rs) throws SQLException {
        NutritionProfile p = new NutritionProfile();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getInt("user_id"));
        p.setAge(rs.getInt("age"));
        p.setSex(rs.getString("sex"));
        p.setHeightCm(rs.getDouble("height_cm"));
        p.setWeightKg(rs.getDouble("weight_kg"));
        p.setActivityLevel(rs.getString("activity_level"));
        p.setFitnessGoal(rs.getString("fitness_goal"));
        p.setDietPreference(rs.getString("diet_preference"));
        p.setFoodExclusions(rs.getString("food_exclusions"));
        p.setMealsPerDay(rs.getInt("meals_per_day"));
        p.setBmr(rs.getDouble("bmr"));
        p.setTdee(rs.getDouble("tdee"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }

    private NutritionTarget mapTargetRow(ResultSet rs) throws SQLException {
        NutritionTarget t = new NutritionTarget();
        t.setId(rs.getInt("id"));
        t.setUserId(rs.getInt("user_id"));
        t.setProfileId(rs.getInt("profile_id"));
        t.setTargetCalories(rs.getInt("target_calories"));
        t.setTargetProteinG(rs.getInt("target_protein_g"));
        t.setTargetCarbsG(rs.getInt("target_carbs_g"));
        t.setTargetFatG(rs.getInt("target_fat_g"));
        t.setProteinPct(rs.getInt("protein_pct"));
        t.setCarbsPct(rs.getInt("carbs_pct"));
        t.setFatPct(rs.getInt("fat_pct"));
        t.setWaterTargetL(rs.getDouble("water_target_l"));
        t.setCalculatedAt(rs.getTimestamp("calculated_at"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        return t;
    }

    @Override
    public NutritionProfile saveProfile(NutritionProfile profile) {
        String sql = "INSERT INTO nutrition_profiles (user_id, age, sex, height_cm, weight_kg, activity_level, " +
                     "fitness_goal, diet_preference, food_exclusions, meals_per_day, bmr, tdee) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE age=VALUES(age), sex=VALUES(sex), height_cm=VALUES(height_cm), " +
                     "weight_kg=VALUES(weight_kg), activity_level=VALUES(activity_level), fitness_goal=VALUES(fitness_goal), " +
                     "diet_preference=VALUES(diet_preference), food_exclusions=VALUES(food_exclusions), " +
                     "meals_per_day=VALUES(meals_per_day), bmr=VALUES(bmr), tdee=VALUES(tdee), updated_at=CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, profile.getUserId());
            ps.setInt(2, profile.getAge());
            ps.setString(3, profile.getSex());
            ps.setDouble(4, profile.getHeightCm());
            ps.setDouble(5, profile.getWeightKg());
            ps.setString(6, profile.getActivityLevel());
            ps.setString(7, profile.getFitnessGoal());
            ps.setString(8, profile.getDietPreference());
            ps.setString(9, profile.getFoodExclusions());
            ps.setInt(10, profile.getMealsPerDay());
            ps.setDouble(11, profile.getBmr());
            ps.setDouble(12, profile.getTdee());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    profile.setId(rs.getInt(1));
                } else {
                    // Profile was updated, fetch existing id
                    Optional<NutritionProfile> existing = findProfileByUserId(profile.getUserId());
                    existing.ifPresent(p -> profile.setId(p.getId()));
                }
            }
            return profile;
        } catch (SQLException e) {
            throw new DatabaseException("Error saving nutrition profile", e);
        }
    }

    @Override
    public boolean updateProfile(NutritionProfile profile) {
        String sql = "UPDATE nutrition_profiles SET age = ?, sex = ?, height_cm = ?, weight_kg = ?, " +
                     "activity_level = ?, fitness_goal = ?, diet_preference = ?, food_exclusions = ?, " +
                     "meals_per_day = ?, bmr = ?, tdee = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, profile.getAge());
            ps.setString(2, profile.getSex());
            ps.setDouble(3, profile.getHeightCm());
            ps.setDouble(4, profile.getWeightKg());
            ps.setString(5, profile.getActivityLevel());
            ps.setString(6, profile.getFitnessGoal());
            ps.setString(7, profile.getDietPreference());
            ps.setString(8, profile.getFoodExclusions());
            ps.setInt(9, profile.getMealsPerDay());
            ps.setDouble(10, profile.getBmr());
            ps.setDouble(11, profile.getTdee());
            ps.setInt(12, profile.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating nutrition profile for user ID: " + profile.getUserId(), e);
        }
    }

    @Override
    public Optional<NutritionProfile> findProfileByUserId(int userId) {
        String sql = "SELECT * FROM nutrition_profiles WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapProfileRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching nutrition profile for user: " + userId, e);
        }
        return Optional.empty();
    }

    @Override
    public NutritionTarget saveTarget(NutritionTarget target) {
        String sql = "INSERT INTO nutrition_targets (user_id, profile_id, target_calories, target_protein_g, " +
                     "target_carbs_g, target_fat_g, protein_pct, carbs_pct, fat_pct, water_target_l, calculated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, target.getUserId());
            ps.setInt(2, target.getProfileId());
            ps.setInt(3, target.getTargetCalories());
            ps.setInt(4, target.getTargetProteinG());
            ps.setInt(5, target.getTargetCarbsG());
            ps.setInt(6, target.getTargetFatG());
            ps.setInt(7, target.getProteinPct());
            ps.setInt(8, target.getCarbsPct());
            ps.setInt(9, target.getFatPct());
            ps.setDouble(10, target.getWaterTargetL());
            ps.setTimestamp(11, target.getCalculatedAt() != null ? target.getCalculatedAt() : new Timestamp(System.currentTimeMillis()));

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) target.setId(rs.getInt(1));
                }
            }
            return target;
        } catch (SQLException e) {
            throw new DatabaseException("Error saving nutrition target", e);
        }
    }

    @Override
    public boolean updateTarget(NutritionTarget target) {
        String sql = "UPDATE nutrition_targets SET profile_id = ?, target_calories = ?, target_protein_g = ?, " +
                     "target_carbs_g = ?, target_fat_g = ?, protein_pct = ?, carbs_pct = ?, fat_pct = ?, " +
                     "water_target_l = ?, calculated_at = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, target.getProfileId());
            ps.setInt(2, target.getTargetCalories());
            ps.setInt(3, target.getTargetProteinG());
            ps.setInt(4, target.getTargetCarbsG());
            ps.setInt(5, target.getTargetFatG());
            ps.setInt(6, target.getProteinPct());
            ps.setInt(7, target.getCarbsPct());
            ps.setInt(8, target.getFatPct());
            ps.setDouble(9, target.getWaterTargetL());
            ps.setTimestamp(10, target.getCalculatedAt());
            ps.setInt(11, target.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating nutrition target", e);
        }
    }

    @Override
    public Optional<NutritionTarget> findTargetByUserId(int userId) {
        String sql = "SELECT * FROM nutrition_targets WHERE user_id = ? ORDER BY calculated_at DESC, id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapTargetRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching nutrition target for user: " + userId, e);
        }
        return Optional.empty();
    }

    @Override
    public Map<String, Object> getAggregatedStatistics() {
        Map<String, Object> stats = new HashMap<>();
        String sqlSummary = "SELECT COUNT(*) AS total_profiles, " +
                            "AVG(weight_kg) AS avg_weight, " +
                            "AVG(weight_kg / ((height_cm/100) * (height_cm/100))) AS avg_bmi, " +
                            "AVG(tdee) AS avg_tdee FROM nutrition_profiles";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlSummary);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("totalProfiles", rs.getInt("total_profiles"));
                stats.put("avgWeight", Math.round(rs.getDouble("avg_weight") * 10.0) / 10.0);
                stats.put("avgBmi", Math.round(rs.getDouble("avg_bmi") * 10.0) / 10.0);
                stats.put("avgTdee", Math.round(rs.getDouble("avg_tdee")));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching nutrition statistics summary", e);
        }

        // Goal breakdown
        Map<String, Integer> goalMap = new HashMap<>();
        String sqlGoals = "SELECT fitness_goal, COUNT(*) AS cnt FROM nutrition_profiles GROUP BY fitness_goal";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlGoals);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                goalMap.put(rs.getString("fitness_goal"), rs.getInt("cnt"));
            }
            stats.put("goalsBreakdown", goalMap);
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching goals breakdown", e);
        }

        // Diet breakdown
        Map<String, Integer> dietMap = new HashMap<>();
        String sqlDiets = "SELECT diet_preference, COUNT(*) AS cnt FROM nutrition_profiles GROUP BY diet_preference";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlDiets);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                dietMap.put(rs.getString("diet_preference"), rs.getInt("cnt"));
            }
            stats.put("dietsBreakdown", dietMap);
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching diet breakdown", e);
        }

        return stats;
    }
}
