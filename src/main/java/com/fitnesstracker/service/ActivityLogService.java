package com.fitnesstracker.service;

import com.fitnesstracker.model.ActivityLog;

import java.util.List;

public interface ActivityLogService {

    void logActivity(Integer userId, String action, String details, String ipAddress);

    List<ActivityLog> getRecentLogs(int limit);

    List<ActivityLog> getUserLogs(Integer userId, int limit);
}
