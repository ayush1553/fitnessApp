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
        
        try {
            fc.setContentBody(rs.getString("content_body"));
        } catch (SQLException ignored) {
            // column might not exist in old migrations
        }
        
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
        try {
            fc.setSubcategory(rs.getString("subcategory"));
        } catch (SQLException ignored) {
        }
        try {
            fc.setReadTimeMinutes(rs.getInt("read_time_minutes"));
        } catch (SQLException ignored) {
        }
        try {
            fc.setLevel(rs.getString("level"));
        } catch (SQLException ignored) {
        }
        return fc;
    }

    @Override
    public FitnessContent save(FitnessContent fc) {
        String sql = "INSERT INTO fitness_content (user_id, title, description, content_body, category, image_url, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, fc.getUserId());
            ps.setString(2, fc.getTitle());
            ps.setString(3, fc.getDescription());
            ps.setString(4, fc.getContentBody());
            ps.setString(5, fc.getCategory());
            ps.setString(6, fc.getImageUrl());
            ps.setString(7, fc.getStatus() != null ? fc.getStatus() : "PENDING");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) fc.setId(rs.getInt(1));
                }
            }
            return fc;
        } catch (SQLException e) {
            // Fallback for schemas where content_body might not have been added yet
            String fallbackSql = "INSERT INTO fitness_content (user_id, title, description, category, image_url, status) " +
                                 "VALUES (?, ?, ?, ?, ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(fallbackSql, Statement.RETURN_GENERATED_KEYS)) {
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
            } catch (SQLException ex) {
                throw new DatabaseException("Error creating fitness content", ex);
            }
        }
    }

    @Override
    public boolean update(FitnessContent fc) {
        String sql = "UPDATE fitness_content SET title = ?, description = ?, content_body = ?, category = ?, image_url = ?, status = ?, rejection_reason = ? " +
                     "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fc.getTitle());
            ps.setString(2, fc.getDescription());
            ps.setString(3, fc.getContentBody());
            ps.setString(4, fc.getCategory());
            ps.setString(5, fc.getImageUrl());
            ps.setString(6, fc.getStatus());
            ps.setString(7, fc.getRejectionReason());
            ps.setInt(8, fc.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            String fallbackSql = "UPDATE fitness_content SET title = ?, description = ?, category = ?, image_url = ?, status = ?, rejection_reason = ? " +
                                 "WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(fallbackSql)) {
                ps.setString(1, fc.getTitle());
                ps.setString(2, fc.getDescription());
                ps.setString(3, fc.getCategory());
                ps.setString(4, fc.getImageUrl());
                ps.setString(5, fc.getStatus());
                ps.setString(6, fc.getRejectionReason());
                ps.setInt(7, fc.getId());

                return ps.executeUpdate() > 0;
            } catch (SQLException ex) {
                throw new DatabaseException("Error updating fitness content ID: " + fc.getId(), ex);
            }
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
    public List<FitnessContent> findRelatedContent(Integer contentId, String category, int limit) {
        List<FitnessContent> list = new ArrayList<>();
        // First try to find approved content in the same category
        String sqlCategory = "SELECT fc.*, u.name AS author_name, u.email AS author_email " +
                             "FROM fitness_content fc " +
                             "JOIN users u ON u.id = fc.user_id " +
                             "WHERE fc.status = 'APPROVED' AND fc.id != ? AND fc.category = ? " +
                             "ORDER BY fc.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlCategory)) {
            ps.setInt(1, contentId != null ? contentId : -1);
            ps.setString(2, category);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving related fitness content", e);
        }

        // If fewer than limit, fill up with other approved articles
        if (list.size() < limit) {
            int remaining = limit - list.size();
            List<Integer> existingIds = new ArrayList<>();
            if (contentId != null) existingIds.add(contentId);
            for (FitnessContent fc : list) {
                existingIds.add(fc.getId());
            }

            StringBuilder fallbackSql = new StringBuilder(
                    "SELECT fc.*, u.name AS author_name, u.email AS author_email " +
                    "FROM fitness_content fc " +
                    "JOIN users u ON u.id = fc.user_id " +
                    "WHERE fc.status = 'APPROVED' ");
            if (!existingIds.isEmpty()) {
                fallbackSql.append("AND fc.id NOT IN (");
                for (int i = 0; i < existingIds.size(); i++) {
                    fallbackSql.append(i == 0 ? "?" : ", ?");
                }
                fallbackSql.append(") ");
            }
            fallbackSql.append("ORDER BY fc.created_at DESC LIMIT ?");

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(fallbackSql.toString())) {
                int paramIndex = 1;
                for (Integer id : existingIds) {
                    ps.setInt(paramIndex++, id);
                }
                ps.setInt(paramIndex, remaining);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) list.add(mapRow(rs));
                }
            } catch (SQLException e) {
                // Log and ignore fallback failure if main list succeeded
            }
        }

        return list;
    }

    @Override
    public List<FitnessContent> searchApprovedContent(String query, String category) {
        List<FitnessContent> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT fc.*, u.name AS author_name, u.email AS author_email " +
                "FROM fitness_content fc " +
                "JOIN users u ON u.id = fc.user_id " +
                "WHERE fc.status = 'APPROVED' ");

        List<Object> params = new ArrayList<>();

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category.trim())) {
            sql.append("AND fc.category = ? ");
            params.add(category.trim());
        }

        if (query != null && !query.trim().isEmpty()) {
            String pattern = "%" + query.trim() + "%";
            sql.append("AND (fc.title LIKE ? OR fc.description LIKE ? OR fc.category LIKE ? OR u.name LIKE ?) ");
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        sql.append("ORDER BY fc.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error searching approved fitness content", e);
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
