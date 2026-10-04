package com.fitnesstracker.model;

/**
 * Factory pattern implementation for instantiating polymorphic FitnessActivity objects.
 */
public class WorkoutFactory {

    public static FitnessActivity createActivity(String type) {
        if (type == null) {
            return new RunningActivity();
        }
        switch (type.trim().toLowerCase()) {
            case "running":
                return new RunningActivity();
            case "cycling":
                return new CyclingActivity();
            case "gym":
            case "strength training":
                return new GymActivity();
            case "swimming":
                return new SwimmingActivity();
            case "yoga":
            case "walking":
                return new YogaActivity();
            default:
                return new RunningActivity();
        }
    }
}
