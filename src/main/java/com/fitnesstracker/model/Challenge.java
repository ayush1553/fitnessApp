package com.fitnesstracker.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * Model representing a community fitness challenge.
 */
public class Challenge extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private String title;
    private String description;
    private String category;
    private BigDecimal targetValue;
    private String unit;
    private Date startDate;
    private Date endDate;
    private String status; // UPCOMING, ACTIVE, COMPLETED, ARCHIVED

    // Auxiliary stats for display
    private int participantCount;
    private boolean isUserJoined;
    private ChallengeParticipant userParticipation;

    public Challenge() {
        super();
        this.category = "General";
        this.unit = "KM";
        this.status = "ACTIVE";
    }

    public Challenge(Integer id, String title, String description, String category, BigDecimal targetValue, String unit, Date startDate, Date endDate, String status) {
        super(id);
        this.title = title;
        this.description = description;
        this.category = category;
        this.targetValue = targetValue;
        this.unit = unit;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status != null ? status : "ACTIVE";
    }

    public long getDaysRemaining() {
        if (endDate == null) return 0;
        LocalDate today = LocalDate.now();
        LocalDate end = endDate.toLocalDate();
        long diff = ChronoUnit.DAYS.between(today, end);
        return Math.max(0, diff);
    }

    public boolean isExpired() {
        if (endDate == null) return false;
        return LocalDate.now().isAfter(endDate.toLocalDate());
    }

    // Getters and Setters
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public BigDecimal getTargetValue() {
        return targetValue;
    }

    public void setTargetValue(BigDecimal targetValue) {
        this.targetValue = targetValue;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getParticipantCount() {
        return participantCount;
    }

    public void setParticipantCount(int participantCount) {
        this.participantCount = participantCount;
    }

    public boolean isUserJoined() {
        return isUserJoined;
    }

    public void setUserJoined(boolean userJoined) {
        isUserJoined = userJoined;
    }

    public ChallengeParticipant getUserParticipation() {
        return userParticipation;
    }

    public void setUserParticipation(ChallengeParticipant userParticipation) {
        this.userParticipation = userParticipation;
    }
}
