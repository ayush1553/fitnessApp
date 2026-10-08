package com.fitnesstracker.dao;

import com.fitnesstracker.model.PasswordResetToken;

import java.util.Optional;

/**
 * DAO interface for password reset token persistence.
 */
public interface PasswordResetTokenDAO extends GenericDAO<PasswordResetToken, Integer> {

    Optional<PasswordResetToken> findByTokenHash(String tokenHash);

    Optional<PasswordResetToken> findLatestByUserId(Integer userId);

    boolean markAsUsed(Integer tokenId);

    boolean deleteByUserId(Integer userId);

    long getSecondsSinceLastToken(Integer userId);

    boolean isTokenValid(String tokenHash);

    /**
     * Atomically validates token, updates the user's password hash, and marks token as used.
     * @param tokenHash SHA-256 hash of the token
     * @param newHashedPassword New hashed password
     * @return true if password was successfully reset; false otherwise
     */
    boolean resetPasswordWithToken(String tokenHash, String newHashedPassword);
}
