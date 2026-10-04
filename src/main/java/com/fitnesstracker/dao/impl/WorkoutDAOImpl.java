package com.fitnesstracker.dao.impl;

import com.fitnesstracker.config.DBConnection;
import com.fitnesstracker.dao.WorkoutDAO;
import com.fitnesstracker.exception.DatabaseException;
import com.fitnesstracker.model.Workout;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class WorkoutDAOImpl implements WorkoutDAO {

    private Workout mapRow(ResultSet rs) throws SQLException {
        Workout w = new Workout();
        w.setId(rs.getInt("id"));
        w.setUserId(rs.getInt("user_id"));
        w.setWorkoutType(rs.getString("workout_type"));
        w.setDurationMinutes(rs.getInt("duration_minutes"));
        w.setIntensity(rs.getString("intensity"));
        w.setCaloriesBurned(rs.getInt("calories_burned"));
        w.setWorkoutDate(rs.getDate("workout_date"));
        w.setNotes(rs.getString("notes"));
        w.setCreatedAt(rs.getTimestamp("created_at"));
        w.setUpdatedAt(rs.getTimestamp("updated_at"));
        return w;
    }

    @Override
    public Workout save(Workout workout) {
        String sql = "INSERT INTO workouts (user_id, workout_type, duration_minutes, intensity, calories_burned, workout_date, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, workout.getUserId());
            ps.setString(2, workout.getWorkoutType());
            ps.setInt(3, workout.getDurationMinutes());
            ps.setString(4, workout.getIntensity());
            ps.setInt(5, workout.getCaloriesBurned());
            ps.setDate(6, workout.getWorkoutDate());
            ps.setString(7, workout.getNotes());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) workout.setId(rs.getInt(1));
                }
            }
            return workout;
        } catch (SQLException e) {
            throw new DatabaseException("Error creating workout", e);
        }
    }

    @Override
    public boolean update(Workout workout) {
        String sql = "UPDATE workouts SET workout_type = ?, duration_minutes = ?, intensity = ?, calories_burned = ?, " +
                     "workout_date = ?, notes = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, workout.getWorkoutType());
            ps.setInt(2, workout.getDurationMinutes());
            ps.setString(3, workout.getIntensity());
            ps.setInt(4, workout.getCaloriesBurned());
            ps.setDate(5, workout.getWorkoutDate());
            ps.setString(6, workout.getNotes());
            ps.setInt(7, workout.getId());
            ps.setInt(8, workout.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error updating workout ID: " + workout.getId(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM workouts WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseException("Error deleting workout ID: " + id, e);
        }
    }

    @Override
    public Optional<Workout> findById(Integer id) {
        String sql = "SELECT * FROM workouts WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error retrieving workout by ID: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Workout> findAll() {
        List<Workout> list = new ArrayList<>();
        String sql = "SELECT * FROM workouts ORDER BY workout_date DESC, created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new DatabaseException("Error finding all workouts", e);
        }
        return list;
    }

    @Override
    public List<Workout> findByUserId(Integer userId) {
        List<Workout> list = new ArrayList<>();
        String sql = "SELECT * FROM workouts WHERE user_id = ? ORDER BY workout_date DESC, created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding workouts for user ID: " + userId, e);
        }
        return list;
    }

    @Override
    public List<Workout> findRecentByUserId(Integer userId, int limit) {
        List<Workout> list = new ArrayList<>();
        String sql = "SELECT * FROM workouts WHERE user_id = ? ORDER BY workout_date DESC, created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error finding recent workouts for user ID: " + userId, e);
        }
        return list;
    }

    @Override
    public List<Workout> findFilteredWorkouts(Integer userId, String type, String intensity, Date startDate, Date endDate, String sortBy, String sortDir) {
        List<Workout> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM workouts WHERE user_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (type != null && !type.trim().isEmpty() && !"ALL".equalsIgnoreCase(type)) {
            sql.append("AND workout_type = ? ");
            params.add(type.trim());
        }
        if (intensity != null && !intensity.trim().isEmpty() && !"ALL".equalsIgnoreCase(intensity)) {
            sql.append("AND intensity = ? ");
            params.add(intensity.trim());
        }
        if (startDate != null) {
            sql.append("AND workout_date >= ? ");
            params.add(startDate);
        }
        if (endDate != null) {
            sql.append("AND workout_date <= ? ");
            params.add(endDate);
        }

        String safeSort = "workout_date";
        if ("duration".equalsIgnoreCase(sortBy)) safeSort = "duration_minutes";
        else if ("calories".equalsIgnoreCase(sortBy)) safeSort = "calories_burned";
        else if ("type".equalsIgnoreCase(sortBy)) safeSort = "workout_type";

        String safeDir = "ASC".equalsIgnoreCase(sortDir) ? "ASC" : "DESC";

        sql.append("ORDER BY ").append(safeSort).append(" ").append(safeDir).append(", created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error filtering workouts", e);
        }
        return list;
    }

    @Override
    public int countTotalWorkouts() {
        String sql = "SELECT COUNT(*) FROM workouts";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            throw new DatabaseException("Error counting total workouts", e);
        }
        return 0;
    }

    @Override
    public int countWorkoutsByUserId(Integer userId) {
        String sql = "SELECT COUNT(*) FROM workouts WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error counting workouts for user: " + userId, e);
        }
        return 0;
    }

    @Override
    public int getTotalCaloriesBurnedByUserId(Integer userId) {
        String sql = "SELECT COALESCE(SUM(calories_burned), 0) FROM workouts WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error getting total calories burned", e);
        }
        return 0;
    }

    @Override
    public int getTotalDurationMinutesByUserId(Integer userId) {
        String sql = "SELECT COALESCE(SUM(duration_minutes), 0) FROM workouts WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error getting total duration minutes", e);
        }
        return 0;
    }

    @Override
    public Map<String, Integer> getWeeklyWorkoutDuration(Integer userId) {
        Map<String, Integer> map = new LinkedHashMap<>();
        // Past 7 days with day labels (Mon, Tue, etc.)
        String sql = "SELECT DATE_FORMAT(d.dt, '%a') AS day_name, d.dt, COALESCE(SUM(w.duration_minutes), 0) AS total_duration " +
                     "FROM (" +
                     "  SELECT CURDATE() - INTERVAL 6 DAY AS dt UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 5 DAY UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 4 DAY UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 3 DAY UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 2 DAY UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 1 DAY UNION ALL " +
                     "  SELECT CURDATE() " +
                     ") d " +
                     "LEFT JOIN workouts w ON w.workout_date = d.dt AND w.user_id = ? " +
                     "GROUP BY d.dt, day_name " +
                     "ORDER BY d.dt ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("day_name"), rs.getInt("total_duration"));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching weekly workout duration", e);
        }
        return map;
    }

    @Override
    public Map<String, Integer> getMonthlyWorkoutDuration(Integer userId) {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(workout_date, '%b') AS month_name, SUM(duration_minutes) AS total_duration " +
                     "FROM workouts " +
                     "WHERE user_id = ? AND workout_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                     "GROUP BY DATE_FORMAT(workout_date, '%b'), YEAR(workout_date), MONTH(workout_date) " +
                     "ORDER BY YEAR(workout_date) ASC, MONTH(workout_date) ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("month_name"), rs.getInt("total_duration"));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching monthly workout duration", e);
        }
        return map;
    }

    @Override
    public Map<String, Integer> getWeeklyCaloriesBurned(Integer userId) {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(d.dt, '%a') AS day_name, d.dt, COALESCE(SUM(w.calories_burned), 0) AS total_calories " +
                     "FROM (" +
                     "  SELECT CURDATE() - INTERVAL 6 DAY AS dt UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 5 DAY UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 4 DAY UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 3 DAY UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 2 DAY UNION ALL " +
                     "  SELECT CURDATE() - INTERVAL 1 DAY UNION ALL " +
                     "  SELECT CURDATE() " +
                     ") d " +
                     "LEFT JOIN workouts w ON w.workout_date = d.dt AND w.user_id = ? " +
                     "GROUP BY d.dt, day_name " +
                     "ORDER BY d.dt ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("day_name"), rs.getInt("total_calories"));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching weekly calories", e);
        }
        return map;
    }

    @Override
    public Map<String, Integer> getWorkoutTypeDistribution(Integer userId) {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT workout_type, COUNT(*) AS count FROM workouts WHERE user_id = ? GROUP BY workout_type ORDER BY count DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("workout_type"), rs.getInt("count"));
                }
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error fetching workout type distribution", e);
        }
        return map;
    }

    @Override
    public Map<String, Integer> getOverallWorkoutActivityStats() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT workout_type, COUNT(*) AS count FROM workouts GROUP BY workout_type ORDER BY count DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("workout_type"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Error getting overall activity stats", e);
        }
        return map;
    }
}
