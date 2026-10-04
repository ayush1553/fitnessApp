package com.fitnesstracker.dao;

import com.fitnesstracker.model.UserProfile;

import java.util.Optional;

public interface UserProfileDAO extends GenericDAO<UserProfile, Integer> {

    Optional<UserProfile> findByUserId(Integer userId);

    boolean saveOrUpdate(UserProfile profile);
}
