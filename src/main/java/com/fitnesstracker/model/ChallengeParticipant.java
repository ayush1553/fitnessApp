package com.fitnesstracker.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;

/**
 * Model representing user participation in a community challenge.
 */
public class ChallengeParticipant extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Integer userId;
    private Integer challengeId;
    private BigDecimal progress;
    private String status; // IN_PROGRESS, COMPLETED, DROPPED
    private Timestamp joinedDate;
    private Timestamp completedDate;

    // Associated presentation objects
    private User user;
    private Challenge challenge;

    public ChallengeParticipant() {
        super();
        this.progress = BigDecimal.ZERO;
        this.status = "IN_PROGRESS";
    }

    public ChallengeParticipant(Integer id, Integer userId, Integer challengeId, BigDecimal progress, String status, Timestamp joinedDate, Timestamp completedDate) {
        super(id);
        this.userId = userId;
        this.challengeId = challengeId;
        this.progress = progress != null ? progress : BigDecimal.ZERO;
        this.status = status != null ? status : "IN_PROGRESS";
        this.joinedDate = joinedDate;
        this.completedDate = completedDate;
    }

    public int getProgressPercentage() {
        if (challenge == null || challenge.getTargetValue() == null || challenge.getTargetValue().compareTo(BigDecimal.ZERO) <= 0) {
            return 0;
        }
        if (progress == null) {
            return 0;
        }
        BigDecimal pct = progress.divide(challenge.getTargetValue(), 4, RoundingMode.HALF_UP)
                                 .multiply(BigDecimal.valueOf(100));
        return Math.min(100, pct.intValue());
    }

    // Getters and Setters
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getChallengeId() {
        return challengeId;
    }

    public void setChallengeId(Integer challengeId) {
        this.challengeId = challengeId;
    }

    public BigDecimal getProgress() {
        return progress;
    }

    public void setProgress(BigDecimal progress) {
        this.progress = progress;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getJoinedDate() {
        return joinedDate;
    }

    public void setJoinedDate(Timestamp joinedDate) {
        this.joinedDate = joinedDate;
    }

    public Timestamp getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(Timestamp completedDate) {
        this.completedDate = completedDate;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Challenge getChallenge() {
        return challenge;
    }

    public void setChallenge(Challenge challenge) {
        this.challenge = challenge;
    }
}
