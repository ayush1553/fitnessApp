package com.fitnesstracker.dao;

import com.fitnesstracker.model.ChallengeParticipant;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface ChallengeParticipantDAO extends GenericDAO<ChallengeParticipant, Integer> {

    Optional<ChallengeParticipant> findByUserAndChallenge(Integer userId, Integer challengeId);

    List<ChallengeParticipant> findByUserId(Integer userId);

    List<ChallengeParticipant> findActiveByUserId(Integer userId);

    List<ChallengeParticipant> findByChallengeId(Integer challengeId);

    boolean exists(Integer userId, Integer challengeId);

    boolean updateProgress(Integer participantId, BigDecimal newProgress);

    boolean markCompleted(Integer participantId);

    int countParticipants(Integer challengeId);

    int countCompletedChallengesByUserId(Integer userId);
}
