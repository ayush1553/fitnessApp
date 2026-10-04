package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.ChallengeDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.Challenge;
import com.fitnesstracker.model.ChallengeParticipant;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ChallengeDAOImpl implements ChallengeDAO {

    static {
        ensureSchema();
    }

    private static void ensureSchema() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            // Check if column exists, if not add it
            DatabaseMetaData meta = conn.getMetaData();
            try (ResultSet rs = meta.getColumns(null, null, "challenges", "image_url")) {
                if (!rs.next()) {
                    stmt.executeUpdate("ALTER TABLE challenges ADD COLUMN image_url VARCHAR(500) NULL AFTER status");
                }
            }
            // Seed image URLs for default challenges if null
            stmt.executeUpdate("UPDATE challenges SET image_url = 'assets/images/challenges/running.jpg' WHERE id = 1 AND (image_url IS NULL OR image_url = '')");
            stmt.executeUpdate("UPDATE challenges SET image_url = 'assets/images/challenges/hiit.jpg' WHERE id = 2 AND (image_url IS NULL OR image_url = '')");
            stmt.executeUpdate("UPDATE challenges SET image_url = 'assets/images/challenges/cycling.jpg' WHERE id = 3 AND (image_url IS NULL OR image_url = '')");
            stmt.executeUpdate("UPDATE challenges SET image_url = 'assets/images/challenges/strength.jpg' WHERE id = 4 AND (image_url IS NULL OR image_url = '')");
        } catch (Exception ignored) {
            // Ignored if DB is initializing or permissions differ
        }
    }

    private Challenge mapRow(ResultSet rs) throws SQLException {
        Challenge c = new Challenge();
        c.setId(rs.getInt("id"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setCategory(rs.getString("category"));
        c.setTargetValue(rs.getBigDecimal("target_value"));
        c.setUnit(rs.getString("unit"));
        c.setStartDate(rs.getDate("start_date"));
        c.setEndDate(rs.getDate("end_date"));
        c.setStatus(rs.getString("status"));
        try {
            c.setImageUrl(rs.getString("image_url"));
        } catch (SQLException e) {
            // Column might not exist in older schema
        }
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
    }

    @Override
    public Challenge save(Challenge c) {
        String sql = "INSERT INTO challenges (title, description, category, target_value, unit, start_date, end_date, status, image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getTitle());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getCategory());
            ps.setBigDecimal(4, c.getTargetValue());
            ps.setString(5, c.getUnit());
            ps.setDate(6, c.getStartDate());
            ps.setDate(7, c.getEndDate());
            ps.setString(8, c.getStatus() != null ? c.getStatus() : "ACTIVE");
            ps.setString(9, c.getImageUrl());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) c.setId(rs.getInt(1));
                }
            }
            return c;
        } catch (SQLException e) {
            throw new DatabaseException("Error saving challenge", e);
        }
    }

    @Override
    public boolean update(Challenge c) {
        String sql = "UPDATE challenges SET title = ?, description = ?, category = ?, target_value = ?, " +
                     "unit = ?, start_date = ?, end_date = ?, status = ?, image_url = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getTitle());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getCategory());
            ps.setBigDecimal(4, c.getTargetValue());
            ps.setString(5, c.getUnit());
            ps.setDate(6, c.getStartDate());
            ps.setDate(7, c.getEndDate());
            ps.setString(8, c.getStatus());
            ps.setString(9, c.getImageUrl());
            ps.setInt(10, c.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating challenge ID: " + c.getId(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM challenges WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error deleting challenge ID: " + id, e);
        }
    }

    @Override
    public Optional<Challenge> findById(Integer id) {
        String sql = "SELECT c.*, COUNT(cp.id) AS participant_count " +
                     "FROM challenges c " +
                     "LEFT JOIN challenge_participants cp ON cp.challenge_id = c.id " +
                     "WHERE c.id = ? " +
                     "GROUP BY c.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Challenge c = mapRow(rs);
                    c.setParticipantCount(rs.getInt("participant_count"));
                    return Optional.of(c);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding challenge by ID: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Challenge> findAll() {
        List<Challenge> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(cp.id) AS participant_count " +
                     "FROM challenges c " +
                     "LEFT JOIN challenge_participants cp ON cp.challenge_id = c.id " +
                     "GROUP BY c.id " +
                     "ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Challenge c = mapRow(rs);
                c.setParticipantCount(rs.getInt("participant_count"));
                list.add(c);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding all challenges", e);
        }
        return list;
    }

    @Override
    public List<Challenge> findActiveChallenges() {
        List<Challenge> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(cp.id) AS participant_count " +
                     "FROM challenges c " +
                     "LEFT JOIN challenge_participants cp ON cp.challenge_id = c.id " +
                     "WHERE c.status = 'ACTIVE' " +
                     "GROUP BY c.id " +
                     "ORDER BY c.end_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Challenge c = mapRow(rs);
                c.setParticipantCount(rs.getInt("participant_count"));
                list.add(c);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding active challenges", e);
        }
        return list;
    }

    @Override
    public List<Challenge> findChallengesWithUserStatus(Integer userId) {
        List<Challenge> list = new ArrayList<>();
        String sql = "SELECT c.*, " +
                     "  COUNT(DISTINCT cp_all.id) AS participant_count, " +
                     "  cp_user.id AS user_part_id, " +
                     "  cp_user.progress AS user_progress, " +
                     "  cp_user.status AS user_status, " +
                     "  cp_user.joined_date AS user_joined_date, " +
                     "  cp_user.completed_date AS user_completed_date " +
                     "FROM challenges c " +
                     "LEFT JOIN challenge_participants cp_all ON cp_all.challenge_id = c.id " +
                     "LEFT JOIN challenge_participants cp_user ON cp_user.challenge_id = c.id AND cp_user.user_id = ? " +
                     "WHERE c.status IN ('ACTIVE', 'UPCOMING') " +
                     "GROUP BY c.id, cp_user.id " +
                     "ORDER BY c.end_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Challenge c = mapRow(rs);
                    c.setParticipantCount(rs.getInt("participant_count"));

                    int userPartId = rs.getInt("user_part_id");
                    if (!rs.wasNull() && userPartId > 0) {
                        c.setUserJoined(true);
                        ChallengeParticipant cp = new ChallengeParticipant();
                        cp.setId(userPartId);
                        cp.setUserId(userId);
                        cp.setChallengeId(c.getId());
                        cp.setProgress(rs.getBigDecimal("user_progress"));
                        cp.setStatus(rs.getString("user_status"));
                        cp.setJoinedDate(rs.getTimestamp("user_joined_date"));
                        cp.setCompletedDate(rs.getTimestamp("user_completed_date"));
                        cp.setChallenge(c);
                        c.setUserParticipation(cp);
                    } else {
                        c.setUserJoined(false);
                    }
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving challenges with user status", e);
        }
        return list;
    }

    @Override
    public int countActiveChallenges() {
        String sql = "SELECT COUNT(*) FROM challenges WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            throw new DatabaseException("Error counting active challenges", e);
        }
        return 0;
    }

    @Override
    public boolean updateStatus(Integer challengeId, String status) {
        String sql = "UPDATE challenges SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, challengeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating status for challenge ID: " + challengeId, e);
        }
    }
}
