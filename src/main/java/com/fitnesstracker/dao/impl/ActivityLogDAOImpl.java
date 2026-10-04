package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.ActivityLogDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.ActivityLog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAOImpl implements ActivityLogDAO {

    private ActivityLog mapRow(ResultSet rs) throws SQLException {
        ActivityLog log = new ActivityLog();
        log.setId(rs.getInt("id"));
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) log.setUserId(userId);
        log.setAction(rs.getString("action"));
        log.setDetails(rs.getString("details"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setCreatedAt(rs.getTimestamp("created_at"));

        try {
            log.setUserName(rs.getString("user_name"));
            log.setUserEmail(rs.getString("user_email"));
        } catch (SQLException ignored) {
        }
        return log;
    }

    @Override
    public boolean log(Integer userId, String action, String details, String ipAddress) {
        String sql = "INSERT INTO activity_logs (user_id, action, details, ip_address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId != null && userId > 0) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, action);
            ps.setString(3, details);
            ps.setString(4, ipAddress);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Log silently or throw database exception without crashing calling threads
            System.err.println("Failed to write activity log: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<ActivityLog> findRecentLogs(int limit) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT al.*, u.name AS user_name, u.email AS user_email " +
                     "FROM activity_logs al " +
                     "LEFT JOIN users u ON u.id = al.user_id " +
                     "ORDER BY al.created_at DESC " +
                     "LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving recent activity logs", e);
        }
        return list;
    }

    @Override
    public List<ActivityLog> findLogsByUserId(Integer userId, int limit) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT al.*, u.name AS user_name, u.email AS user_email " +
                     "FROM activity_logs al " +
                     "LEFT JOIN users u ON u.id = al.user_id " +
                     "WHERE al.user_id = ? " +
                     "ORDER BY al.created_at DESC " +
                     "LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving activity logs for user ID: " + userId, e);
        }
        return list;
    }
}
