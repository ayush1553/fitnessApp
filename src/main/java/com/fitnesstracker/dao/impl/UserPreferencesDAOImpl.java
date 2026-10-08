package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.UserPreferencesDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.UserPreferences;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * JDBC implementation of UserPreferencesDAO using PreparedStatement and clean connection management.
 */
public class UserPreferencesDAOImpl implements UserPreferencesDAO {

    private static final Logger LOGGER = Logger.getLogger(UserPreferencesDAOImpl.class.getName());

    private UserPreferences mapRow(ResultSet rs) throws SQLException {
        UserPreferences pref = new UserPreferences();
        pref.setId(rs.getInt("id"));
        pref.setUserId(rs.getInt("user_id"));
        pref.setThemeMode(rs.getString("theme_mode"));
        pref.setAccentColor(rs.getString("accent_color"));
        pref.setGlassIntensity(rs.getString("glass_intensity"));
        pref.setAnimationsEnabled(rs.getBoolean("animations_enabled"));
        pref.setCompactMode(rs.getBoolean("compact_mode"));
        pref.setCreatedAt(rs.getTimestamp("created_at"));
        pref.setUpdatedAt(rs.getTimestamp("updated_at"));
        return pref;
    }

    @Override
    public UserPreferences getByUserId(int userId) {
        String sql = "SELECT id, user_id, theme_mode, accent_color, glass_intensity, " +
                     "animations_enabled, compact_mode, created_at, updated_at " +
                     "FROM user_preferences WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving preferences for user ID: " + userId, e);
            throw new DatabaseException("Failed to fetch user preferences", e);
        }
        return null;
    }

    @Override
    public boolean save(UserPreferences preferences) {
        String sql = "INSERT INTO user_preferences (user_id, theme_mode, accent_color, glass_intensity, " +
                     "animations_enabled, compact_mode) " +
                     "VALUES (?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "theme_mode = VALUES(theme_mode), " +
                     "accent_color = VALUES(accent_color), " +
                     "glass_intensity = VALUES(glass_intensity), " +
                     "animations_enabled = VALUES(animations_enabled), " +
                     "compact_mode = VALUES(compact_mode), " +
                     "updated_at = CURRENT_TIMESTAMP";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, preferences.getUserId());
            ps.setString(2, preferences.getThemeMode());
            ps.setString(3, preferences.getAccentColor());
            ps.setString(4, preferences.getGlassIntensity());
            ps.setBoolean(5, preferences.isAnimationsEnabled());
            ps.setBoolean(6, preferences.isCompactMode());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving preferences for user ID: " + preferences.getUserId(), e);
            throw new DatabaseException("Failed to save user preferences", e);
        }
    }

    @Override
    public boolean update(UserPreferences preferences) {
        String sql = "UPDATE user_preferences SET theme_mode = ?, accent_color = ?, " +
                     "glass_intensity = ?, animations_enabled = ?, compact_mode = ?, " +
                     "updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, preferences.getThemeMode());
            ps.setString(2, preferences.getAccentColor());
            ps.setString(3, preferences.getGlassIntensity());
            ps.setBoolean(4, preferences.isAnimationsEnabled());
            ps.setBoolean(5, preferences.isCompactMode());
            ps.setInt(6, preferences.getUserId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating preferences for user ID: " + preferences.getUserId(), e);
            throw new DatabaseException("Failed to update user preferences", e);
        }
    }

    @Override
    public boolean delete(int userId) {
        String sql = "DELETE FROM user_preferences WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting preferences for user ID: " + userId, e);
            throw new DatabaseException("Failed to delete user preferences", e);
        }
    }
}
