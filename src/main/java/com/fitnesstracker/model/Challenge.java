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
    private String imageUrl;

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
        this(id, title, description, category, targetValue, unit, startDate, endDate, status, null);
    }

    public Challenge(Integer id, String title, String description, String category, BigDecimal targetValue, String unit, Date startDate, Date endDate, String status, String imageUrl) {
        super(id);
        this.title = title;
        this.description = description;
        this.category = category;
        this.targetValue = targetValue;
        this.unit = unit;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status != null ? status : "ACTIVE";
        this.imageUrl = imageUrl;
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

    public String getImageUrl() {
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            return imageUrl.trim();
        }
        return resolveDefaultImageUrl(this.category, this.title);
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    /**
     * Resolves appropriate challenge photograph asset based on category or title keywords.
     */
    public static String resolveDefaultImageUrl(String category, String title) {
        String cat = category != null ? category.toLowerCase() : "";
        String tit = title != null ? title.toLowerCase() : "";

        if (cat.contains("cardio") || cat.contains("run") || tit.contains("running") || tit.contains("run") || tit.contains("sprint")) {
            return "assets/images/challenges/running.jpg";
        }
        if (cat.contains("endurance") || cat.contains("hiit") || tit.contains("calorie") || tit.contains("crusher") || tit.contains("hiit") || tit.contains("battle")) {
            return "assets/images/challenges/hiit.jpg";
        }
        if (cat.contains("cycl") || tit.contains("cycling") || tit.contains("ride") || tit.contains("bike") || tit.contains("century")) {
            return "assets/images/challenges/cycling.jpg";
        }
        if (cat.contains("strength") || cat.contains("gym") || tit.contains("strength") || tit.contains("weight") || tit.contains("lift")) {
            return "assets/images/challenges/strength.jpg";
        }
        if (cat.contains("swim") || tit.contains("swim") || tit.contains("pool") || tit.contains("water")) {
            return "assets/images/challenges/swimming.jpg";
        }
        if (cat.contains("yoga") || cat.contains("mind") || tit.contains("yoga") || tit.contains("zen") || tit.contains("meditation")) {
            return "assets/images/challenges/yoga.jpg";
        }
        if (cat.contains("walk") || cat.contains("step") || tit.contains("walk") || tit.contains("step") || tit.contains("trail")) {
            return "assets/images/challenges/walking.jpg";
        }
        if (cat.contains("core") || tit.contains("core") || tit.contains("plank") || tit.contains("abs")) {
            return "assets/images/challenges/core.jpg";
        }
        if (cat.contains("flex") || cat.contains("stretch") || tit.contains("flexibility") || tit.contains("stretch")) {
            return "assets/images/challenges/flexibility.jpg";
        }
        return "assets/images/challenges/full-body.jpg";
    }

    /**
     * Meaningful and accessible alt text for screen readers & compliance.
     */
    public String getImageAltText() {
        String tit = title != null ? title : "Fitness Challenge";
        String cat = category != null ? category : "workout";
        return "Athlete participating in " + tit + " (" + cat + " category)";
    }

    public ChallengeParticipant getUserParticipation() {
        return userParticipation;
    }

    public void setUserParticipation(ChallengeParticipant userParticipation) {
        this.userParticipation = userParticipation;
    }
}
