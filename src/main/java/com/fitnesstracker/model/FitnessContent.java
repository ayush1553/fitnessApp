package com.fitnesstracker.model;

/**
 * Model representing user-submitted fitness guides, articles, and workouts.
 */
public class FitnessContent extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Integer userId;
    private String title;
    private String description;
    private String contentBody;
    private String category; // 'Workout Routines', 'Nutrition & Diet', 'Cardio & Endurance', 'Recovery & Wellness', 'Motivation'
    private String subcategory;
    private Integer readTimeMinutes;
    private String level;
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
        this.subcategory = "General";
        this.readTimeMinutes = 4;
        this.level = "All Levels";
    }

    public FitnessContent(Integer id, Integer userId, String title, String description, String contentBody, String category, String imageUrl, String status, String rejectionReason) {
        super(id);
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.contentBody = contentBody;
        this.category = category;
        this.imageUrl = imageUrl;
        this.status = status != null ? status : "PENDING";
        this.rejectionReason = rejectionReason;
    }

    public FitnessContent(Integer id, Integer userId, String title, String description, String category, String imageUrl, String status, String rejectionReason) {
        this(id, userId, title, description, null, category, imageUrl, status, rejectionReason);
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

    public String getContentBody() {
        return (contentBody != null && !contentBody.trim().isEmpty()) ? contentBody : description;
    }

    public void setContentBody(String contentBody) {
        this.contentBody = contentBody;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSubcategory() {
        return subcategory != null ? subcategory : "General";
    }

    public void setSubcategory(String subcategory) {
        this.subcategory = subcategory;
    }

    public Integer getReadTimeMinutes() {
        return readTimeMinutes != null ? readTimeMinutes : 4;
    }

    public void setReadTimeMinutes(Integer readTimeMinutes) {
        this.readTimeMinutes = readTimeMinutes;
    }

    public String getLevel() {
        return level != null ? level : "All Levels";
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getImageUrl() {
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            return imageUrl;
        }
        return getDefaultImageUrl();
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDefaultImageUrl() {
        if (category == null) return "assets/images/content/strength-training.webp";
        switch (category.trim()) {
            case "Nutrition & Diet":
                return "assets/images/content/protein-meal-prep.webp";
            case "Cardio & Endurance":
                return "assets/images/content/5k-running.webp";
            case "Recovery & Wellness":
                return "assets/images/content/mobility.webp";
            case "Motivation":
                return "assets/images/content/mental-fatigue.webp";
            case "Workout Routines":
            default:
                return "assets/images/content/strength-training.webp";
        }
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
