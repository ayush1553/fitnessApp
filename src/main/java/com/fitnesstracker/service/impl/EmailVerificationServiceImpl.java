package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.EmailVerificationTokenDAO;
import com.fitnesstracker.dao.impl.EmailVerificationTokenDAOImpl;
import com.fitnesstracker.model.EmailVerificationToken;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.EmailService;
import com.fitnesstracker.service.EmailVerificationService;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Enterprise implementation of EmailVerificationService.
 * Handles SecureRandom token generation, SHA-256 database hashing, 24-hour expiration, and rate limiting.
 */
public class EmailVerificationServiceImpl implements EmailVerificationService {

    private static final Logger LOGGER = Logger.getLogger(EmailVerificationServiceImpl.class.getName());

    private static final int TOKEN_BYTE_LENGTH = 32;
    private static final long EXPIRATION_DURATION_MS = 24L * 60 * 60 * 1000; // 24 hours
    private static final long RESEND_COOLDOWN_MS = 60L * 1000; // 60 seconds

    private final EmailVerificationTokenDAO tokenDAO;
    private final EmailService emailService;
    private final SecureRandom secureRandom;

    public EmailVerificationServiceImpl() {
        this(new EmailVerificationTokenDAOImpl(), new SmtpEmailServiceImpl());
    }

    public EmailVerificationServiceImpl(EmailVerificationTokenDAO tokenDAO, EmailService emailService) {
        this.tokenDAO = tokenDAO;
        this.emailService = emailService;
        this.secureRandom = new SecureRandom();
    }

    @Override
    public String generateAndSaveToken(User user) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("Cannot generate verification token for null or unpersisted user.");
        }

        // Generate 32 cryptographically secure bytes
        byte[] randomBytes = new byte[TOKEN_BYTE_LENGTH];
        secureRandom.nextBytes(randomBytes);
        String rawToken = Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);

        // Compute SHA-256 hash for database persistence
        String tokenHash = hashToken(rawToken);
        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + EXPIRATION_DURATION_MS);

        EmailVerificationToken tokenEntity = new EmailVerificationToken(user.getId(), tokenHash, expiresAt);
        tokenDAO.save(tokenEntity);

        return rawToken;
    }

    @Override
    public boolean verifyToken(String rawToken) {
        if (rawToken == null || rawToken.trim().isEmpty()) {
            LOGGER.warning("Token verification attempted with null/empty token.");
            return false;
        }

        String tokenHash = hashToken(rawToken.trim());
        return tokenDAO.verifyTokenAndActivateUser(tokenHash);
    }

    @Override
    public boolean sendVerificationEmail(User user, String baseUrl) {
        if (user == null || user.getEmail() == null) {
            LOGGER.warning("Attempted to send verification email to null user/email.");
            return false;
        }

        String rawToken = generateAndSaveToken(user);

        // Resolve application base URL (env var override or parameter)
        String envBaseUrl = System.getenv("APP_BASE_URL");
        String finalBaseUrl = (envBaseUrl != null && !envBaseUrl.trim().isEmpty()) ? envBaseUrl.trim() : baseUrl;
        if (finalBaseUrl.endsWith("/")) {
            finalBaseUrl = finalBaseUrl.substring(0, finalBaseUrl.length() - 1);
        }

        String verificationUrl = finalBaseUrl + "/verify-email?token=" + rawToken;
        return emailService.sendVerificationEmail(user.getEmail(), user.getName(), verificationUrl);
    }

    @Override
    public boolean canResendVerification(Integer userId) {
        if (userId == null) return false;
        return getRemainingCooldownSeconds(userId) == 0;
    }

    @Override
    public long getRemainingCooldownSeconds(Integer userId) {
        if (userId == null) return 0;
        long elapsedSecs = tokenDAO.getSecondsSinceLastToken(userId);
        if (elapsedSecs >= 0 && elapsedSecs < (RESEND_COOLDOWN_MS / 1000)) {
            return (RESEND_COOLDOWN_MS / 1000) - elapsedSecs;
        }
        return 0;
    }

    /**
     * Hashes the raw token with SHA-256 to ensure raw tokens are never stored at rest.
     */
    private String hashToken(String rawToken) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(rawToken.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder(64);
            for (byte b : encodedHash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            LOGGER.log(Level.SEVERE, "SHA-256 algorithm unavailable", e);
            throw new RuntimeException("SHA-256 hashing algorithm not available", e);
        }
    }
}
