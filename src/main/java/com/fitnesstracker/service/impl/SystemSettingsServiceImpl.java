package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.SystemSettingsDAO;
import com.fitnesstracker.dao.impl.SystemSettingsDAOImpl;
import com.fitnesstracker.service.SystemSettingsService;

import java.util.Map;

public class SystemSettingsServiceImpl implements SystemSettingsService {

    private final SystemSettingsDAO settingsDAO;

    public SystemSettingsServiceImpl() {
        this.settingsDAO = new SystemSettingsDAOImpl();
    }

    public SystemSettingsServiceImpl(SystemSettingsDAO settingsDAO) {
        this.settingsDAO = settingsDAO;
    }

    @Override
    public Map<String, String> getAllSettings() {
        return settingsDAO.getAllSettings();
    }

    @Override
    public String getSetting(String key, String defaultValue) {
        return settingsDAO.getSettingValue(key).orElse(defaultValue);
    }

    @Override
    public boolean isRegistrationAllowed() {
        return "true".equalsIgnoreCase(getSetting("allow_registration", "true"));
    }

    @Override
    public boolean isChallengesEnabled() {
        return "true".equalsIgnoreCase(getSetting("challenges_enabled", "true"));
    }

    @Override
    public boolean isContentModerationEnabled() {
        return "true".equalsIgnoreCase(getSetting("content_moderation", "true"));
    }

    @Override
    public int getMaxChallengeDurationDays() {
        try {
            return Integer.parseInt(getSetting("max_challenge_days", "60"));
        } catch (NumberFormatException e) {
            return 60;
        }
    }

    @Override
    public boolean updateSettings(Map<String, String> settings) {
        return settingsDAO.updateSettings(settings);
    }
}
