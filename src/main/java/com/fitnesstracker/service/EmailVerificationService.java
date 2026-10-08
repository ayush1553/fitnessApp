package com.fitnesstracker.service;

import com.fitnesstracker.model.User;

/**
 * Service for email verification token lifecycle and dispatch.
 */
public interface EmailVerificationService {

    /**
     * Generates a secure random verification token, hashes and stores it in the database with a 24-hour expiration.
     * @param user The user to create the token for
     * @return Raw unhashed token string
     */
    String generateAndSaveToken(User user);

    /**
     * Validates a raw verification token and, if valid, marks the token used and activates the user.
     * @param rawToken The raw token string from the verification URL
     * @return true if verification succeeded; false if token is expired, invalid, or already used
     */
    boolean verifyToken(String rawToken);

    /**
     * Generates a token and sends the verification email to the user.
     * @param user The target user
     * @param baseUrl Application base URL (e.g. http://localhost:8080/fitness-tracker)
     * @return true if email dispatch was successful
     */
    boolean sendVerificationEmail(User user, String baseUrl);

    /**
     * Checks if the user is eligible to receive a new verification email (cooldown enforcement).
     * @param userId User identifier
     * @return true if eligible to resend
     */
    boolean canResendVerification(Integer userId);

    /**
     * Calculates remaining cooldown seconds before a resend is permitted.
     * @param userId User identifier
     * @return seconds remaining (0 if permitted immediately)
     */
    long getRemainingCooldownSeconds(Integer userId);
}
