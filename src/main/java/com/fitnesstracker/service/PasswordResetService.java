package com.fitnesstracker.service;

import com.fitnesstracker.model.User;

/**
 * Service for password reset token lifecycle and password recovery flows.
 */
public interface PasswordResetService {

    /**
     * Generates a secure random reset token, hashes and stores it in the database with 1-hour expiration.
     * @param user The user requesting the reset
     * @return Raw unhashed token string
     */
    String generateAndSaveResetToken(User user);

    /**
     * Validates if a raw token is valid, unexpired, and unused.
     * @param rawToken Raw token string
     * @return true if valid, false otherwise
     */
    boolean validateResetToken(String rawToken);

    /**
     * Resets the user password associated with the given raw token.
     * @param rawToken Raw token string
     * @param newPassword New plain-text password to hash and set
     * @return true if reset succeeded, false otherwise
     */
    boolean resetPassword(String rawToken, String newPassword);

    /**
     * Generates a reset token and sends the password reset email to the user.
     * @param user The target user
     * @param baseUrl Application base URL
     * @return true if email was successfully dispatched
     */
    boolean sendPasswordResetEmail(User user, String baseUrl);

    /**
     * Checks if the user is eligible to request a password reset (rate limit cooldown).
     * @param userId User identifier
     * @return true if eligible
     */
    boolean canRequestPasswordReset(Integer userId);

    /**
     * Calculates remaining cooldown seconds before a password reset can be re-requested.
     * @param userId User identifier
     * @return remaining seconds (0 if permitted immediately)
     */
    long getRemainingCooldownSeconds(Integer userId);
}
