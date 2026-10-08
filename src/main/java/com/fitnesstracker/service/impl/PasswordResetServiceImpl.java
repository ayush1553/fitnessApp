package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.PasswordResetTokenDAO;
import com.fitnesstracker.dao.impl.PasswordResetTokenDAOImpl;
import com.fitnesstracker.model.PasswordResetToken;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.EmailService;
import com.fitnesstracker.service.PasswordResetService;
import com.fitnesstracker.util.PasswordUtil;

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
 * Production implementation of PasswordResetService.
 */
public class PasswordResetServiceImpl implements PasswordResetService {

    private static final Logger LOGGER = Logger.getLogger(PasswordResetServiceImpl.class.getName());

    private static final int TOKEN_BYTE_LENGTH = 32;
    private static final long EXPIRATION_DURATION_MS = 60L * 60 * 1000; // 1 hour
    private static final long RESET_COOLDOWN_MS = 60L * 1000; // 60 seconds

    private final PasswordResetTokenDAO tokenDAO;
    private final EmailService emailService;
    private final SecureRandom secureRandom;

    public PasswordResetServiceImpl() {
        this(new PasswordResetTokenDAOImpl(), new SmtpEmailServiceImpl());
    }

    public PasswordResetServiceImpl(PasswordResetTokenDAO tokenDAO, EmailService emailService) {
        this.tokenDAO = tokenDAO;
        this.emailService = emailService;
        this.secureRandom = new SecureRandom();
    }

    @Override
    public String generateAndSaveResetToken(User user) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("Cannot generate reset token for null or unpersisted user.");
        }

        byte[] randomBytes = new byte[TOKEN_BYTE_LENGTH];
        secureRandom.nextBytes(randomBytes);
        String rawToken = Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);

        String tokenHash = hashToken(rawToken);
        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + EXPIRATION_DURATION_MS);

        PasswordResetToken tokenEntity = new PasswordResetToken(user.getId(), tokenHash, expiresAt);
        tokenDAO.save(tokenEntity);

        return rawToken;
    }

    @Override
    public boolean validateResetToken(String rawToken) {
        if (rawToken == null || rawToken.trim().isEmpty()) {
            return false;
        }
        String tokenHash = hashToken(rawToken.trim());
        return tokenDAO.isTokenValid(tokenHash);
    }

    @Override
    public boolean resetPassword(String rawToken, String newPassword) {
        if (rawToken == null || rawToken.trim().isEmpty() || newPassword == null || newPassword.length() < 6) {
            return false;
        }

        String tokenHash = hashToken(rawToken.trim());
        String newHashedPassword = PasswordUtil.hashPassword(newPassword);

        return tokenDAO.resetPasswordWithToken(tokenHash, newHashedPassword);
    }

    @Override
    public boolean sendPasswordResetEmail(User user, String baseUrl) {
        if (user == null || user.getEmail() == null) {
            LOGGER.warning("Attempted to send password reset email to null user/email.");
            return false;
        }

        String rawToken = generateAndSaveResetToken(user);

        String envBaseUrl = System.getenv("APP_BASE_URL");
        String finalBaseUrl = (envBaseUrl != null && !envBaseUrl.trim().isEmpty()) ? envBaseUrl.trim() : baseUrl;
        if (finalBaseUrl.endsWith("/")) {
            finalBaseUrl = finalBaseUrl.substring(0, finalBaseUrl.length() - 1);
        }

        String resetUrl = finalBaseUrl + "/reset-password?token=" + rawToken;
        return emailService.sendPasswordResetEmail(user.getEmail(), user.getName(), resetUrl);
    }

    @Override
    public boolean canRequestPasswordReset(Integer userId) {
        if (userId == null) return false;
        return getRemainingCooldownSeconds(userId) == 0;
    }

    @Override
    public long getRemainingCooldownSeconds(Integer userId) {
        if (userId == null) return 0;
        long elapsedSecs = tokenDAO.getSecondsSinceLastToken(userId);
        if (elapsedSecs >= 0 && elapsedSecs < (RESET_COOLDOWN_MS / 1000)) {
            return (RESET_COOLDOWN_MS / 1000) - elapsedSecs;
        }
        return 0;
    }

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
