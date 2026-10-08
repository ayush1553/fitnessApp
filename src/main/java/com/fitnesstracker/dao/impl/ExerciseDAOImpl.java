package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.ExerciseDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.Exercise;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ExerciseDAOImpl implements ExerciseDAO {

    private Exercise mapRow(ResultSet rs) throws SQLException {
        Exercise ex = new Exercise();
        ex.setId(rs.getInt("id"));
        ex.setName(rs.getString("name"));
        ex.setSlug(rs.getString("slug"));
        ex.setCategory(rs.getString("category"));
        ex.setDifficulty(rs.getString("difficulty"));
        ex.setEquipment(rs.getString("equipment"));
        ex.setTargetMuscles(rs.getString("target_muscles"));
        ex.setSecondaryMuscles(rs.getString("secondary_muscles"));
        ex.setDescription(rs.getString("description"));
        ex.setInstructions(rs.getString("instructions"));
        ex.setCommonMistakes(rs.getString("common_mistakes"));
        ex.setFormTips(rs.getString("form_tips"));
        try {
            ex.setSafetyTips(rs.getString("safety_tips"));
        } catch (SQLException ignored) {
        }
        try {
            ex.setRestTimeSeconds(rs.getInt("rest_time_seconds"));
        } catch (SQLException ignored) {
        }
        ex.setDefaultSets(rs.getInt("default_sets"));
        ex.setDefaultReps(rs.getString("default_reps"));
        ex.setDefaultDurationSeconds(rs.getInt("default_duration_seconds"));
        ex.setVideoUrl(rs.getString("video_url"));
        ex.setThumbnailUrl(rs.getString("thumbnail_url"));
        ex.setStatus(rs.getString("status"));
        ex.setCreatedAt(rs.getTimestamp("created_at"));
        ex.setUpdatedAt(rs.getTimestamp("updated_at"));
        return ex;
    }

    @Override
    public Exercise save(Exercise ex) {
        String sql = "INSERT INTO exercises (name, slug, category, difficulty, equipment, target_muscles, secondary_muscles, description, instructions, common_mistakes, form_tips, default_sets, default_reps, default_duration_seconds, video_url, thumbnail_url, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, ex.getName());
            ps.setString(2, ex.getSlug());
            ps.setString(3, ex.getCategory());
            ps.setString(4, ex.getDifficulty());
            ps.setString(5, ex.getEquipment());
            ps.setString(6, ex.getTargetMuscles());
            ps.setString(7, ex.getSecondaryMuscles());
            ps.setString(8, ex.getDescription());
            ps.setString(9, ex.getInstructions());
            ps.setString(10, ex.getCommonMistakes());
            ps.setString(11, ex.getFormTips());
            ps.setInt(12, ex.getDefaultSets());
            ps.setString(13, ex.getDefaultReps());
            ps.setInt(14, ex.getDefaultDurationSeconds());
            ps.setString(15, ex.getVideoUrl());
            ps.setString(16, ex.getThumbnailUrl());
            ps.setString(17, ex.getStatus() != null ? ex.getStatus() : "ACTIVE");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) ex.setId(rs.getInt(1));
                }
            }
            return ex;
        } catch (SQLException e) {
            throw new DatabaseException("Error creating exercise: " + ex.getName(), e);
        }
    }

    @Override
    public boolean update(Exercise ex) {
        String sql = "UPDATE exercises SET name = ?, slug = ?, category = ?, difficulty = ?, equipment = ?, target_muscles = ?, secondary_muscles = ?, description = ?, instructions = ?, common_mistakes = ?, form_tips = ?, default_sets = ?, default_reps = ?, default_duration_seconds = ?, video_url = ?, thumbnail_url = ?, status = ? " +
                     "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ex.getName());
            ps.setString(2, ex.getSlug());
            ps.setString(3, ex.getCategory());
            ps.setString(4, ex.getDifficulty());
            ps.setString(5, ex.getEquipment());
            ps.setString(6, ex.getTargetMuscles());
            ps.setString(7, ex.getSecondaryMuscles());
            ps.setString(8, ex.getDescription());
            ps.setString(9, ex.getInstructions());
            ps.setString(10, ex.getCommonMistakes());
            ps.setString(11, ex.getFormTips());
            ps.setInt(12, ex.getDefaultSets());
            ps.setString(13, ex.getDefaultReps());
            ps.setInt(14, ex.getDefaultDurationSeconds());
            ps.setString(15, ex.getVideoUrl());
            ps.setString(16, ex.getThumbnailUrl());
            ps.setString(17, ex.getStatus());
            ps.setInt(18, ex.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating exercise ID: " + ex.getId(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM exercises WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error deleting exercise ID: " + id, e);
        }
    }

    @Override
    public Optional<Exercise> findById(Integer id) {
        String sql = "SELECT * FROM exercises WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding exercise ID: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Exercise> findBySlug(String slug) {
        String sql = "SELECT * FROM exercises WHERE slug = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding exercise slug: " + slug, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Exercise> findAll() {
        List<Exercise> list = new ArrayList<>();
        String sql = "SELECT * FROM exercises ORDER BY category ASC, name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving all exercises", e);
        }
        return list;
    }

    @Override
    public List<Exercise> findActiveExercises() {
        List<Exercise> list = new ArrayList<>();
        String sql = "SELECT * FROM exercises WHERE status = 'ACTIVE' ORDER BY category ASC, name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving active exercises", e);
        }
        return list;
    }

    @Override
    public List<Exercise> findActiveByCategory(String category) {
        List<Exercise> list = new ArrayList<>();
        String sql = "SELECT * FROM exercises WHERE status = 'ACTIVE' AND category = ? ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving active exercises by category: " + category, e);
        }
        return list;
    }

    @Override
    public List<Exercise> findActiveByCategoryAndDifficulty(String category, String difficulty) {
        List<Exercise> list = new ArrayList<>();
        String sql = "SELECT * FROM exercises WHERE status = 'ACTIVE' AND category = ? AND difficulty = ? ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ps.setString(2, difficulty);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving active exercises by category and difficulty", e);
        }
        return list;
    }

    @Override
    public List<Exercise> searchActiveExercises(String query, String category) {
        List<Exercise> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM exercises WHERE status = 'ACTIVE' ");
        List<Object> params = new ArrayList<>();

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category.trim())) {
            sql.append("AND category = ? ");
            params.add(category.trim());
        }

        if (query != null && !query.trim().isEmpty()) {
            String pattern = "%" + query.trim() + "%";
            sql.append("AND (name LIKE ? OR description LIKE ? OR target_muscles LIKE ? OR equipment LIKE ? OR difficulty LIKE ?) ");
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        sql.append("ORDER BY category ASC, name ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error searching active exercises", e);
        }
        return list;
    }

    @Override
    public List<Exercise> findRelatedExercises(Integer exerciseId, String category, int limit) {
        List<Exercise> list = new ArrayList<>();
        String sql = "SELECT * FROM exercises WHERE status = 'ACTIVE' AND id != ? AND category = ? ORDER BY RAND() LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, exerciseId != null ? exerciseId : -1);
            ps.setString(2, category);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving related exercises", e);
        }

        if (list.size() < limit) {
            int remaining = limit - list.size();
            String fallbackSql = "SELECT * FROM exercises WHERE status = 'ACTIVE' AND id != ? ORDER BY RAND() LIMIT ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(fallbackSql)) {
                ps.setInt(1, exerciseId != null ? exerciseId : -1);
                ps.setInt(2, remaining);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Exercise ex = mapRow(rs);
                        if (list.stream().noneMatch(item -> item.getId().equals(ex.getId()))) {
                            list.add(ex);
                        }
                    }
                }
            } catch (SQLException ignored) {
            }
        }
        return list;
    }

    @Override
    public int countTotalExercises() {
        String sql = "SELECT COUNT(*) FROM exercises";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            throw new DatabaseException("Error counting total exercises", e);
        }
        return 0;
    }
}
