package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.EmailVerificationTokenDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.EmailVerificationToken;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * JDBC Implementation of EmailVerificationTokenDAO.
 */
public class EmailVerificationTokenDAOImpl implements EmailVerificationTokenDAO {

    private static final Logger LOGGER = Logger.getLogger(EmailVerificationTokenDAOImpl.class.getName());

    private EmailVerificationToken mapRow(ResultSet rs) throws SQLException {
        EmailVerificationToken token = new EmailVerificationToken();
        token.setId(rs.getInt("id"));
        token.setUserId(rs.getInt("user_id"));
        token.setTokenHash(rs.getString("token_hash"));
        token.setExpiresAt(rs.getTimestamp("expires_at"));
        token.setCreatedAt(rs.getTimestamp("created_at"));
        token.setUsedAt(rs.getTimestamp("used_at"));
        return token;
    }

    @Override
    public EmailVerificationToken save(EmailVerificationToken token) {
        String sql = "INSERT INTO email_verification_tokens (user_id, token_hash, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 24 HOUR))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, token.getUserId());
            ps.setString(2, token.getTokenHash());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        token.setId(rs.getInt(1));
                    }
                }
            }
            return token;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving email verification token for userId: " + token.getUserId(), e);
            throw new DatabaseException("Error saving email verification token", e);
        }
    }

    @Override
    public boolean update(EmailVerificationToken token) {
        String sql = "UPDATE email_verification_tokens SET used_at = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, token.getUsedAt());
            ps.setInt(2, token.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating email verification token ID: " + token.getId(), e);
            throw new DatabaseException("Error updating email verification token", e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM email_verification_tokens WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting email verification token ID: " + id, e);
            throw new DatabaseException("Error deleting email verification token", e);
        }
    }

    @Override
    public Optional<EmailVerificationToken> findById(Integer id) {
        String sql = "SELECT * FROM email_verification_tokens WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding verification token by ID: " + id, e);
            throw new DatabaseException("Error finding verification token by ID", e);
        }
        return Optional.empty();
    }

    @Override
    public List<EmailVerificationToken> findAll() {
        List<EmailVerificationToken> list = new ArrayList<>();
        String sql = "SELECT * FROM email_verification_tokens ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all verification tokens", e);
            throw new DatabaseException("Error retrieving verification tokens", e);
        }
        return list;
    }

    @Override
    public Optional<EmailVerificationToken> findByTokenHash(String tokenHash) {
        String sql = "SELECT * FROM email_verification_tokens WHERE token_hash = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tokenHash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding verification token by hash", e);
            throw new DatabaseException("Error finding verification token by hash", e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<EmailVerificationToken> findLatestByUserId(Integer userId) {
        String sql = "SELECT * FROM email_verification_tokens WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding latest verification token for user: " + userId, e);
            throw new DatabaseException("Error finding latest verification token", e);
        }
        return Optional.empty();
    }

    @Override
    public boolean markAsUsed(Integer tokenId) {
        String sql = "UPDATE email_verification_tokens SET used_at = CURRENT_TIMESTAMP WHERE id = ? AND used_at IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tokenId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking token as used ID: " + tokenId, e);
            throw new DatabaseException("Error marking token as used", e);
        }
    }

    @Override
    public boolean deleteByUserId(Integer userId) {
        String sql = "DELETE FROM email_verification_tokens WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting verification tokens for userId: " + userId, e);
            throw new DatabaseException("Error deleting verification tokens", e);
        }
    }

    @Override
    public long getSecondsSinceLastToken(Integer userId) {
        String sql = "SELECT TIMESTAMPDIFF(SECOND, created_at, NOW()) AS elapsed_seconds FROM email_verification_tokens WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("elapsed_seconds");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching elapsed seconds for email verification token: " + userId, e);
        }
        return -1;
    }

    @Override
    public boolean isTokenValid(String tokenHash) {
        String sql = "SELECT 1 FROM email_verification_tokens WHERE token_hash = ? AND used_at IS NULL AND expires_at >= NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tokenHash);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error validating email verification token hash", e);
        }
        return false;
    }

    @Override
    public boolean verifyTokenAndActivateUser(String tokenHash) {
        String selectTokenSql = "SELECT id, user_id, used_at, (expires_at < NOW()) AS is_expired FROM email_verification_tokens WHERE token_hash = ? FOR UPDATE";
        String updateTokenSql = "UPDATE email_verification_tokens SET used_at = CURRENT_TIMESTAMP WHERE id = ?";
        String updateUserSql = "UPDATE users SET email_verified = TRUE WHERE id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int tokenId;
            int userId;
            boolean isExpired;
            Timestamp usedAt;

            try (PreparedStatement psToken = conn.prepareStatement(selectTokenSql)) {
                psToken.setString(1, tokenHash);
                try (ResultSet rs = psToken.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                    tokenId = rs.getInt("id");
                    userId = rs.getInt("user_id");
                    isExpired = rs.getBoolean("is_expired");
                    usedAt = rs.getTimestamp("used_at");
                }
            }

            // Verify not already used and not expired
            if (usedAt != null) {
                conn.rollback();
                LOGGER.info("Token verification rejected: token has already been used (tokenId: " + tokenId + ")");
                return false;
            }

            if (isExpired) {
                conn.rollback();
                LOGGER.info("Token verification rejected: token is expired (tokenId: " + tokenId + ")");
                return false;
            }

            // Update token used_at
            try (PreparedStatement psUpdateToken = conn.prepareStatement(updateTokenSql)) {
                psUpdateToken.setInt(1, tokenId);
                int tokenRows = psUpdateToken.executeUpdate();
                if (tokenRows <= 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Update user email_verified = TRUE
            try (PreparedStatement psUpdateUser = conn.prepareStatement(updateUserSql)) {
                psUpdateUser.setInt(1, userId);
                int userRows = psUpdateUser.executeUpdate();
                if (userRows <= 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            LOGGER.info("Successfully verified email for userId: " + userId + " with tokenId: " + tokenId);
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Rollback failed during token verification", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Transaction failed while verifying token", e);
            throw new DatabaseException("Failed to verify token in database transaction", e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.FINE, "Error closing connection", e);
                }
            }
        }
    }
}
