package com.fitnesstracker.dao;

import com.fitnesstracker.model.NutritionLog;

import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface NutritionLogDAO extends GenericDAO<NutritionLog, Integer> {
    List<NutritionLog> findByUserIdAndDate(int userId, Date date);
    List<NutritionLog> findByUserIdAndDateRange(int userId, Date startDate, Date endDate);
    Map<String, Integer> getDailyTotalMacros(int userId, Date date);
    List<Map<String, Object>> getDailyNutritionSummaryList(int userId, int days);
}
