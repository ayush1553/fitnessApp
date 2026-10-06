package com.fitnesstracker.service;

import com.fitnesstracker.model.FitnessContent;

import java.util.List;
import java.util.Optional;

public interface FitnessContentService {

    FitnessContent submitContent(Integer userId, String title, String description, String contentBody, String category, String imageUrl);

    FitnessContent submitContent(Integer userId, String title, String description, String category, String imageUrl);

    boolean approveContent(Integer contentId);

    boolean rejectContent(Integer contentId, String rejectionReason);

    boolean deleteContent(Integer contentId);

    Optional<FitnessContent> getContentById(Integer contentId);

    List<FitnessContent> getApprovedContent();

    List<FitnessContent> getApprovedContentByCategory(String category);

    List<FitnessContent> getRelatedContent(Integer contentId, String category, int limit);

    List<FitnessContent> searchApprovedContent(String query, String category);

    List<FitnessContent> getPendingSubmissions();

    List<FitnessContent> getAllSubmissions();

    List<FitnessContent> getUserSubmissions(Integer userId);

    int getPendingContentCount();
}
