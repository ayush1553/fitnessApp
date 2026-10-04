package com.fitnesstracker.dao;

import com.fitnesstracker.model.Challenge;

import java.util.List;

public interface ChallengeDAO extends GenericDAO<Challenge, Integer> {

    List<Challenge> findActiveChallenges();

    List<Challenge> findChallengesWithUserStatus(Integer userId);

    int countActiveChallenges();

    boolean updateStatus(Integer challengeId, String status);
}
