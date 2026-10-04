package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.FitnessContentDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.FitnessContent;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class FitnessContentDAOImpl implements FitnessContentDAO {

    private FitnessContent mapRow(ResultSet rs) throws SQLException {
        FitnessContent fc = new FitnessContent();
        fc.setId(rs.getInt("id"));
        fc.setUserId(rs.getInt("user_id"));
        fc.setTitle(rs.getString("title"));
        fc.setDescription(rs.getString("description"));
        fc.setCategory(rs.getString("category"));
        fc.setImageUrl(rs.getString("image_url"));
        fc.setStatus(rs.getString("status"));
        fc.setRejectionReason(rs.getString("rejection_reason"));
        fc.setCreatedAt(rs.getTimestamp("created_at"));
        fc.setUpdatedAt(rs.getTimestamp("updated_at"));

        try {
            fc.setAuthorName(rs.getString("author_name"));
            fc.setAuthorEmail(rs.getString("author_email"));
        } catch (SQLException ignored) {
        }
        return fc;
    }

    @Override
    public FitnessContent save(FitnessContent fc) {
        String sql = "INSERT INTO fitness_content (user_id, title, description, category, image_url, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, fc.getUserId());
            ps.setString(2, fc.getTitle());
            ps.setString(3, fc.getDescription());
            ps.setString(4, fc.getCategory());
            ps.setString(5, fc.getImageUrl());
            ps.setString(6, fc.getStatus() != null ? fc.getStatus() : "PENDING");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) fc.setId(rs.getInt(1));
                }
            }
            return fc;
        } catch (SQLException e) {
            throw new DatabaseException("Error creating fitness content", e);
        }
    }

    @Override
    public boolean update(FitnessContent fc) {
        String sql = "UPDATE fitness_content SET title = ?, description = ?, category = ?, image_url = ?, status = ?, rejection_reason = ? " +
                     "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fc.getTitle());
            ps.setString(2, fc.getDescription());
            ps.setString(3, fc.getCategory());
            ps.setString(4, fc.getImageUrl());
            ps.setString(5, fc.getStatus());
            ps.setString(6, fc.getRejectionReason());
            ps.setInt(7, fc.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating fitness content ID: " + fc.getId(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM fitness_content WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error deleting fitness content ID: " + id, e);
        }
    }

    @Override
    public Optional<FitnessContent> findById(Integer id) {
        String sql = "SELECT fc.*, u.name AS author_name, u.email AS author_email " +
                     "FROM fitness_content fc " +
                     "JOIN users u ON u.id = fc.user_id " +
                     "WHERE fc.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding fitness content ID: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<FitnessContent> findAll() {
        List<FitnessContent> list = new ArrayList<>();
        String sql = "SELECT fc.*, u.name AS author_name, u.email AS author_email " +
                     "FROM fitness_content fc " +
                     "JOIN users u ON u.id = fc.user_id " +
                     "ORDER BY fc.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving all fitness content", e);
        }
        return list;
    }

    @Override
    public List<FitnessContent> findApprovedContent() {
        List<FitnessContent> list = new ArrayList<>();
        String sql = "SELECT fc.*, u.name AS author_name, u.email AS author_email " +
                     "FROM fitness_content fc " +
                     "JOIN users u ON u.id = fc.user_id " +
                     "WHERE fc.status = 'APPROVED' " +
                     "ORDER BY fc.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving approved fitness content", e);
        }
        return list;
    }

    @Override
    public List<FitnessContent> findApprovedByCategory(String category) {
        List<FitnessContent> list = new ArrayList<>();
        String sql = "SELECT fc.*, u.name AS author_name, u.email AS author_email " +
                     "FROM fitness_content fc " +
                     "JOIN users u ON u.id = fc.user_id " +
                     "WHERE fc.status = 'APPROVED' AND fc.category = ? " +
                     "ORDER BY fc.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving approved fitness content by category", e);
        }
        return list;
    }

    @Override
    public List<FitnessContent> findPendingContent() {
        List<FitnessContent> list = new ArrayList<>();
        String sql = "SELECT fc.*, u.name AS author_name, u.email AS author_email " +
                     "FROM fitness_content fc " +
                     "JOIN users u ON u.id = fc.user_id " +
                     "WHERE fc.status = 'PENDING' " +
                     "ORDER BY fc.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving pending content", e);
        }
        return list;
    }

    @Override
    public List<FitnessContent> findByUserId(Integer userId) {
        List<FitnessContent> list = new ArrayList<>();
        String sql = "SELECT fc.*, u.name AS author_name, u.email AS author_email " +
                     "FROM fitness_content fc " +
                     "JOIN users u ON u.id = fc.user_id " +
                     "WHERE fc.user_id = ? " +
                     "ORDER BY fc.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving user content for ID: " + userId, e);
        }
        return list;
    }

    @Override
    public boolean updateStatus(Integer contentId, String status, String rejectionReason) {
        String sql = "UPDATE fitness_content SET status = ?, rejection_reason = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, rejectionReason);
            ps.setInt(3, contentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating content status for ID: " + contentId, e);
        }
    }

    @Override
    public int countPendingContent() {
        String sql = "SELECT COUNT(*) FROM fitness_content WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            throw new DatabaseException("Error counting pending content", e);
        }
        return 0;
    }
}
