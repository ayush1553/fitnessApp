package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.ChallengeParticipantDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.Challenge;
import com.fitnesstracker.model.ChallengeParticipant;
import com.fitnesstracker.model.RegularUser;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ChallengeParticipantDAOImpl implements ChallengeParticipantDAO {

    private ChallengeParticipant mapRow(ResultSet rs) throws SQLException {
        ChallengeParticipant cp = new ChallengeParticipant();
        cp.setId(rs.getInt("id"));
        cp.setUserId(rs.getInt("user_id"));
        cp.setChallengeId(rs.getInt("challenge_id"));
        cp.setProgress(rs.getBigDecimal("progress"));
        cp.setStatus(rs.getString("status"));
        cp.setJoinedDate(rs.getTimestamp("joined_date"));
        cp.setCompletedDate(rs.getTimestamp("completed_date"));

        // Map joined challenge fields if present in result set
        try {
            if (rs.getString("challenge_title") != null) {
                Challenge c = new Challenge();
                c.setId(cp.getChallengeId());
                c.setTitle(rs.getString("challenge_title"));
                c.setDescription(rs.getString("challenge_desc"));
                c.setTargetValue(rs.getBigDecimal("challenge_target"));
                c.setUnit(rs.getString("challenge_unit"));
                c.setStartDate(rs.getDate("challenge_start"));
                c.setEndDate(rs.getDate("challenge_end"));
                c.setStatus(rs.getString("challenge_status"));
                cp.setChallenge(c);
            }
        } catch (SQLException ignored) {
        }

        return cp;
    }

    @Override
    public ChallengeParticipant save(ChallengeParticipant cp) {
        String sql = "INSERT INTO challenge_participants (user_id, challenge_id, progress, status, joined_date) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, cp.getUserId());
            ps.setInt(2, cp.getChallengeId());
            ps.setBigDecimal(3, cp.getProgress() != null ? cp.getProgress() : BigDecimal.ZERO);
            ps.setString(4, cp.getStatus() != null ? cp.getStatus() : "IN_PROGRESS");
            ps.setTimestamp(5, cp.getJoinedDate() != null ? cp.getJoinedDate() : new Timestamp(System.currentTimeMillis()));

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) cp.setId(rs.getInt(1));
                }
            }
            return cp;
        } catch (SQLException e) {
            throw new DatabaseException("Error joining challenge", e);
        }
    }

    @Override
    public boolean update(ChallengeParticipant cp) {
        String sql = "UPDATE challenge_participants SET progress = ?, status = ?, completed_date = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, cp.getProgress());
            ps.setString(2, cp.getStatus());
            ps.setTimestamp(3, cp.getCompletedDate());
            ps.setInt(4, cp.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating challenge participant ID: " + cp.getId(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM challenge_participants WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error removing challenge participation", e);
        }
    }

    @Override
    public Optional<ChallengeParticipant> findById(Integer id) {
        String sql = "SELECT cp.*, c.title AS challenge_title, c.description AS challenge_desc, " +
                     "c.target_value AS challenge_target, c.unit AS challenge_unit, " +
                     "c.start_date AS challenge_start, c.end_date AS challenge_end, c.status AS challenge_status " +
                     "FROM challenge_participants cp " +
                     "JOIN challenges c ON c.id = cp.challenge_id " +
                     "WHERE cp.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding participant by ID: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<ChallengeParticipant> findAll() {
        List<ChallengeParticipant> list = new ArrayList<>();
        String sql = "SELECT cp.*, c.title AS challenge_title, c.description AS challenge_desc, " +
                     "c.target_value AS challenge_target, c.unit AS challenge_unit, " +
                     "c.start_date AS challenge_start, c.end_date AS challenge_end, c.status AS challenge_status " +
                     "FROM challenge_participants cp " +
                     "JOIN challenges c ON c.id = cp.challenge_id " +
                     "ORDER BY cp.joined_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving challenge participants", e);
        }
        return list;
    }

    @Override
    public Optional<ChallengeParticipant> findByUserAndChallenge(Integer userId, Integer challengeId) {
        String sql = "SELECT cp.*, c.title AS challenge_title, c.description AS challenge_desc, " +
                     "c.target_value AS challenge_target, c.unit AS challenge_unit, " +
                     "c.start_date AS challenge_start, c.end_date AS challenge_end, c.status AS challenge_status " +
                     "FROM challenge_participants cp " +
                     "JOIN challenges c ON c.id = cp.challenge_id " +
                     "WHERE cp.user_id = ? AND cp.challenge_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, challengeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error checking challenge participation", e);
        }
        return Optional.empty();
    }

    @Override
    public List<ChallengeParticipant> findByUserId(Integer userId) {
        List<ChallengeParticipant> list = new ArrayList<>();
        String sql = "SELECT cp.*, c.title AS challenge_title, c.description AS challenge_desc, " +
                     "c.target_value AS challenge_target, c.unit AS challenge_unit, " +
                     "c.start_date AS challenge_start, c.end_date AS challenge_end, c.status AS challenge_status " +
                     "FROM challenge_participants cp " +
                     "JOIN challenges c ON c.id = cp.challenge_id " +
                     "WHERE cp.user_id = ? " +
                     "ORDER BY cp.joined_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding challenges by user ID: " + userId, e);
        }
        return list;
    }

    @Override
    public List<ChallengeParticipant> findActiveByUserId(Integer userId) {
        List<ChallengeParticipant> list = new ArrayList<>();
        String sql = "SELECT cp.*, c.title AS challenge_title, c.description AS challenge_desc, " +
                     "c.target_value AS challenge_target, c.unit AS challenge_unit, " +
                     "c.start_date AS challenge_start, c.end_date AS challenge_end, c.status AS challenge_status " +
                     "FROM challenge_participants cp " +
                     "JOIN challenges c ON c.id = cp.challenge_id " +
                     "WHERE cp.user_id = ? AND cp.status = 'IN_PROGRESS' " +
                     "ORDER BY c.end_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding active challenges by user ID: " + userId, e);
        }
        return list;
    }

    @Override
    public List<ChallengeParticipant> findByChallengeId(Integer challengeId) {
        List<ChallengeParticipant> list = new ArrayList<>();
        String sql = "SELECT cp.*, u.name AS user_name, u.email AS user_email " +
                     "FROM challenge_participants cp " +
                     "JOIN users u ON u.id = cp.user_id " +
                     "WHERE cp.challenge_id = ? " +
                     "ORDER BY cp.progress DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, challengeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChallengeParticipant cp = mapRow(rs);
                    RegularUser user = new RegularUser();
                    user.setId(cp.getUserId());
                    user.setName(rs.getString("user_name"));
                    user.setEmail(rs.getString("user_email"));
                    cp.setUser(user);
                    list.add(cp);
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding participants for challenge ID: " + challengeId, e);
        }
        return list;
    }

    @Override
    public boolean exists(Integer userId, Integer challengeId) {
        String sql = "SELECT 1 FROM challenge_participants WHERE user_id = ? AND challenge_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, challengeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error checking challenge participant existence", e);
        }
    }

    @Override
    public boolean updateProgress(Integer participantId, BigDecimal newProgress) {
        String sql = "UPDATE challenge_participants cp " +
                     "JOIN challenges c ON c.id = cp.challenge_id " +
                     "SET cp.progress = ?, " +
                     "    cp.status = CASE WHEN ? >= c.target_value THEN 'COMPLETED' ELSE cp.status END, " +
                     "    cp.completed_date = CASE WHEN ? >= c.target_value THEN NOW() ELSE cp.completed_date END " +
                     "WHERE cp.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, newProgress);
            ps.setBigDecimal(2, newProgress);
            ps.setBigDecimal(3, newProgress);
            ps.setInt(4, participantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating challenge participant progress", e);
        }
    }

    @Override
    public boolean markCompleted(Integer participantId) {
        String sql = "UPDATE challenge_participants SET status = 'COMPLETED', completed_date = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, participantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error completing challenge participation", e);
        }
    }

    @Override
    public int countParticipants(Integer challengeId) {
        String sql = "SELECT COUNT(*) FROM challenge_participants WHERE challenge_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, challengeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting participants", e);
        }
        return 0;
    }

    @Override
    public int countCompletedChallengesByUserId(Integer userId) {
        String sql = "SELECT COUNT(*) FROM challenge_participants WHERE user_id = ? AND status = 'COMPLETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting completed challenges", e);
        }
        return 0;
    }
}
