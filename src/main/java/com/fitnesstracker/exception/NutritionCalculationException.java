package com.fitnesstracker.exception;

public class NutritionCalculationException extends RuntimeException {
    public NutritionCalculationException(String message) {
        super(message);
    }

    public NutritionCalculationException(String message, Throwable cause) {
        super(message, cause);
    }
}
