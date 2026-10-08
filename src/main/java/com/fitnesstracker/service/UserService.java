package com.fitnesstracker.service;

import com.fitnesstracker.model.User;
import com.fitnesstracker.model.UserProfile;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface UserService {

    User register(String name, String email, String password);

    User login(String email, String password);

    Optional<User> getUserById(Integer userId);

    Optional<User> getUserByEmail(String email);

    Optional<UserProfile> getUserProfile(Integer userId);

    boolean updateProfile(Integer userId, String name, Integer age, Double heightCm, Double weightKg, String fitnessGoal, String activityLevel, String profileImage);

    boolean changePassword(Integer userId, String currentPassword, String newPassword);

    List<User> getAllUsers();

    List<User> searchUsers(String query, String role, String status);

    boolean updateUserStatus(Integer userId, String status);

    boolean updateUserRole(Integer userId, String role);

    boolean deleteUser(Integer userId);

    int getTotalUserCount();

    int getActiveUserCount();

    Map<String, Integer> getMonthlyRegistrationTrends();
}
