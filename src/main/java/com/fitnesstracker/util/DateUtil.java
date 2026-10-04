package com.fitnesstracker.util;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Date manipulation and formatting helper functions.
 */
public class DateUtil {

    private static final String DISPLAY_DATE_FORMAT = "MMM dd, yyyy";
    private static final String SQL_DATE_FORMAT = "yyyy-MM-dd";
    private static final String DISPLAY_TIME_FORMAT = "MMM dd, yyyy HH:mm";

    public static String formatDate(Date date) {
        if (date == null) return "N/A";
        return new SimpleDateFormat(DISPLAY_DATE_FORMAT).format(date);
    }

    public static String formatTimestamp(Timestamp ts) {
        if (ts == null) return "N/A";
        return new SimpleDateFormat(DISPLAY_TIME_FORMAT).format(ts);
    }

    public static Date parseSqlDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return new Date(System.currentTimeMillis());
        }
        try {
            return Date.valueOf(dateStr.trim());
        } catch (IllegalArgumentException e) {
            return new Date(System.currentTimeMillis());
        }
    }

    public static Date getCurrentSqlDate() {
        return new Date(System.currentTimeMillis());
    }

    public static String getCurrentDateFormatted() {
        return LocalDate.now().format(DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy"));
    }
}
