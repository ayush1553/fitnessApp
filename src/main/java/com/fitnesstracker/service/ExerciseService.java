package com.fitnesstracker.service;

import com.fitnesstracker.model.Exercise;

import java.util.List;
import java.util.Optional;

/**
 * Service interface for Exercise library management.
 */
public interface ExerciseService {

    Exercise createExercise(String name, String category, String difficulty, String equipment,
                            String targetMuscles, String secondaryMuscles, String description,
                            String instructions, String commonMistakes, String formTips,
                            Integer defaultSets, String defaultReps, Integer defaultDurationSeconds,
                            String videoUrl, String thumbnailUrl);

    boolean updateExercise(Integer id, String name, String category, String difficulty, String equipment,
                           String targetMuscles, String secondaryMuscles, String description,
                           String instructions, String commonMistakes, String formTips,
                           Integer defaultSets, String defaultReps, Integer defaultDurationSeconds,
                           String videoUrl, String thumbnailUrl, String status);

    boolean deleteExercise(Integer id);

    boolean toggleStatus(Integer id, String status);

    Optional<Exercise> getExerciseById(Integer id);

    Optional<Exercise> getExerciseBySlug(String slug);

    List<Exercise> getActiveExercises();

    List<Exercise> getActiveExercisesByCategory(String category);

    List<Exercise> getActiveExercisesByCategoryAndDifficulty(String category, String difficulty);

    List<Exercise> searchExercises(String query, String category);

    List<Exercise> getRelatedExercises(Integer exerciseId, String category, int limit);

    List<Exercise> getAllExercisesAdmin();

    int getTotalExerciseCount();
}
