package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.FitnessContentDAO;
import com.fitnesstracker.dao.impl.FitnessContentDAOImpl;
import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.FitnessContent;
import com.fitnesstracker.service.FitnessContentService;
import com.fitnesstracker.util.ValidationUtil;

import java.util.List;
import java.util.Optional;

public class FitnessContentServiceImpl implements FitnessContentService {

    private final FitnessContentDAO contentDAO;

    public FitnessContentServiceImpl() {
        this.contentDAO = new FitnessContentDAOImpl();
    }

    public FitnessContentServiceImpl(FitnessContentDAO contentDAO) {
        this.contentDAO = contentDAO;
    }

    @Override
    public FitnessContent submitContent(Integer userId, String title, String description, String category, String imageUrl) {
        if (!ValidationUtil.isNotEmpty(title)) {
            throw new AppException("Content title is required.");
        }
        if (!ValidationUtil.isNotEmpty(description)) {
            throw new AppException("Content description/body is required.");
        }

        FitnessContent content = new FitnessContent();
        content.setUserId(userId);
        content.setTitle(title.trim());
        content.setDescription(description.trim());
        content.setCategory(ValidationUtil.isNotEmpty(category) ? category.trim() : "Workout Routines");
        content.setImageUrl(imageUrl);
        content.setStatus("PENDING");

        return contentDAO.save(content);
    }

    @Override
    public boolean approveContent(Integer contentId) {
        return contentDAO.updateStatus(contentId, "APPROVED", null);
    }

    @Override
    public boolean rejectContent(Integer contentId, String rejectionReason) {
        return contentDAO.updateStatus(contentId, "REJECTED", rejectionReason);
    }

    @Override
    public boolean deleteContent(Integer contentId) {
        return contentDAO.delete(contentId);
    }

    @Override
    public Optional<FitnessContent> getContentById(Integer contentId) {
        return contentDAO.findById(contentId);
    }

    @Override
    public List<FitnessContent> getApprovedContent() {
        return contentDAO.findApprovedContent();
    }

    @Override
    public List<FitnessContent> getApprovedContentByCategory(String category) {
        return contentDAO.findApprovedByCategory(category);
    }

    @Override
    public List<FitnessContent> getPendingSubmissions() {
        return contentDAO.findPendingContent();
    }

    @Override
    public List<FitnessContent> getAllSubmissions() {
        return contentDAO.findAll();
    }

    @Override
    public List<FitnessContent> getUserSubmissions(Integer userId) {
        return contentDAO.findByUserId(userId);
    }

    @Override
    public int getPendingContentCount() {
        return contentDAO.countPendingContent();
    }
}
