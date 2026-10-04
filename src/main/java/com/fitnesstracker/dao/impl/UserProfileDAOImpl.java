package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.UserProfileDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.UserProfile;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserProfileDAOImpl implements UserProfileDAO {

    private UserProfile mapRow(ResultSet rs) throws SQLException {
        UserProfile profile = new UserProfile();
        profile.setId(rs.getInt("id"));
        profile.setUserId(rs.getInt("user_id"));
        int age = rs.getInt("age");
        if (!rs.wasNull()) profile.setAge(age);
        profile.setHeightCm(rs.getBigDecimal("height_cm"));
        profile.setWeightKg(rs.getBigDecimal("weight_kg"));
        profile.setFitnessGoal(rs.getString("fitness_goal"));
        profile.setActivityLevel(rs.getString("activity_level"));
        profile.setProfileImage(rs.getString("profile_image"));
        profile.setCreatedAt(rs.getTimestamp("created_at"));
        profile.setUpdatedAt(rs.getTimestamp("updated_at"));
        return profile;
    }

    @Override
    public UserProfile save(UserProfile profile) {
        String sql = "INSERT INTO profiles (user_id, age, height_cm, weight_kg, fitness_goal, activity_level, profile_image) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, profile.getUserId());
            if (profile.getAge() != null) ps.setInt(2, profile.getAge()); else ps.setNull(2, Types.INTEGER);
            ps.setBigDecimal(3, profile.getHeightCm());
            ps.setBigDecimal(4, profile.getWeightKg());
            ps.setString(5, profile.getFitnessGoal());
            ps.setString(6, profile.getActivityLevel());
            ps.setString(7, profile.getProfileImage());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) profile.setId(rs.getInt(1));
                }
            }
            return profile;
        } catch (SQLException e) {
            throw new DatabaseException("Error saving user profile for user ID: " + profile.getUserId(), e);
        }
    }

    @Override
    public boolean update(UserProfile profile) {
        String sql = "UPDATE profiles SET age = ?, height_cm = ?, weight_kg = ?, fitness_goal = ?, activity_level = ?, profile_image = ? " +
                     "WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (profile.getAge() != null) ps.setInt(1, profile.getAge()); else ps.setNull(1, Types.INTEGER);
            ps.setBigDecimal(2, profile.getHeightCm());
            ps.setBigDecimal(3, profile.getWeightKg());
            ps.setString(4, profile.getFitnessGoal());
            ps.setString(5, profile.getActivityLevel());
            ps.setString(6, profile.getProfileImage());
            ps.setInt(7, profile.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating user profile for user ID: " + profile.getUserId(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM profiles WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error deleting profile ID: " + id, e);
        }
    }

    @Override
    public Optional<UserProfile> findById(Integer id) {
        String sql = "SELECT * FROM profiles WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding profile by ID: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<UserProfile> findAll() {
        List<UserProfile> list = new ArrayList<>();
        String sql = "SELECT * FROM profiles";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving profiles", e);
        }
        return list;
    }

    @Override
    public Optional<UserProfile> findByUserId(Integer userId) {
        String sql = "SELECT * FROM profiles WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding profile by user ID: " + userId, e);
        }
        return Optional.empty();
    }

    @Override
    public boolean saveOrUpdate(UserProfile profile) {
        Optional<UserProfile> existing = findByUserId(profile.getUserId());
        if (existing.isPresent()) {
            return update(profile);
        } else {
            save(profile);
            return true;
        }
    }
}
