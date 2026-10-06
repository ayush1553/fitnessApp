package com.fitnesstracker.dao;

import com.fitnesstracker.model.FitnessContent;

import java.util.List;

public interface FitnessContentDAO extends GenericDAO<FitnessContent, Integer> {

    List<FitnessContent> findApprovedContent();

    List<FitnessContent> findApprovedByCategory(String category);

    List<FitnessContent> findRelatedContent(Integer contentId, String category, int limit);

    List<FitnessContent> searchApprovedContent(String query, String category);

    List<FitnessContent> findPendingContent();

    List<FitnessContent> findByUserId(Integer userId);

    boolean updateStatus(Integer contentId, String status, String rejectionReason);

    int countPendingContent();
}
