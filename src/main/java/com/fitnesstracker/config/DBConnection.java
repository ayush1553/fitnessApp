package com.fitnesstracker.config;

import com.fitnesstracker.exception.DatabaseException;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * High-performance JDBC Database Connection Utility.
 * Supports connection pooling via HikariCP with robust fallback to direct JDBC DriverManager.
 */
public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static String dbUrl = "jdbc:mysql://localhost:3306/fitness_tracker_db?useSSL=false&serverTimezone=Asia/Kolkata&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";
    private static String dbUser = "root";
    private static String dbPassword = "";
    private static String dbDriver = "com.mysql.cj.jdbc.Driver";

    private static HikariDataSource dataSource;
    private static boolean usePool = true;

    static {
        loadProperties();
        initDataSource();
    }

    private static void loadProperties() {
        try (InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                Properties props = new Properties();
                props.load(is);
                dbUrl = props.getProperty("db.url", dbUrl);
                dbUser = props.getProperty("db.user", dbUser);
                dbPassword = props.getProperty("db.password", dbPassword);
                dbDriver = props.getProperty("db.driver", dbDriver);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "db.properties not found or unreadable, using default configuration", e);
        }

        // Allow environment variable overrides
        String envUrl = System.getenv("FITNESS_DB_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) dbUrl = envUrl;

        String envUser = System.getenv("FITNESS_DB_USER");
        if (envUser != null && !envUser.trim().isEmpty()) dbUser = envUser;

        String envPass = System.getenv("FITNESS_DB_PASSWORD");
        if (envPass != null) dbPassword = envPass;
    }

    private static synchronized void initDataSource() {
        try {
            Class.forName(dbDriver);
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(dbUrl);
            config.setUsername(dbUser);
            config.setPassword(dbPassword);
            config.setDriverClassName(dbDriver);
            config.setMaximumPoolSize(15);
            config.setMinimumIdle(3);
            config.setIdleTimeout(30000);
            config.setConnectionTimeout(10000);
            config.setMaxLifetime(600000);
            config.setPoolName("FitnessTrackerHikariPool");

            dataSource = new HikariDataSource(config);
            usePool = true;
            LOGGER.info("HikariCP connection pool initialized successfully.");
        } catch (Throwable t) {
            LOGGER.log(Level.WARNING, "HikariCP initialization failed, falling back to direct DriverManager: " + t.getMessage());
            usePool = false;
        }
    }

    /**
     * Obtains a connection from the pool or direct DriverManager.
     */
    public static Connection getConnection() throws SQLException {
        if (usePool && dataSource != null && !dataSource.isClosed()) {
            try {
                return dataSource.getConnection();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to get pooled connection, trying DriverManager: " + e.getMessage());
            }
        }
        try {
            Class.forName(dbDriver);
            return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        } catch (ClassNotFoundException e) {
            throw new DatabaseException("MySQL JDBC Driver not found on classpath: " + dbDriver, e);
        }
    }

    /**
     * Closes ResultSet safely.
     */
    public static void close(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                LOGGER.log(Level.FINE, "Error closing ResultSet", e);
            }
        }
    }

    /**
     * Closes Statement safely.
     */
    public static void close(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                LOGGER.log(Level.FINE, "Error closing Statement", e);
            }
        }
    }

    /**
     * Closes Connection safely.
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.FINE, "Error closing Connection", e);
            }
        }
    }

    /**
     * Closes all resources safely in try-finally blocks.
     */
    public static void close(ResultSet rs, Statement stmt, Connection conn) {
        close(rs);
        close(stmt);
        close(conn);
    }
}
