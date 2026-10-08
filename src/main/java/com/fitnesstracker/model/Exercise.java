package com.fitnesstracker.model;

/**
 * Model representing an exercise in the Fitness Learning Hub exercise library.
 */
public class Exercise extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private String name;
    private String slug;
    private String category; // 'Chest', 'Back', 'Shoulders', 'Arms', 'Legs', 'Core', 'Full Body', 'Mobility'
    private String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
    private String equipment; // 'No Equipment', 'Dumbbells', 'Barbell', 'Cable Machine', etc.
    private String targetMuscles;
    private String secondaryMuscles;
    private String description;
    private String instructions;
    private String commonMistakes;
    private String formTips;
    private String safetyTips;
    private Integer defaultSets;
    private String defaultReps;
    private Integer defaultDurationSeconds;
    private Integer restTimeSeconds;
    private String videoUrl;
    private String thumbnailUrl;
    private String status; // 'ACTIVE', 'INACTIVE'

    public Exercise() {
        super();
        this.category = "Core";
        this.difficulty = "Beginner";
        this.equipment = "No Equipment";
        this.defaultSets = 3;
        this.defaultReps = "10-12 reps";
        this.defaultDurationSeconds = 30;
        this.restTimeSeconds = 60;
        this.status = "ACTIVE";
    }

    public Exercise(Integer id, String name, String slug, String category, String difficulty,
                    String equipment, String targetMuscles, String secondaryMuscles,
                    String description, String instructions, String commonMistakes,
                    String formTips, String safetyTips, Integer defaultSets, String defaultReps,
                    Integer defaultDurationSeconds, Integer restTimeSeconds, String videoUrl,
                    String thumbnailUrl, String status) {
        super(id);
        this.name = name;
        this.slug = slug;
        this.category = category;
        this.difficulty = difficulty;
        this.equipment = equipment;
        this.targetMuscles = targetMuscles;
        this.secondaryMuscles = secondaryMuscles;
        this.description = description;
        this.instructions = instructions;
        this.commonMistakes = commonMistakes;
        this.formTips = formTips;
        this.safetyTips = safetyTips;
        this.defaultSets = defaultSets;
        this.defaultReps = defaultReps;
        this.defaultDurationSeconds = defaultDurationSeconds;
        this.restTimeSeconds = restTimeSeconds;
        this.videoUrl = videoUrl;
        this.thumbnailUrl = thumbnailUrl;
        this.status = status != null ? status : "ACTIVE";
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDifficulty() {
        return difficulty != null ? difficulty : "Beginner";
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public String getEquipment() {
        return equipment != null ? equipment : "No Equipment";
    }

    public void setEquipment(String equipment) {
        this.equipment = equipment;
    }

    public String getTargetMuscles() {
        return targetMuscles;
    }

    public void setTargetMuscles(String targetMuscles) {
        this.targetMuscles = targetMuscles;
    }

    public String getSecondaryMuscles() {
        return secondaryMuscles;
    }

    public void setSecondaryMuscles(String secondaryMuscles) {
        this.secondaryMuscles = secondaryMuscles;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    public String getCommonMistakes() {
        return commonMistakes;
    }

    public void setCommonMistakes(String commonMistakes) {
        this.commonMistakes = commonMistakes;
    }

    public String getFormTips() {
        return formTips;
    }

    public void setFormTips(String formTips) {
        this.formTips = formTips;
    }

    public String getSafetyTips() {
        return safetyTips;
    }

    public void setSafetyTips(String safetyTips) {
        this.safetyTips = safetyTips;
    }

    public Integer getDefaultSets() {
        return defaultSets != null ? defaultSets : 3;
    }

    public void setDefaultSets(Integer defaultSets) {
        this.defaultSets = defaultSets;
    }

    public String getDefaultReps() {
        return defaultReps != null ? defaultReps : "10-12 reps";
    }

    public void setDefaultReps(String defaultReps) {
        this.defaultReps = defaultReps;
    }

    public Integer getDefaultDurationSeconds() {
        return defaultDurationSeconds != null ? defaultDurationSeconds : 30;
    }

    public void setDefaultDurationSeconds(Integer defaultDurationSeconds) {
        this.defaultDurationSeconds = defaultDurationSeconds;
    }

    public Integer getRestTimeSeconds() {
        return restTimeSeconds != null ? restTimeSeconds : 60;
    }

    public void setRestTimeSeconds(Integer restTimeSeconds) {
        this.restTimeSeconds = restTimeSeconds;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public String getThumbnailUrl() {
        if (thumbnailUrl != null && !thumbnailUrl.trim().isEmpty()) {
            return thumbnailUrl;
        }
        return getDefaultThumbnail();
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getDefaultThumbnail() {
        if (category == null) return "assets/images/content/strength-training.webp";
        switch (category.trim()) {
            case "Core":
            case "Full Body":
                return "assets/images/content/cardio.webp";
            case "Mobility":
                return "assets/images/content/mobility.webp";
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
}
