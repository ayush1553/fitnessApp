package com.fitnesstracker.service;

import com.fitnesstracker.model.Challenge;
import com.fitnesstracker.model.ChallengeParticipant;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Optional;

public interface ChallengeService {

    Challenge createChallenge(String title, String description, String category, BigDecimal targetValue, String unit, Date startDate, Date endDate);
    Challenge createChallenge(String title, String description, String category, BigDecimal targetValue, String unit, Date startDate, Date endDate, String imageUrl);

    boolean updateChallenge(Integer challengeId, String title, String description, String category, BigDecimal targetValue, String unit, Date startDate, Date endDate, String status);
    boolean updateChallenge(Integer challengeId, String title, String description, String category, BigDecimal targetValue, String unit, Date startDate, Date endDate, String status, String imageUrl);

    boolean deleteChallenge(Integer challengeId);

    Optional<Challenge> getChallengeById(Integer challengeId);

    List<Challenge> getAllChallenges();

    List<Challenge> getActiveChallenges();

    List<Challenge> getChallengesForUser(Integer userId);

    ChallengeParticipant joinChallenge(Integer userId, Integer challengeId);

    boolean updateParticipantProgress(Integer participantId, Integer userId, BigDecimal newProgress);

    boolean leaveChallenge(Integer participantId, Integer userId);

    List<ChallengeParticipant> getUserParticipations(Integer userId);

    List<ChallengeParticipant> getChallengeLeaderboard(Integer challengeId);

    int getActiveChallengeCount();

    int getUserCompletedChallengesCount(Integer userId);
}
