package com.fitnesstracker.dao;

import com.fitnesstracker.model.Exercise;

import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for Exercise entities.
 */
public interface ExerciseDAO extends GenericDAO<Exercise, Integer> {

    Optional<Exercise> findBySlug(String slug);

    List<Exercise> findActiveExercises();

    List<Exercise> findActiveByCategory(String category);

    List<Exercise> findActiveByCategoryAndDifficulty(String category, String difficulty);

    List<Exercise> searchActiveExercises(String query, String category);

    List<Exercise> findRelatedExercises(Integer exerciseId, String category, int limit);

    int countTotalExercises();
}
