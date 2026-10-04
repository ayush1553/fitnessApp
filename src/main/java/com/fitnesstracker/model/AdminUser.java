package com.fitnesstracker.model;

/**
 * Concrete implementation of an Administrator with elevated system privileges.
 */
public class AdminUser extends User {
    private static final long serialVersionUID = 1L;

    public AdminUser() {
        super();
        this.role = "ADMIN";
        this.status = "ACTIVE";
    }

    public AdminUser(Integer id, String name, String email, String password, String status) {
        super(id, name, email, password, "ADMIN", status);
    }

    @Override
    public String getRoleName() {
        return "System Administrator";
    }

    @Override
    public String getDashboardRoute() {
        return "/admin/dashboard";
    }

    @Override
    public boolean canPerformAdminActions() {
        return true;
    }

    @Override
    public double calculateDailyCalorieRecommendation() {
        return 2400.0;
    }
}
