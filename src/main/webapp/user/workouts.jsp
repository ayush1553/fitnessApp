<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Workouts - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="workouts" scope="request"/>
<c:set var="greetingTitle" value="Workouts" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header and Action Toolbar -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h3 class="mb-1 text-theme-primary">Workout Sessions</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        Log, analyze, and manage your daily fitness sessions.
                    </p>
                </div>
                <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#addWorkoutModal">
                    <i class="fa-solid fa-plus"></i> Add Workout
                </button>
            </div>

            <!-- Metric Summary Cards -->
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                        <div class="rec-icon-box">
                            <i class="fa-solid fa-dumbbell"></i>
                        </div>
                        <div>
                            <small class="text-secondary d-block">Total Workouts</small>
                            <span class="fs-4 fw-bold text-theme-primary">${totalCount}</span>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                        <div class="rec-icon-box">
                            <i class="fa-solid fa-stopwatch text-info"></i>
                        </div>
                        <div>
                            <small class="text-secondary d-block">Total Duration</small>
                            <span class="fs-4 fw-bold text-theme-primary">${totalMinutes} min</span>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                        <div class="rec-icon-box">
                            <i class="fa-solid fa-fire text-danger"></i>
                        </div>
                        <div>
                            <small class="text-secondary d-block">Calories Burned</small>
                            <span class="fs-4 fw-bold" style="color: var(--accent-primary);"><fmt:formatNumber value="${totalCalories}" pattern="#,###"/> kcal</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- FEATURED STREAMING WORKOUTS RAIL -->
            <div class="mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <span class="badge-custom badge-accent mb-1">Featured Streams</span>
                        <h4 class="mb-0 text-theme-primary fw-bold">Cinematic Workout Programs</h4>
                    </div>
                    <span class="text-secondary" style="font-size: 0.85rem;"><i class="fa-solid fa-tv me-1 text-accent"></i> 4K Studio Quality</span>
                </div>

                <div class="row g-3">
                    <div class="col-lg-4 col-md-6">
                        <div class="stream-workout-card" onclick="openAddWorkoutPreset('Gym', '35', '380', 'HIIT Interval Rush')">
                            <img src="${pageContext.request.contextPath}/assets/images/challenges/hiit.jpg" alt="HIIT Rush" loading="lazy">
                            <div class="stream-workout-overlay">
                                <div class="stream-badge-row">
                                    <span class="stream-badge stream-badge-accent">HIIT</span>
                                    <span class="stream-badge"><i class="fa-solid fa-stopwatch me-1"></i>35 min</span>
                                </div>
                                <div class="stream-workout-title">HIIT Interval Rush</div>
                                <div class="stream-workout-meta">
                                    <span><i class="fa-solid fa-fire me-1 text-danger"></i>380 kcal</span>
                                    <span>&bull;</span>
                                    <span>Coach Adam</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="stream-workout-card" onclick="openAddWorkoutPreset('Strength Training', '50', '420', 'Power Strength & Core')">
                            <img src="${pageContext.request.contextPath}/assets/images/content/strength-training.jpg" alt="Strength" loading="lazy">
                            <div class="stream-workout-overlay">
                                <div class="stream-badge-row">
                                    <span class="stream-badge stream-badge-accent">Strength</span>
                                    <span class="stream-badge"><i class="fa-solid fa-stopwatch me-1"></i>50 min</span>
                                </div>
                                <div class="stream-workout-title">Power Strength & Core</div>
                                <div class="stream-workout-meta">
                                    <span><i class="fa-solid fa-fire me-1 text-danger"></i>420 kcal</span>
                                    <span>&bull;</span>
                                    <span>Coach John</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="stream-workout-card" onclick="openAddWorkoutPreset('Running', '30', '310', 'Sunrise Outdoor 5K Run')">
                            <img src="${pageContext.request.contextPath}/assets/images/content/5k-running.jpg" alt="5K Running" loading="lazy">
                            <div class="stream-workout-overlay">
                                <div class="stream-badge-row">
                                    <span class="stream-badge stream-badge-accent">Endurance</span>
                                    <span class="stream-badge"><i class="fa-solid fa-stopwatch me-1"></i>30 min</span>
                                </div>
                                <div class="stream-workout-title">Sunrise Outdoor 5K Run</div>
                                <div class="stream-workout-meta">
                                    <span><i class="fa-solid fa-fire me-1 text-danger"></i>310 kcal</span>
                                    <span>&bull;</span>
                                    <span>Audio Guided</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters & Search Toolbar -->
            <div class="fitness-card mb-4 p-3">
                <form action="${pageContext.request.contextPath}/user/workouts" method="GET" class="row g-2 align-items-end">
                    <div class="col-md-3 col-sm-6">
                        <label class="form-label-custom">Workout Type</label>
                        <select name="type" class="form-control-custom">
                            <option value="ALL" ${selectedType == 'ALL' ? 'selected' : ''}>All Types</option>
                            <option value="Running" ${selectedType == 'Running' ? 'selected' : ''}>Running</option>
                            <option value="Walking" ${selectedType == 'Walking' ? 'selected' : ''}>Walking</option>
                            <option value="Cycling" ${selectedType == 'Cycling' ? 'selected' : ''}>Cycling</option>
                            <option value="Swimming" ${selectedType == 'Swimming' ? 'selected' : ''}>Swimming</option>
                            <option value="Gym" ${selectedType == 'Gym' ? 'selected' : ''}>Gym</option>
                            <option value="Yoga" ${selectedType == 'Yoga' ? 'selected' : ''}>Yoga</option>
                            <option value="Strength Training" ${selectedType == 'Strength Training' ? 'selected' : ''}>Strength Training</option>
                            <option value="Other" ${selectedType == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    <div class="col-md-2 col-sm-6">
                        <label class="form-label-custom">Intensity</label>
                        <select name="intensity" class="form-control-custom">
                            <option value="ALL" ${selectedIntensity == 'ALL' ? 'selected' : ''}>All</option>
                            <option value="Low" ${selectedIntensity == 'Low' ? 'selected' : ''}>Low</option>
                            <option value="Medium" ${selectedIntensity == 'Medium' ? 'selected' : ''}>Medium</option>
                            <option value="High" ${selectedIntensity == 'High' ? 'selected' : ''}>High</option>
                        </select>
                    </div>
                    <div class="col-md-2 col-sm-6">
                        <label class="form-label-custom">Start Date</label>
                        <input type="date" name="startDate" value="${selectedStartDate}" class="form-control-custom">
                    </div>
                    <div class="col-md-2 col-sm-6">
                        <label class="form-label-custom">End Date</label>
                        <input type="date" name="endDate" value="${selectedEndDate}" class="form-control-custom">
                    </div>
                    <div class="col-md-2 col-sm-6">
                        <label class="form-label-custom">Sort By</label>
                        <select name="sortBy" class="form-control-custom">
                            <option value="date" ${selectedSortBy == 'date' ? 'selected' : ''}>Date</option>
                            <option value="duration" ${selectedSortBy == 'duration' ? 'selected' : ''}>Duration</option>
                            <option value="calories" ${selectedSortBy == 'calories' ? 'selected' : ''}>Calories</option>
                            <option value="type" ${selectedSortBy == 'type' ? 'selected' : ''}>Type</option>
                        </select>
                    </div>
                    <div class="col-md-1 col-sm-12 d-flex gap-1">
                        <button type="submit" class="btn-accent w-100 justify-content-center p-2" title="Apply Filters">
                            <i class="fa-solid fa-filter"></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/user/workouts" class="btn-outline-custom p-2" title="Reset Filters">
                            <i class="fa-solid fa-rotate-left"></i>
                        </a>
                    </div>
                </form>
            </div>

            <!-- Workout Sessions Table / Card List -->
            <div class="fitness-card">
                <c:choose>
                    <c:when test="${not empty workouts}">
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Activity</th>
                                        <th>Date</th>
                                        <th>Duration</th>
                                        <th>Intensity</th>
                                        <th>Calories</th>
                                        <th>Notes</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="w" items="${workouts}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="badge-custom badge-accent">
                                                        <c:choose>
                                                            <c:when test="${w.workoutType == 'Running'}"><i class="fa-solid fa-person-running"></i></c:when>
                                                            <c:when test="${w.workoutType == 'Cycling'}"><i class="fa-solid fa-person-biking"></i></c:when>
                                                            <c:when test="${w.workoutType == 'Swimming'}"><i class="fa-solid fa-person-swimming"></i></c:when>
                                                            <c:when test="${w.workoutType == 'Gym' || w.workoutType == 'Strength Training'}"><i class="fa-solid fa-dumbbell"></i></c:when>
                                                            <c:when test="${w.workoutType == 'Yoga'}"><i class="fa-solid fa-spa"></i></c:when>
                                                            <c:otherwise><i class="fa-solid fa-bolt"></i></c:otherwise>
                                                        </c:choose>
                                                        ${w.workoutType}
                                                    </span>
                                                </div>
                                            </td>
                                            <td><fmt:formatDate value="${w.workoutDate}" pattern="MMM dd, yyyy"/></td>
                                            <td class="fw-bold text-theme-primary">${w.durationMinutes} min</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${w.intensity == 'High'}"><span class="badge-custom badge-danger">High</span></c:when>
                                                    <c:when test="${w.intensity == 'Low'}"><span class="badge-custom badge-warning">Low</span></c:when>
                                                    <c:otherwise><span class="badge-custom badge-active">Medium</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="fw-bold" style="color: var(--accent-primary);">${w.caloriesBurned} kcal</td>
                                            <td>
                                                <span class="text-secondary" style="font-size: 0.85rem;">
                                                    ${empty w.notes ? '—' : w.notes}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-inline-flex gap-2">
                                                    <button type="button" class="btn btn-sm btn-outline-custom p-1 px-2"
                                                            onclick="openEditWorkoutModal('${w.id}', '${w.workoutType}', '${w.durationMinutes}', '${w.intensity}', '${w.caloriesBurned}', '${w.workoutDate}', '${w.notes}')"
                                                            title="Edit Workout">
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/workout/delete" method="POST" class="d-inline"
                                                          onsubmit="return confirm('Are you sure you want to delete this workout record?');">
                                                        <input type="hidden" name="id" value="${w.id}">
                                                        <button type="submit" class="btn btn-sm btn-danger-custom p-1 px-2" title="Delete">
                                                            <i class="fa-solid fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-dumbbell fs-1 mb-3"></i>
                            <h5 class="text-theme-primary">No workouts found</h5>
                            <p class="mb-3">Try adjusting your filters or log your first workout session.</p>
                            <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#addWorkoutModal">
                                <i class="fa-solid fa-plus"></i> Add Workout
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Add Workout -->
<div class="modal fade" id="addWorkoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-theme-primary"><i class="fa-solid fa-plus text-accent me-2"></i> Log New Workout</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form id="addWorkoutForm" action="${pageContext.request.contextPath}/workout/add" method="POST" class="needs-validation" novalidate>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-custom">Workout Type</label>
                            <select name="workoutType" class="form-control-custom" required>
                                <option value="Running">Running</option>
                                <option value="Walking">Walking</option>
                                <option value="Cycling">Cycling</option>
                                <option value="Swimming">Swimming</option>
                                <option value="Gym">Gym / Weightlifting</option>
                                <option value="Yoga">Yoga</option>
                                <option value="Strength Training">Strength Training</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Duration (Minutes)</label>
                            <input type="number" name="durationMinutes" class="form-control-custom" placeholder="45" min="1" max="1440" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Intensity</label>
                            <select name="intensity" class="form-control-custom">
                                <option value="Low">Low</option>
                                <option value="Medium" selected>Medium</option>
                                <option value="High">High</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Calories Burned (kcal)</label>
                            <input type="number" name="caloriesBurned" class="form-control-custom" placeholder="Auto-calculated">
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Date</label>
                            <input type="date" name="workoutDate" class="form-control-custom" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Session Notes (Optional)</label>
                            <textarea name="notes" class="form-control-custom" rows="2" placeholder="e.g. Felt strong during squats"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-check"></i> Save Workout</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Edit Workout -->
<div class="modal fade" id="editWorkoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-theme-primary"><i class="fa-solid fa-pen-to-square text-accent me-2"></i> Edit Workout</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form id="editWorkoutForm" action="${pageContext.request.contextPath}/workout/update" method="POST" class="needs-validation" novalidate>
                <input type="hidden" name="id" id="editWorkoutId">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-custom">Workout Type</label>
                            <select name="workoutType" id="editWorkoutType" class="form-control-custom" required>
                                <option value="Running">Running</option>
                                <option value="Walking">Walking</option>
                                <option value="Cycling">Cycling</option>
                                <option value="Swimming">Swimming</option>
                                <option value="Gym">Gym / Weightlifting</option>
                                <option value="Yoga">Yoga</option>
                                <option value="Strength Training">Strength Training</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Duration (Minutes)</label>
                            <input type="number" name="durationMinutes" id="editDurationMinutes" class="form-control-custom" min="1" max="1440" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Intensity</label>
                            <select name="intensity" id="editIntensity" class="form-control-custom">
                                <option value="Low">Low</option>
                                <option value="Medium">Medium</option>
                                <option value="High">High</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Calories Burned (kcal)</label>
                            <input type="number" name="caloriesBurned" id="editCaloriesBurned" class="form-control-custom">
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Date</label>
                            <input type="date" name="workoutDate" id="editWorkoutDate" class="form-control-custom" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Session Notes</label>
                            <textarea name="notes" id="editNotes" class="form-control-custom" rows="2"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-check"></i> Update Workout</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const userWeight = ${sessionScope.currentUser.profile != null && sessionScope.currentUser.profile.weightKg != null ? sessionScope.currentUser.profile.weightKg : 70};
        autoCalculateCalories('addWorkoutForm', userWeight);
        autoCalculateCalories('editWorkoutForm', userWeight);
    });

    function openAddWorkoutPreset(type, duration, calories, notes) {
        const modalEl = document.getElementById('addWorkoutModal');
        if (!modalEl) return;
        const modal = new bootstrap.Modal(modalEl);
        const form = modalEl.querySelector('form');
        if (form) {
            if (form.querySelector('[name="workoutType"]')) form.querySelector('[name="workoutType"]').value = type;
            if (form.querySelector('[name="durationMinutes"]')) form.querySelector('[name="durationMinutes"]').value = duration;
            if (form.querySelector('[name="caloriesBurned"]')) form.querySelector('[name="caloriesBurned"]').value = calories;
            if (form.querySelector('[name="notes"]')) form.querySelector('[name="notes"]').value = 'Featured Session: ' + notes;
        }
        modal.show();
    }
</script>

<jsp:include page="../includes/footer.jsp"/>
