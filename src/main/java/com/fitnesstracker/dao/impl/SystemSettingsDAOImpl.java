package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.SystemSettingsDAO;
import com.fitnesstracker.exception.DatabaseException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

public class SystemSettingsDAOImpl implements SystemSettingsDAO {

    @Override
    public Map<String, String> getAllSettings() {
        Map<String, String> settings = new LinkedHashMap<>();
        String sql = "SELECT setting_key, setting_value FROM system_settings";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                settings.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving system settings", e);
        }
        return settings;
    }

    @Override
    public Optional<String> getSettingValue(String key) {
        String sql = "SELECT setting_value FROM system_settings WHERE setting_key = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving setting key: " + key, e);
        }
        return Optional.empty();
    }

    @Override
    public boolean updateSetting(String key, String value) {
        String sql = "INSERT INTO system_settings (setting_key, setting_value) VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE setting_value = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            ps.setString(3, value);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating setting key: " + key, e);
        }
    }

    @Override
    public boolean updateSettings(Map<String, String> settings) {
        if (settings == null || settings.isEmpty()) return true;
        String sql = "INSERT INTO system_settings (setting_key, setting_value) VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE setting_value = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Map.Entry<String, String> entry : settings.entrySet()) {
                ps.setString(1, entry.getKey());
                ps.setString(2, entry.getValue());
                ps.setString(3, entry.getValue());
                ps.addBatch();
            }
            ps.executeBatch();
            return true;
        } catch (SQLException e) {
            throw new DatabaseException("Error batch updating settings", e);
        }
    }
}
