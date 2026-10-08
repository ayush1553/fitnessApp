package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.UserDAO;
import com.fitnesstracker.dao.UserProfileDAO;
import com.fitnesstracker.dao.impl.UserDAOImpl;
import com.fitnesstracker.dao.impl.UserProfileDAOImpl;
import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.exception.DuplicateResourceException;
import com.fitnesstracker.exception.UnauthorizedException;
import com.fitnesstracker.exception.UserNotFoundException;
import com.fitnesstracker.model.AdminUser;
import com.fitnesstracker.model.RegularUser;
import com.fitnesstracker.model.User;
import com.fitnesstracker.model.UserProfile;
import com.fitnesstracker.service.UserService;
import com.fitnesstracker.util.PasswordUtil;
import com.fitnesstracker.util.ValidationUtil;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class UserServiceImpl implements UserService {

    private final UserDAO userDAO;
    private final UserProfileDAO userProfileDAO;

    public UserServiceImpl() {
        this.userDAO = new UserDAOImpl();
        this.userProfileDAO = new UserProfileDAOImpl();
    }

    public UserServiceImpl(UserDAO userDAO, UserProfileDAO userProfileDAO) {
        this.userDAO = userDAO;
        this.userProfileDAO = userProfileDAO;
    }

    @Override
    public User register(String name, String email, String password) {
        if (!ValidationUtil.isNotEmpty(name) || !ValidationUtil.isValidEmail(email) || !ValidationUtil.isNotEmpty(password)) {
            throw new AppException("Invalid registration details. Please provide a valid name, email, and password.");
        }
        if (password.length() < 6) {
            throw new AppException("Password must be at least 6 characters long.");
        }
        if (userDAO.existsByEmail(email.toLowerCase().trim())) {
            throw new DuplicateResourceException("An account with email " + email + " already exists.");
        }

        String hashedPassword = PasswordUtil.hashPassword(password);
        RegularUser newUser = new RegularUser();
        newUser.setName(name.trim());
        newUser.setEmail(email.toLowerCase().trim());
        newUser.setPassword(hashedPassword);
        newUser.setStatus("ACTIVE");
        newUser.setEmailVerified(false);

        User savedUser = userDAO.save(newUser);

        // Create default profile for the user
        UserProfile defaultProfile = new UserProfile();
        defaultProfile.setUserId(savedUser.getId());
        defaultProfile.setFitnessGoal("Stay fit and active");
        defaultProfile.setActivityLevel("MODERATELY_ACTIVE");
        defaultProfile.setProfileImage("default-avatar.png");
        userProfileDAO.save(defaultProfile);

        savedUser.setProfile(defaultProfile);
        return savedUser;
    }

    @Override
    public User login(String email, String password) {
        if (!ValidationUtil.isValidEmail(email) || !ValidationUtil.isNotEmpty(password)) {
            throw new UnauthorizedException("Invalid email or password format.");
        }

        Optional<User> optUser = userDAO.findByEmail(email.toLowerCase().trim());
        if (optUser.isEmpty()) {
            throw new UnauthorizedException("Invalid email or password.");
        }

        User user = optUser.get();
        if (!user.isActive()) {
            throw new UnauthorizedException("Your account is currently " + user.getStatus().toLowerCase() + ". Please contact support.");
        }

        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            throw new UnauthorizedException("Invalid email or password.");
        }

        if (!user.isEmailVerified()) {
            throw new com.fitnesstracker.exception.UnverifiedEmailException(user.getEmail());
        }

        // Attach profile
        userProfileDAO.findByUserId(user.getId()).ifPresent(user::setProfile);
        return user;
    }

    @Override
    public Optional<User> getUserById(Integer userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        userOpt.ifPresent(u -> userProfileDAO.findByUserId(u.getId()).ifPresent(u::setProfile));
        return userOpt;
    }

    @Override
    public Optional<User> getUserByEmail(String email) {
        if (!ValidationUtil.isValidEmail(email)) {
            return Optional.empty();
        }
        Optional<User> userOpt = userDAO.findByEmail(email.toLowerCase().trim());
        userOpt.ifPresent(u -> userProfileDAO.findByUserId(u.getId()).ifPresent(u::setProfile));
        return userOpt;
    }

    @Override
    public Optional<UserProfile> getUserProfile(Integer userId) {
        return userProfileDAO.findByUserId(userId);
    }

    @Override
    public boolean updateProfile(Integer userId, String name, Integer age, Double heightCm, Double weightKg, String fitnessGoal, String activityLevel, String profileImage) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) {
            throw new UserNotFoundException("User ID " + userId + " not found.");
        }

        User user = userOpt.get();
        if (ValidationUtil.isNotEmpty(name)) {
            user.setName(name.trim());
            userDAO.update(user);
        }

        UserProfile profile = userProfileDAO.findByUserId(userId).orElse(new UserProfile());
        profile.setUserId(userId);
        profile.setAge(age);
        if (heightCm != null) profile.setHeightCm(BigDecimal.valueOf(heightCm));
        if (weightKg != null) profile.setWeightKg(BigDecimal.valueOf(weightKg));
        if (ValidationUtil.isNotEmpty(fitnessGoal)) profile.setFitnessGoal(fitnessGoal.trim());
        if (ValidationUtil.isNotEmpty(activityLevel)) profile.setActivityLevel(activityLevel.trim());
        if (ValidationUtil.isNotEmpty(profileImage)) profile.setProfileImage(profileImage.trim());

        return userProfileDAO.saveOrUpdate(profile);
    }

    @Override
    public boolean changePassword(Integer userId, String currentPassword, String newPassword) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) {
            throw new UserNotFoundException("User not found.");
        }
        User user = userOpt.get();
        if (!PasswordUtil.verifyPassword(currentPassword, user.getPassword())) {
            throw new AppException("Current password is incorrect.");
        }
        if (newPassword == null || newPassword.length() < 6) {
            throw new AppException("New password must be at least 6 characters long.");
        }
        String newHash = PasswordUtil.hashPassword(newPassword);
        return userDAO.updatePassword(userId, newHash);
    }

    @Override
    public List<User> getAllUsers() {
        List<User> users = userDAO.findAll();
        for (User u : users) {
            userProfileDAO.findByUserId(u.getId()).ifPresent(u::setProfile);
        }
        return users;
    }

    @Override
    public List<User> searchUsers(String query, String role, String status) {
        List<User> users = userDAO.searchUsers(query, role, status);
        for (User u : users) {
            userProfileDAO.findByUserId(u.getId()).ifPresent(u::setProfile);
        }
        return users;
    }

    @Override
    public boolean updateUserStatus(Integer userId, String status) {
        return userDAO.updateStatus(userId, status);
    }

    @Override
    public boolean updateUserRole(Integer userId, String role) {
        return userDAO.updateRole(userId, role);
    }

    @Override
    public boolean deleteUser(Integer userId) {
        return userDAO.delete(userId);
    }

    @Override
    public int getTotalUserCount() {
        return userDAO.countTotalUsers();
    }

    @Override
    public int getActiveUserCount() {
        return userDAO.countActiveUsers();
    }

    @Override
    public Map<String, Integer> getMonthlyRegistrationTrends() {
        return userDAO.getRegistrationStatsByMonth();
    }
}
