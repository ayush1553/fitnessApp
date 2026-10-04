package com.fitnesstracker.dao;

import com.fitnesstracker.model.SystemSetting;

import java.util.Map;
import java.util.Optional;

public interface SystemSettingsDAO {

    Map<String, String> getAllSettings();

    Optional<String> getSettingValue(String key);

    boolean updateSetting(String key, String value);

    boolean updateSettings(Map<String, String> settings);
}
