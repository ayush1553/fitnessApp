package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.ChallengeDAO;
import com.fitnesstracker.dao.ChallengeParticipantDAO;
import com.fitnesstracker.dao.impl.ChallengeDAOImpl;
import com.fitnesstracker.dao.impl.ChallengeParticipantDAOImpl;
import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.exception.DuplicateResourceException;
import com.fitnesstracker.model.Challenge;
import com.fitnesstracker.model.ChallengeParticipant;
import com.fitnesstracker.service.ChallengeService;
import com.fitnesstracker.util.ValidationUtil;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

public class ChallengeServiceImpl implements ChallengeService {

    private final ChallengeDAO challengeDAO;
    private final ChallengeParticipantDAO participantDAO;

    public ChallengeServiceImpl() {
        this.challengeDAO = new ChallengeDAOImpl();
        this.participantDAO = new ChallengeParticipantDAOImpl();
    }

    public ChallengeServiceImpl(ChallengeDAO challengeDAO, ChallengeParticipantDAO participantDAO) {
        this.challengeDAO = challengeDAO;
        this.participantDAO = participantDAO;
    }

    @Override
    public Challenge createChallenge(String title, String description, String category, BigDecimal targetValue, String unit, Date startDate, Date endDate) {
        if (!ValidationUtil.isNotEmpty(title)) {
            throw new AppException("Challenge title is required.");
        }
        if (targetValue == null || targetValue.compareTo(BigDecimal.ZERO) <= 0) {
            throw new AppException("Target value must be greater than zero.");
        }
        if (startDate == null || endDate == null) {
            throw new AppException("Start and end dates are required.");
        }
        if (endDate.before(startDate)) {
            throw new AppException("End date must be after start date.");
        }

        Challenge c = new Challenge();
        c.setTitle(title.trim());
        c.setDescription(description);
        c.setCategory(ValidationUtil.isNotEmpty(category) ? category.trim() : "General");
        c.setTargetValue(targetValue);
        c.setUnit(ValidationUtil.isNotEmpty(unit) ? unit.trim() : "KM");
        c.setStartDate(startDate);
        c.setEndDate(endDate);
        c.setStatus("ACTIVE");

        return challengeDAO.save(c);
    }

    @Override
    public boolean updateChallenge(Integer challengeId, String title, String description, String category, BigDecimal targetValue, String unit, Date startDate, Date endDate, String status) {
        Optional<Challenge> opt = challengeDAO.findById(challengeId);
        if (opt.isEmpty()) {
            throw new AppException("Challenge not found.");
        }

        Challenge c = opt.get();
        if (ValidationUtil.isNotEmpty(title)) c.setTitle(title.trim());
        c.setDescription(description);
        if (ValidationUtil.isNotEmpty(category)) c.setCategory(category.trim());
        if (targetValue != null && targetValue.compareTo(BigDecimal.ZERO) > 0) c.setTargetValue(targetValue);
        if (ValidationUtil.isNotEmpty(unit)) c.setUnit(unit.trim());
        if (startDate != null) c.setStartDate(startDate);
        if (endDate != null) c.setEndDate(endDate);
        if (ValidationUtil.isNotEmpty(status)) c.setStatus(status.trim());

        return challengeDAO.update(c);
    }

    @Override
    public boolean deleteChallenge(Integer challengeId) {
        return challengeDAO.delete(challengeId);
    }

    @Override
    public Optional<Challenge> getChallengeById(Integer challengeId) {
        return challengeDAO.findById(challengeId);
    }

    @Override
    public List<Challenge> getAllChallenges() {
        return challengeDAO.findAll();
    }

    @Override
    public List<Challenge> getActiveChallenges() {
        return challengeDAO.findActiveChallenges();
    }

    @Override
    public List<Challenge> getChallengesForUser(Integer userId) {
        return challengeDAO.findChallengesWithUserStatus(userId);
    }

    @Override
    public ChallengeParticipant joinChallenge(Integer userId, Integer challengeId) {
        Optional<Challenge> challengeOpt = challengeDAO.findById(challengeId);
        if (challengeOpt.isEmpty()) {
            throw new AppException("Challenge ID " + challengeId + " not found.");
        }

        if (participantDAO.exists(userId, challengeId)) {
            throw new DuplicateResourceException("You are already enrolled in this challenge.");
        }

        ChallengeParticipant cp = new ChallengeParticipant();
        cp.setUserId(userId);
        cp.setChallengeId(challengeId);
        cp.setProgress(BigDecimal.ZERO);
        cp.setStatus("IN_PROGRESS");
        cp.setJoinedDate(new Timestamp(System.currentTimeMillis()));

        return participantDAO.save(cp);
    }

    @Override
    public boolean updateParticipantProgress(Integer participantId, Integer userId, BigDecimal newProgress) {
        Optional<ChallengeParticipant> opt = participantDAO.findById(participantId);
        if (opt.isEmpty() || !opt.get().getUserId().equals(userId)) {
            throw new AppException("Participation record not found or access denied.");
        }
        return participantDAO.updateProgress(participantId, newProgress);
    }

    @Override
    public boolean leaveChallenge(Integer participantId, Integer userId) {
        Optional<ChallengeParticipant> opt = participantDAO.findById(participantId);
        if (opt.isEmpty() || !opt.get().getUserId().equals(userId)) {
            throw new AppException("Participation record not found or access denied.");
        }
        return participantDAO.delete(participantId);
    }

    @Override
    public List<ChallengeParticipant> getUserParticipations(Integer userId) {
        return participantDAO.findByUserId(userId);
    }

    @Override
    public List<ChallengeParticipant> getChallengeLeaderboard(Integer challengeId) {
        return participantDAO.findByChallengeId(challengeId);
    }

    @Override
    public int getActiveChallengeCount() {
        return challengeDAO.countActiveChallenges();
    }

    @Override
    public int getUserCompletedChallengesCount(Integer userId) {
        return participantDAO.countCompletedChallengesByUserId(userId);
    }
}
