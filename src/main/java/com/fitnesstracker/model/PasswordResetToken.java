package com.fitnesstracker.model;

import java.sql.Timestamp;

/**
 * Domain entity representing a secure password reset token.
 */
public class PasswordResetToken extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String tokenHash;
    private Timestamp expiresAt;
    private Timestamp usedAt;

    public PasswordResetToken() {
        super();
    }

    public PasswordResetToken(Integer userId, String tokenHash, Timestamp expiresAt) {
        super();
        this.userId = userId;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
    }

    public PasswordResetToken(Integer id, Integer userId, String tokenHash, Timestamp expiresAt, Timestamp createdAt, Timestamp usedAt) {
        super(id);
        this.userId = userId;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
        this.createdAt = createdAt;
        this.usedAt = usedAt;
    }

    public boolean isExpired() {
        return expiresAt != null && expiresAt.before(new Timestamp(System.currentTimeMillis()));
    }

    public boolean isUsed() {
        return usedAt != null;
    }

    public boolean isValid() {
        return !isExpired() && !isUsed();
    }

    // Getters and Setters
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getTokenHash() {
        return tokenHash;
    }

    public void setTokenHash(String tokenHash) {
        this.tokenHash = tokenHash;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public Timestamp getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(Timestamp usedAt) {
        this.usedAt = usedAt;
    }

    @Override
    public String toString() {
        return "PasswordResetToken{" +
                "id=" + id +
                ", userId=" + userId +
                ", tokenHash='[PROTECTED]'" +
                ", expiresAt=" + expiresAt +
                ", createdAt=" + createdAt +
                ", usedAt=" + usedAt +
                '}';
    }
}
