package com.fitnesstracker.service.impl;

import com.fitnesstracker.dao.ExerciseDAO;
import com.fitnesstracker.dao.impl.ExerciseDAOImpl;
import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.Exercise;
import com.fitnesstracker.service.ExerciseService;

import java.util.List;
import java.util.Locale;
import java.util.Optional;

public class ExerciseServiceImpl implements ExerciseService {

    private final ExerciseDAO exerciseDAO;

    public ExerciseServiceImpl() {
        this.exerciseDAO = new ExerciseDAOImpl();
    }

    public ExerciseServiceImpl(ExerciseDAO exerciseDAO) {
        this.exerciseDAO = exerciseDAO;
    }

    private String generateSlug(String name) {
        if (name == null) return "exercise-" + System.currentTimeMillis();
        return name.trim().toLowerCase(Locale.ENGLISH)
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-");
    }

    @Override
    public Exercise createExercise(String name, String category, String difficulty, String equipment,
                                    String targetMuscles, String secondaryMuscles, String description,
                                    String instructions, String commonMistakes, String formTips,
                                    Integer defaultSets, String defaultReps, Integer defaultDurationSeconds,
                                    String videoUrl, String thumbnailUrl) {
        if (name == null || name.trim().isEmpty()) {
            throw new AppException("Exercise name is required.");
        }
        if (category == null || category.trim().isEmpty()) {
            throw new AppException("Exercise category is required.");
        }
        if (targetMuscles == null || targetMuscles.trim().isEmpty()) {
            throw new AppException("Target muscles are required.");
        }
        if (instructions == null || instructions.trim().isEmpty()) {
            throw new AppException("Step-by-step instructions are required.");
        }

        String slug = generateSlug(name);
        Optional<Exercise> existing = exerciseDAO.findBySlug(slug);
        if (existing.isPresent()) {
            slug = slug + "-" + System.currentTimeMillis();
        }

        Exercise ex = new Exercise();
        ex.setName(name.trim());
        ex.setSlug(slug);
        ex.setCategory(category.trim());
        ex.setDifficulty(difficulty != null ? difficulty.trim() : "Beginner");
        ex.setEquipment(equipment != null && !equipment.trim().isEmpty() ? equipment.trim() : "Bodyweight");
        ex.setTargetMuscles(targetMuscles.trim());
        ex.setSecondaryMuscles(secondaryMuscles != null ? secondaryMuscles.trim() : null);
        ex.setDescription(description != null ? description.trim() : "");
        ex.setInstructions(instructions.trim());
        ex.setCommonMistakes(commonMistakes != null ? commonMistakes.trim() : null);
        ex.setFormTips(formTips != null ? formTips.trim() : null);
        ex.setDefaultSets(defaultSets != null && defaultSets > 0 ? defaultSets : 3);
        ex.setDefaultReps(defaultReps != null && !defaultReps.trim().isEmpty() ? defaultReps.trim() : "10-12 reps");
        ex.setDefaultDurationSeconds(defaultDurationSeconds != null && defaultDurationSeconds > 0 ? defaultDurationSeconds : 45);
        ex.setVideoUrl(videoUrl != null && !videoUrl.trim().isEmpty() ? videoUrl.trim() : null);
        ex.setThumbnailUrl(thumbnailUrl != null && !thumbnailUrl.trim().isEmpty() ? thumbnailUrl.trim() : null);
        ex.setStatus("ACTIVE");

        return exerciseDAO.save(ex);
    }

