package com.fitnesstracker.exception;

/**
 * Thrown when an unverified user attempts to log in.
 */
public class UnverifiedEmailException extends AppException {
    private static final long serialVersionUID = 1L;

    private final String email;

    public UnverifiedEmailException(String email) {
        super("Your email address (" + email + ") is not verified yet. Please check your inbox or request a new verification link.");
        this.email = email;
    }

    public UnverifiedEmailException(String message, String email) {
        super(message);
        this.email = email;
    }

    public String getEmail() {
        return email;
    }
}
