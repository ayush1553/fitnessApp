package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.WaterLogDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.WaterLog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.sql.Date;

public class WaterLogDAOImpl implements WaterLogDAO {

    private WaterLog mapRow(ResultSet rs) throws SQLException {
        WaterLog log = new WaterLog();
        log.setId(rs.getInt("id"));
        log.setUserId(rs.getInt("user_id"));
        log.setLogDate(rs.getDate("log_date"));
        log.setAmountLiters(rs.getDouble("amount_liters"));
        log.setLogTime(rs.getTime("log_time"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        return log;
    }

    @Override
    public WaterLog save(WaterLog entity) {
        String sql = "INSERT INTO water_logs (user_id, log_date, amount_liters, log_time) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, entity.getUserId());
            ps.setDate(2, entity.getLogDate());
            ps.setDouble(3, entity.getAmountLiters());
            ps.setTime(4, entity.getLogTime() != null ? entity.getLogTime() : new Time(System.currentTimeMillis()));

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) entity.setId(rs.getInt(1));
                }
            }
            return entity;
        } catch (SQLException e) {
            throw new DatabaseException("Error logging water intake", e);
        }
    }

    @Override
    public boolean update(WaterLog entity) {
        String sql = "UPDATE water_logs SET amount_liters = ?, log_time = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, entity.getAmountLiters());
            ps.setTime(2, entity.getLogTime());
            ps.setInt(3, entity.getId());
            ps.setInt(4, entity.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating water log ID: " + entity.getId(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM water_logs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error deleting water log ID: " + id, e);
        }
    }

    @Override
    public Optional<WaterLog> findById(Integer id) {
        String sql = "SELECT * FROM water_logs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding water log ID: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<WaterLog> findAll() {
        List<WaterLog> list = new ArrayList<>();
        String sql = "SELECT * FROM water_logs ORDER BY log_date DESC, log_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error finding all water logs", e);
        }
        return list;
    }

    @Override
    public List<WaterLog> findByUserIdAndDate(int userId, Date date) {
        List<WaterLog> list = new ArrayList<>();
        String sql = "SELECT * FROM water_logs WHERE user_id = ? AND log_date = ? ORDER BY log_time ASC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding water logs for date", e);
        }
        return list;
    }

    @Override
    public double getTotalWaterByUserIdAndDate(int userId, Date date) {
        String sql = "SELECT SUM(amount_liters) AS total_water FROM water_logs WHERE user_id = ? AND log_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Math.round(rs.getDouble("total_water") * 100.0) / 100.0;
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error calculating daily total water", e);
        }
        return 0.0;
    }

    @Override
    public boolean deleteByUserIdAndDate(int userId, Date date) {
        String sql = "DELETE FROM water_logs WHERE user_id = ? AND log_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, date);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error clearing water logs for date", e);
        }
    }
}
