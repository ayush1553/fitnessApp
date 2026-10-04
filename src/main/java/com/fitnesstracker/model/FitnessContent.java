package com.fitnesstracker.model;

/**
 * Model representing user-submitted fitness guides, articles, and workouts.
 */
public class FitnessContent extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String title;
    private String description;
    private String category; // 'Workout Routines', 'Nutrition & Diet', 'Cardio & Endurance', 'Recovery & Wellness', 'Motivation'
    private String imageUrl;
    private String status; // 'PENDING', 'APPROVED', 'REJECTED'
    private String rejectionReason;

    // Transient author information
    private String authorName;
    private String authorEmail;

    public FitnessContent() {
        super();
        this.status = "PENDING";
        this.category = "Workout Routines";
    }

    public FitnessContent(Integer id, Integer userId, String title, String description, String category, String imageUrl, String status, String rejectionReason) {
        super(id);
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.category = category;
        this.imageUrl = imageUrl;
        this.status = status != null ? status : "PENDING";
        this.rejectionReason = rejectionReason;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getAuthorEmail() {
        return authorEmail;
    }

    public void setAuthorEmail(String authorEmail) {
        this.authorEmail = authorEmail;
    }
}
