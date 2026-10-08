package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.UserPreferencesDAO;
import com.fitnesstracker.dao.impl.UserPreferencesDAOImpl;
import com.fitnesstracker.model.UserPreferences;
import com.fitnesstracker.service.UserPreferencesService;

import java.util.Arrays;
import java.util.List;

/**
 * Implementation of UserPreferencesService providing preference validation, defaults, and persistence.
 */
public class UserPreferencesServiceImpl implements UserPreferencesService {

    private final UserPreferencesDAO preferencesDAO;

    private static final List<String> VALID_THEME_MODES = Arrays.asList("DARK", "LIGHT", "SYSTEM");
    private static final List<String> VALID_ACCENT_COLORS = Arrays.asList("LIME", "CYAN", "EMERALD", "PURPLE", "BLUE");
    private static final List<String> VALID_GLASS_INTENSITIES = Arrays.asList("SUBTLE", "MEDIUM", "STRONG");

    public UserPreferencesServiceImpl() {
        this.preferencesDAO = new UserPreferencesDAOImpl();
    }

    public UserPreferencesServiceImpl(UserPreferencesDAO preferencesDAO) {
        this.preferencesDAO = preferencesDAO;
    }

    @Override
    public UserPreferences getByUserId(int userId) {
        UserPreferences pref = preferencesDAO.getByUserId(userId);
        if (pref == null) {
            return getDefaultPreferences(userId);
        }
        return pref;
    }

    @Override
    public UserPreferences saveOrUpdate(UserPreferences preferences) {
        if (preferences == null) {
            throw new IllegalArgumentException("User preferences cannot be null");
        }

        // Sanitize and validate theme mode
        String mode = preferences.getThemeMode() != null ? preferences.getThemeMode().toUpperCase().trim() : "DARK";
        if (!VALID_THEME_MODES.contains(mode)) {
            mode = "DARK";
        }
        preferences.setThemeMode(mode);

        // Sanitize and validate accent color
        String accent = preferences.getAccentColor() != null ? preferences.getAccentColor().toUpperCase().trim() : "LIME";
        if (!VALID_ACCENT_COLORS.contains(accent)) {
            accent = "LIME";
        }
        preferences.setAccentColor(accent);

        // Sanitize and validate glass intensity
        String glass = preferences.getGlassIntensity() != null ? preferences.getGlassIntensity().toUpperCase().trim() : "MEDIUM";
        if (!VALID_GLASS_INTENSITIES.contains(glass)) {
            glass = "MEDIUM";
        }
        preferences.setGlassIntensity(glass);

        preferencesDAO.save(preferences);
        return getByUserId(preferences.getUserId());
    }

    @Override
    public UserPreferences resetToDefault(int userId) {
        UserPreferences defaultPref = getDefaultPreferences(userId);
        preferencesDAO.save(defaultPref);
        return defaultPref;
    }

    @Override
    public UserPreferences getDefaultPreferences(int userId) {
        UserPreferences defaultPref = new UserPreferences(userId);
        defaultPref.setThemeMode("DARK");
        defaultPref.setAccentColor("LIME");
        defaultPref.setGlassIntensity("MEDIUM");
        defaultPref.setAnimationsEnabled(true);
        defaultPref.setCompactMode(false);
        return defaultPref;
    }
}
