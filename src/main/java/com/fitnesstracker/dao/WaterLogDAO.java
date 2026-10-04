package com.fitnesstracker.dao;

import com.fitnesstracker.model.WaterLog;

import java.sql.Date;
import java.util.List;

public interface WaterLogDAO extends GenericDAO<WaterLog, Integer> {
    List<WaterLog> findByUserIdAndDate(int userId, Date date);
    double getTotalWaterByUserIdAndDate(int userId, Date date);
    boolean deleteByUserIdAndDate(int userId, Date date);
}
