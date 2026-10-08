package com.fitnesstracker.dao;

import com.fitnesstracker.model.EmailVerificationToken;

import java.util.Optional;

/**
 * DAO interface for email verification token management.
 */
public interface EmailVerificationTokenDAO extends GenericDAO<EmailVerificationToken, Integer> {

    Optional<EmailVerificationToken> findByTokenHash(String tokenHash);

    Optional<EmailVerificationToken> findLatestByUserId(Integer userId);

    boolean markAsUsed(Integer tokenId);

    boolean deleteByUserId(Integer userId);

    long getSecondsSinceLastToken(Integer userId);

    boolean isTokenValid(String tokenHash);

    /**
     * Atomically validates token, marks it used, and marks the user's email as verified.
     * @param tokenHash SHA-256 hash of the verification token
     * @return true if token was valid and successfully activated the user; false otherwise
     */
    boolean verifyTokenAndActivateUser(String tokenHash);
}
