package com.fitnesstracker.service;

import java.util.Map;

public interface AnalyticsService {

    Map<String, Object> getUserDashboardSummary(Integer userId);

    Map<String, Object> getUserProgressAnalytics(Integer userId);

    Map<String, Object> getAdminDashboardSummary();
}
