/**
 * FitFlow Pro - Workout Module Assistant
 * Handles dynamic MET estimation & edit modal binding
 */

// Base MET scores for activities
const ACTIVITY_METS = {
    'Running': 9.8,
    'Walking': 3.5,
    'Cycling': 7.5,
    'Swimming': 8.0,
    'Gym': 6.0,
    'Yoga': 3.0,
    'Strength Training': 6.0,
    'Other': 5.0
};

const INTENSITY_MULTIPLIERS = {
    'Low': 0.75,
    'Medium': 1.0,
    'High': 1.35
};

function autoCalculateCalories(formId, weightKg = 70) {
    const form = document.getElementById(formId);
    if (!form) return;

    const typeEl = form.querySelector('[name="workoutType"]');
    const durationEl = form.querySelector('[name="durationMinutes"]');
    const intensityEl = form.querySelector('[name="intensity"]');
    const caloriesEl = form.querySelector('[name="caloriesBurned"]');

    function update() {
        const type = typeEl ? typeEl.value : 'Running';
        const duration = parseInt(durationEl ? durationEl.value : 0, 10) || 0;
        const intensity = intensityEl ? intensityEl.value : 'Medium';

        if (duration > 0) {
            const baseMet = ACTIVITY_METS[type] || 6.0;
            const mult = INTENSITY_MULTIPLIERS[intensity] || 1.0;
            const met = baseMet * mult;
            const cal = Math.round((met * 3.5 * weightKg / 200.0) * duration);
            if (caloriesEl && (!caloriesEl.value || caloriesEl.dataset.auto === 'true')) {
                caloriesEl.value = cal;
                caloriesEl.dataset.auto = 'true';
            }
        }
    }

    if (typeEl) typeEl.addEventListener('change', update);
    if (durationEl) durationEl.addEventListener('input', update);
    if (intensityEl) intensityEl.addEventListener('change', update);
    if (caloriesEl) {
        caloriesEl.addEventListener('input', () => {
            caloriesEl.dataset.auto = 'false';
        });
    }
}

/**
 * Pre-populates the Edit Workout modal
 */
function openEditWorkoutModal(id, type, duration, intensity, calories, date, notes) {
    const modal = document.getElementById('editWorkoutModal');
    if (!modal) return;

    modal.querySelector('#editWorkoutId').value = id;
    modal.querySelector('#editWorkoutType').value = type;
    modal.querySelector('#editDurationMinutes').value = duration;
    modal.querySelector('#editIntensity').value = intensity;
    modal.querySelector('#editCaloriesBurned').value = calories;
    modal.querySelector('#editWorkoutDate').value = date;
    modal.querySelector('#editNotes').value = notes || '';

    const bsModal = new bootstrap.Modal(modal);
    bsModal.show();
}

/**
 * Pre-populates the Edit Goal modal
 */
function openEditGoalModal(id, title, target, current, unit, deadline, status, description) {
    const modal = document.getElementById('editGoalModal');
    if (!modal) return;

    modal.querySelector('#editGoalId').value = id;
    modal.querySelector('#editGoalTitle').value = title;
    modal.querySelector('#editTargetValue').value = target;
    modal.querySelector('#editCurrentValue').value = current;
    modal.querySelector('#editUnit').value = unit;
    modal.querySelector('#editDeadline').value = deadline;
    modal.querySelector('#editStatus').value = status;
    modal.querySelector('#editDescription').value = description || '';

    const bsModal = new bootstrap.Modal(modal);
    bsModal.show();
}

/**
 * Opens quick progress update modal for Goal
 */
function openGoalProgressModal(id, title, current, target, unit) {
    const modal = document.getElementById('goalProgressModal');
    if (!modal) return;

    modal.querySelector('#progressGoalId').value = id;
    modal.querySelector('#progressGoalTitle').innerText = title;
    modal.querySelector('#progressGoalTarget').innerText = `${target} ${unit}`;
    modal.querySelector('#progressCurrentValue').value = current;
    modal.querySelector('#progressUnitLabel').innerText = unit;

    const bsModal = new bootstrap.Modal(modal);
    bsModal.show();
}

/**
 * Opens quick progress update modal for Challenge
 */
function openChallengeProgressModal(participantId, challengeTitle, currentProgress, targetValue, unit) {
    const modal = document.getElementById('challengeProgressModal');
    if (!modal) return;

    modal.querySelector('#modalParticipantId').value = participantId;
    modal.querySelector('#modalChallengeTitle').innerText = challengeTitle;
    modal.querySelector('#modalChallengeTarget').innerText = `${targetValue} ${unit}`;
    modal.querySelector('#modalProgressInput').value = currentProgress;
    modal.querySelector('#modalProgressUnit').innerText = unit;

    const bsModal = new bootstrap.Modal(modal);
    bsModal.show();
}