    @Override
    public boolean updateExercise(Integer id, String name, String category, String difficulty, String equipment,
                                   String targetMuscles, String secondaryMuscles, String description,
                                   String instructions, String commonMistakes, String formTips,
                                   Integer defaultSets, String defaultReps, Integer defaultDurationSeconds,
                                   String videoUrl, String thumbnailUrl, String status) {
        if (id == null) throw new AppException("Exercise ID is required.");
        Optional<Exercise> opt = exerciseDAO.findById(id);
        if (opt.isEmpty()) return false;

        Exercise ex = opt.get();
        if (name != null && !name.trim().isEmpty()) ex.setName(name.trim());
        if (category != null && !category.trim().isEmpty()) ex.setCategory(category.trim());
        if (difficulty != null && !difficulty.trim().isEmpty()) ex.setDifficulty(difficulty.trim());
        if (equipment != null && !equipment.trim().isEmpty()) ex.setEquipment(equipment.trim());
        if (targetMuscles != null && !targetMuscles.trim().isEmpty()) ex.setTargetMuscles(targetMuscles.trim());
        ex.setSecondaryMuscles(secondaryMuscles);
        if (description != null) ex.setDescription(description.trim());
        if (instructions != null && !instructions.trim().isEmpty()) ex.setInstructions(instructions.trim());
        ex.setCommonMistakes(commonMistakes);
        ex.setFormTips(formTips);
        if (defaultSets != null && defaultSets > 0) ex.setDefaultSets(defaultSets);
        if (defaultReps != null && !defaultReps.trim().isEmpty()) ex.setDefaultReps(defaultReps.trim());
        if (defaultDurationSeconds != null && defaultDurationSeconds > 0) ex.setDefaultDurationSeconds(defaultDurationSeconds);
        ex.setVideoUrl(videoUrl);
        ex.setThumbnailUrl(thumbnailUrl);
        if (status != null && !status.trim().isEmpty()) ex.setStatus(status.trim());

        return exerciseDAO.update(ex);
    }

    @Override
    public boolean deleteExercise(Integer id) {
        if (id == null) return false;
        return exerciseDAO.delete(id);
    }

    @Override
    public boolean toggleStatus(Integer id, String status) {
        if (id == null) return false;
        Optional<Exercise> opt = exerciseDAO.findById(id);
        if (opt.isEmpty()) return false;
        Exercise ex = opt.get();
        ex.setStatus(status != null ? status : ("ACTIVE".equalsIgnoreCase(ex.getStatus()) ? "INACTIVE" : "ACTIVE"));
        return exerciseDAO.update(ex);
    }

    @Override
    public Optional<Exercise> getExerciseById(Integer id) {
        if (id == null) return Optional.empty();
        return exerciseDAO.findById(id);
    }

    @Override
    public Optional<Exercise> getExerciseBySlug(String slug) {
        if (slug == null || slug.trim().isEmpty()) return Optional.empty();
        return exerciseDAO.findBySlug(slug.trim());
    }

    @Override
    public List<Exercise> getActiveExercises() {
        return exerciseDAO.findActiveExercises();
    }

    @Override
    public List<Exercise> getActiveExercisesByCategory(String category) {
        if (category == null || category.trim().isEmpty() || "ALL".equalsIgnoreCase(category.trim())) {
            return exerciseDAO.findActiveExercises();
        }
        return exerciseDAO.findActiveByCategory(category.trim());
    }

    @Override
    public List<Exercise> getActiveExercisesByCategoryAndDifficulty(String category, String difficulty) {
        if ((category == null || "ALL".equalsIgnoreCase(category.trim())) && (difficulty == null || "ALL".equalsIgnoreCase(difficulty.trim()))) {
            return exerciseDAO.findActiveExercises();
        }
        if (difficulty == null || "ALL".equalsIgnoreCase(difficulty.trim())) {
            return getActiveExercisesByCategory(category);
        }
        return exerciseDAO.findActiveByCategoryAndDifficulty(category.trim(), difficulty.trim());
    }

    @Override
    public List<Exercise> searchExercises(String query, String category) {
        return exerciseDAO.searchActiveExercises(query, category);
    }

    @Override
    public List<Exercise> getRelatedExercises(Integer exerciseId, String category, int limit) {
        return exerciseDAO.findRelatedExercises(exerciseId, category, limit);
    }

    @Override
    public List<Exercise> getAllExercisesAdmin() {
        return exerciseDAO.findAll();
    }

    @Override
    public int getTotalExerciseCount() {
        return exerciseDAO.countTotalExercises();
    }
}
