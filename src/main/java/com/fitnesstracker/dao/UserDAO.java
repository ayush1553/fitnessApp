package com.fitnesstracker.dao;

import com.fitnesstracker.model.User;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface UserDAO extends GenericDAO<User, Integer> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    boolean updatePassword(Integer userId, String newHashedPassword);

    boolean updateStatus(Integer userId, String status);

    boolean updateRole(Integer userId, String role);

    boolean updateEmailVerified(Integer userId, boolean emailVerified);

    int countTotalUsers();

    int countActiveUsers();

    Map<String, Integer> getRegistrationStatsByMonth();

    List<User> searchUsers(String query, String role, String status);
}
