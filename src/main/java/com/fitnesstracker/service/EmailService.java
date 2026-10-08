package com.fitnesstracker.service;

/**
 * Service interface for transactional email delivery.
 */
public interface EmailService {

    /**
     * Sends an email verification email with a secure link.
     * @param toEmail The recipient's email address
     * @param userName The recipient's display name
     * @param verificationLink Full verification URL
     * @return true if email was dispatched successfully (or simulated in dev), false otherwise
     */
    boolean sendVerificationEmail(String toEmail, String userName, String verificationLink);

    /**
     * Sends a password reset email with a secure link.
     * @param toEmail The recipient's email address
     * @param userName The recipient's display name
     * @param resetLink Full password reset URL
     * @return true if email was dispatched successfully (or simulated in dev), false otherwise
     */
    boolean sendPasswordResetEmail(String toEmail, String userName, String resetLink);
}
