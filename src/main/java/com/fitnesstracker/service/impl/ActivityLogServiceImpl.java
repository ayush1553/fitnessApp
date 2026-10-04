package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.ActivityLogDAO;
import com.fitnesstracker.dao.impl.ActivityLogDAOImpl;
import com.fitnesstracker.model.ActivityLog;
import com.fitnesstracker.service.ActivityLogService;

import java.util.List;

public class ActivityLogServiceImpl implements ActivityLogService {

    private final ActivityLogDAO logDAO;

    public ActivityLogServiceImpl() {
        this.logDAO = new ActivityLogDAOImpl();
    }

    public ActivityLogServiceImpl(ActivityLogDAO logDAO) {
        this.logDAO = logDAO;
    }

    @Override
    public void logActivity(Integer userId, String action, String details, String ipAddress) {
        try {
            logDAO.log(userId, action, details, ipAddress);
        } catch (Exception e) {
            System.err.println("Failed to log activity: " + e.getMessage());
        }
    }

    @Override
    public List<ActivityLog> getRecentLogs(int limit) {
        return logDAO.findRecentLogs(limit);
    }

    @Override
    public List<ActivityLog> getUserLogs(Integer userId, int limit) {
        return logDAO.findLogsByUserId(userId, limit);
    }
}
