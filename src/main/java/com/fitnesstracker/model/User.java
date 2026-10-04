package com.fitnesstracker.model;

import java.sql.Timestamp;

/**
 * Abstract User domain model showcasing OOP Encapsulation and Polymorphism.
 */
public abstract class User extends BaseEntity {
    private static final long serialVersionUID = 1L;

    protected String name;
    protected String email;
    protected String password;
    protected String role;
    protected String status;
    protected UserProfile profile;

    public User() {
        super();
    }

    public User(Integer id, String name, String email, String password, String role, String status) {
        super(id);
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.status = status;
    }

    // Abstract polymorphic methods to be customized by subclasses
    public abstract String getRoleName();
    public abstract String getDashboardRoute();
    public abstract boolean canPerformAdminActions();
    public abstract double calculateDailyCalorieRecommendation();

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public UserProfile getProfile() {
        return profile;
    }

    public void setProfile(UserProfile profile) {
        this.profile = profile;
    }

    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(this.status);
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
