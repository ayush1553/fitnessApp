package com.fitnesstracker.dao;

import com.fitnesstracker.model.UserPreferences;

/**
 * Data Access Object interface for user theme and UI preferences.
 */
public interface UserPreferencesDAO {

    /**
     * Retrieve preferences for a given user ID.
     * @param userId the user's ID
     * @return UserPreferences object or null if not found
     */
    UserPreferences getByUserId(int userId);

    /**
     * Insert new user preferences into the database.
     * @param preferences the preferences to persist
     * @return true if successful, false otherwise
     */
    boolean save(UserPreferences preferences);

    /**
     * Update existing user preferences in the database.
     * @param preferences the updated preferences
     * @return true if successful, false otherwise
     */
    boolean update(UserPreferences preferences);

    /**
     * Delete user preferences for a given user ID.
     * @param userId the user's ID
     * @return true if successful, false otherwise
     */
    boolean delete(int userId);
}
