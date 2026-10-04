package com.fitnesstracker.service;

import java.util.Map;

public interface SystemSettingsService {

    Map<String, String> getAllSettings();

    String getSetting(String key, String defaultValue);

    boolean isRegistrationAllowed();

    boolean isChallengesEnabled();

    boolean isContentModerationEnabled();

    int getMaxChallengeDurationDays();

    boolean updateSettings(Map<String, String> settings);
}
