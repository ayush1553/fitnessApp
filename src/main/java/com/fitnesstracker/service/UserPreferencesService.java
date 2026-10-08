package com.fitnesstracker.service;

import com.fitnesstracker.model.UserPreferences;

/**
 * Service interface managing user theme and visual preferences.
 */
public interface UserPreferencesService {

    /**
     * Retrieve preferences for a user, returning safe default preferences if none are recorded.
     * @param userId the user's ID
     * @return UserPreferences object
     */
    UserPreferences getByUserId(int userId);

    /**
     * Validate and save or update user preferences.
     * @param preferences UserPreferences object
     * @return saved UserPreferences object
     */
    UserPreferences saveOrUpdate(UserPreferences preferences);

    /**
     * Reset a user's theme settings to factory defaults (Dark, Lime, Medium Glass, Animations ON, Compact OFF).
     * @param userId the user's ID
     * @return default UserPreferences object persisted to database
     */
    UserPreferences resetToDefault(int userId);

    /**
     * Generate default UserPreferences object without persisting.
     * @param userId the user's ID
     * @return default UserPreferences
     */
    UserPreferences getDefaultPreferences(int userId);
}
