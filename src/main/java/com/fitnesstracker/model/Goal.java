package com.fitnesstracker.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * Model representing user-defined fitness targets and progress milestones.
 */
public class Goal extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String title;
    private String description;
    private BigDecimal targetValue;
    private BigDecimal currentValue;
    private String unit;
    private Date deadline;
    private String status; // IN_PROGRESS, COMPLETED, EXPIRED, CANCELLED

    public Goal() {
        super();
        this.currentValue = BigDecimal.ZERO;
        this.status = "IN_PROGRESS";
        this.unit = "km";
    }

    public Goal(Integer id, Integer userId, String title, String description, BigDecimal targetValue, BigDecimal currentValue, String unit, Date deadline, String status) {
        super(id);
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.targetValue = targetValue;
        this.currentValue = currentValue != null ? currentValue : BigDecimal.ZERO;
        this.unit = unit;
        this.deadline = deadline;
        this.status = status != null ? status : "IN_PROGRESS";
    }

    public int getProgressPercentage() {
        if (targetValue == null || targetValue.compareTo(BigDecimal.ZERO) <= 0) {
            return 0;
        }
        if (currentValue == null) {
            return 0;
        }
        BigDecimal pct = currentValue.divide(targetValue, 4, RoundingMode.HALF_UP)
                                     .multiply(BigDecimal.valueOf(100));
        int val = pct.intValue();
        return Math.min(val, 100);
    }

    public boolean isCompleted() {
        return "COMPLETED".equalsIgnoreCase(this.status) || getProgressPercentage() >= 100;
    }

    public long getDaysRemaining() {
        if (deadline == null) return 0;
        LocalDate today = LocalDate.now();
        LocalDate due = deadline.toLocalDate();
        return ChronoUnit.DAYS.between(today, due);
    }

    // Getters and Setters
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

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

    public BigDecimal getTargetValue() {
        return targetValue;
    }

    public void setTargetValue(BigDecimal targetValue) {
        this.targetValue = targetValue;
    }

    public BigDecimal getCurrentValue() {
        return currentValue;
    }

    public void setCurrentValue(BigDecimal currentValue) {
        this.currentValue = currentValue;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
