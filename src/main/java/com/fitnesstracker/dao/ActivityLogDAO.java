package com.fitnesstracker.dao;

import com.fitnesstracker.model.ActivityLog;

import java.util.List;

public interface ActivityLogDAO {

    boolean log(Integer userId, String action, String details, String ipAddress);

    List<ActivityLog> findRecentLogs(int limit);

    List<ActivityLog> findLogsByUserId(Integer userId, int limit);
}
