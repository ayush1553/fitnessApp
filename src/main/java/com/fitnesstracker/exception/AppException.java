package com.fitnesstracker.exception;

/**
 * Base unchecked exception for the Fitness Tracker application.
 */
public class AppException extends RuntimeException {
    public AppException(String message) {
        super(message);
    }

    public AppException(String message, Throwable cause) {
        super(message, cause);
    }
}
