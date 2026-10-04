<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Dashboard - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="dashboard" scope="request"/>
<c:set var="greetingTitle" value="Good Morning" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <!-- Sidebar Navigation -->
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <!-- Main Content Area -->
    <div class="app-main">
        <!-- Top Navbar -->
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <!-- Alert Notifications -->
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Top Banner / Summary Greeting -->
            <div class="fitness-card mb-4 d-flex flex-wrap align-items-center justify-content-between gap-3" 
                 style="background: linear-gradient(135deg, #151817 0%, #1a221a 100%); border-color: rgba(200, 255, 69, 0.2);">
                <div>
                    <span class="badge-custom badge-accent mb-2">
                        <i class="fa-solid fa-fire"></i> Active Streak: 7 Days
                    </span>
                    <h3 class="mb-1 text-white">Track Your Progress, ${sessionScope.currentUser.name}</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        You have completed <strong class="text-white">${summary.totalWorkouts} workouts</strong> and burned <strong style="color: var(--accent-primary);"><fmt:formatNumber value="${summary.totalCalories}" pattern="#,###"/> kcal</strong> so far.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#quickWorkoutModal">
                        <i class="fa-solid fa-plus"></i> Log Workout
                    </button>
                    <a href="${pageContext.request.contextPath}/user/goals" class="btn-outline-custom">
                        <i class="fa-solid fa-bullseye"></i> Set Goal
                    </a>
                </div>
            </div>

            <!-- Dashboard Grid Composition -->
            <div class="dashboard-grid">
                
                <!-- SECTION 1: WORKOUT ACTIVITY (Weekly / Monthly Switcher) -->
                <div class="grid-col-8">
                    <div class="fitness-card h-100 d-flex flex-column">
                        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-active mb-1">Analytics</span>
                                <h5 class="mb-0">Workout Activity</h5>
                            </div>
                            <div class="btn-group btn-group-sm p-1 rounded-pill" style="background-color: var(--bg-secondary); border: 1px solid var(--border-color);">
                                <button type="button" id="btnChartWeekly" class="btn btn-sm btn-accent rounded-pill px-3">Weekly</button>
                                <button type="button" id="btnChartMonthly" class="btn btn-sm btn-outline-custom rounded-pill px-3">Monthly</button>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-4 mb-3 pb-2 border-bottom" style="border-color: var(--border-color) !important;">
                            <div>
                                <small class="text-secondary d-block" style="font-size: 0.75rem;">Total Duration</small>
                                <span class="fw-bold fs-5 text-white">${summary.durationFormatted}</span>
                            </div>
                            <div class="vr" style="background-color: var(--border-color); opacity: 1;"></div>
                            <div>
                                <small class="text-secondary d-block" style="font-size: 0.75rem;">Total Workouts</small>
                                <span class="fw-bold fs-5 text-white">${summary.totalWorkouts}</span>
                            </div>
                            <div class="vr" style="background-color: var(--border-color); opacity: 1;"></div>
                            <div>
                                <small class="text-secondary d-block" style="font-size: 0.75rem;">Calories Burned</small>
                                <span class="fw-bold fs-5" style="color: var(--accent-primary);"><fmt:formatNumber value="${summary.totalCalories}" pattern="#,###"/> kcal</span>
                            </div>
                        </div>

                        <div class="flex-grow-1" style="min-height: 240px; position: relative;">
                            <canvas id="workoutActivityChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- SECTION 2: FITNESS OVERVIEW (Donut / Circular Chart & Stats) -->
                <div class="grid-col-4">
                    <div class="fitness-card h-100 d-flex flex-column justify-content-between">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="mb-0">Fitness Overview</h5>
                            <span class="badge-custom badge-accent">${summary.goalCompletionPercentage}% Done</span>
                        </div>

                        <!-- Donut Chart -->
                        <div class="donut-chart-container my-2">
                            <canvas id="fitnessDonutChart"></canvas>
                            <div class="donut-center-text">
                                <div class="donut-pct-large">${summary.goalCompletionPercentage}%</div>
                                <div class="donut-pct-label">Goal Met</div>
                            </div>
                        </div>

                        <!-- Metric Rows beside chart -->
                        <div class="mt-2">
                            <div class="stat-pill-row">
                                <span class="stat-pill-label">
                                    <i class="fa-solid fa-fire text-danger"></i> Calories Burned
                                </span>
                                <span class="stat-pill-value"><fmt:formatNumber value="${summary.totalCalories}" pattern="#,###"/> kcal</span>
                            </div>
                            <div class="stat-pill-row">
                                <span class="stat-pill-label">
                                    <i class="fa-solid fa-stopwatch text-info"></i> Workout Duration
                                </span>
                                <span class="stat-pill-value">${summary.durationFormatted}</span>
                            </div>
                            <div class="stat-pill-row">
                                <span class="stat-pill-label">
                                    <i class="fa-solid fa-dumbbell" style="color: var(--accent-primary);"></i> Workouts Logged
                                </span>
                                <span class="stat-pill-value">${summary.totalWorkouts}</span>
                            </div>
                            <div class="stat-pill-row">
                                <span class="stat-pill-label">
                                    <i class="fa-solid fa-bullseye text-warning"></i> Goal Completion
                                </span>
                                <span class="stat-pill-value" style="color: var(--accent-primary);">${summary.goalCompletionPercentage}%</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION 3: FITNESS GOALS -->
                <div class="grid-col-6">
                    <div class="fitness-card h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-accent mb-1">Targets</span>
                                <h5 class="mb-0">Fitness Goals</h5>
                            </div>
                            <a href="${pageContext.request.contextPath}/user/goals" class="text-accent fw-bold" style="font-size: 0.85rem;">
                                View All <i class="fa-solid fa-arrow-right ms-1"></i>
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${not empty activeGoals}">
                                <c:forEach var="goal" items="${activeGoals}">
                                    <div class="goal-item-card">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h6 class="mb-1 text-white fw-bold">${goal.title}</h6>
                                                <small class="text-secondary">
                                                    <fmt:formatNumber value="${goal.currentValue}" pattern="#,##0.#"/> / <fmt:formatNumber value="${goal.targetValue}" pattern="#,##0.#"/> ${goal.unit}
                                                </small>
                                            </div>
                                            <span class="badge-custom badge-accent">${goal.progressPercentage}%</span>
                                        </div>

                                        <div class="progress-custom mb-2">
                                            <div class="progress-bar-custom" style="width: ${goal.progressPercentage}%;"></div>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center" style="font-size: 0.75rem;">
                                            <span class="text-muted"><i class="fa-regular fa-calendar me-1"></i> Due in ${goal.daysRemaining} days</span>
                                            <button type="button" class="btn btn-sm btn-link text-accent p-0 text-decoration-none"
                                                    onclick="openGoalProgressModal('${goal.id}', '${goal.title}', '${goal.currentValue}', '${goal.targetValue}', '${goal.unit}')">
                                                Update Progress
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-bullseye fs-2 mb-2"></i>
                                    <p class="mb-2">No active fitness goals yet.</p>
                                    <a href="${pageContext.request.contextPath}/user/goals" class="btn btn-sm btn-accent">Create Goal</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- SECTION 4: FITNESS RECOMMENDATIONS -->
                <div class="grid-col-6">
                    <div class="fitness-card h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-active mb-1">Recommended</span>
                                <h5 class="mb-0">Workout Recommendations</h5>
                            </div>
                            <span class="text-muted" style="font-size: 0.8rem;">Personalized</span>
                        </div>

                        <div class="d-flex flex-column gap-2">
                            <c:forEach var="rec" items="${recommendations}">
                                <div class="recommendation-card">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rec-icon-box">
                                            <i class="fa-solid ${rec.icon}"></i>
                                        </div>
                                        <div>
                                            <h6 class="mb-1 text-white fw-bold" style="font-size: 0.9rem;">${rec.title}</h6>
                                            <div class="d-flex align-items-center gap-2 text-secondary" style="font-size: 0.75rem;">
                                                <span><i class="fa-solid fa-stopwatch me-1"></i>${rec.duration}</span>
                                                <span>&bull;</span>
                                                <span><i class="fa-solid fa-fire me-1 text-danger"></i>${rec.calories}</span>
                                                <span>&bull;</span>
                                                <span class="badge-custom badge-accent py-0 px-2">${rec.difficulty}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <button class="btn btn-sm btn-outline-custom rounded-pill px-3"
                                            onclick="openQuickWorkoutPreset('${rec.title}', '${rec.category}', '${rec.duration.replace(' min', '')}', '${rec.calories.replace(' kcal', '')}')">
                                        Start
                                    </button>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- SECTION 5: PROGRESS STATISTICS (Calories Line Chart) -->
                <div class="grid-col-12">
                    <div class="fitness-card">
                        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-accent mb-1">Trends</span>
                                <h5 class="mb-0">Calorie Burning & Energy Expenditure</h5>
                            </div>
                            <span class="text-secondary" style="font-size: 0.85rem;"><i class="fa-solid fa-chart-line me-1 text-accent"></i> 7-Day Performance</span>
                        </div>
                        <div style="height: 220px; position: relative;">
                            <canvas id="progressAnalyticsChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- SECTION 6: RECENT WORKOUTS -->
                <div class="grid-col-6">
                    <div class="fitness-card h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-active mb-1">Activity</span>
                                <h5 class="mb-0">Recent Workouts</h5>
                            </div>
                            <a href="${pageContext.request.contextPath}/user/workouts" class="text-accent fw-bold" style="font-size: 0.85rem;">
                                View History <i class="fa-solid fa-arrow-right ms-1"></i>
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${not empty recentWorkouts}">
                                <c:forEach var="w" items="${recentWorkouts}">
                                    <div class="workout-item-row">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rec-icon-box" style="width: 38px; height: 38px;">
                                                <c:choose>
                                                    <c:when test="${w.workoutType == 'Running'}"><i class="fa-solid fa-person-running"></i></c:when>
                                                    <c:when test="${w.workoutType == 'Cycling'}"><i class="fa-solid fa-person-biking"></i></c:when>
                                                    <c:when test="${w.workoutType == 'Swimming'}"><i class="fa-solid fa-person-swimming"></i></c:when>
                                                    <c:when test="${w.workoutType == 'Gym' || w.workoutType == 'Strength Training'}"><i class="fa-solid fa-dumbbell"></i></c:when>
                                                    <c:when test="${w.workoutType == 'Yoga'}"><i class="fa-solid fa-spa"></i></c:when>
                                                    <c:otherwise><i class="fa-solid fa-bolt"></i></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <h6 class="mb-0 text-white fw-bold" style="font-size: 0.9rem;">${w.workoutType}</h6>
                                                <small class="text-muted"><fmt:formatDate value="${w.workoutDate}" pattern="MMM dd, yyyy"/> &bull; ${w.intensity} Intensity</small>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-white" style="font-size: 0.9rem;">${w.durationMinutes} min</div>
                                            <small style="color: var(--accent-primary); font-weight: 600;">${w.caloriesBurned} kcal</small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-dumbbell fs-2 mb-2"></i>
                                    <p class="mb-0">No workouts logged yet.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- SECTION 7: CHALLENGE PROGRESS -->
                <div class="grid-col-6">
                    <div class="fitness-card h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-accent mb-1">Community</span>
                                <h5 class="mb-0">Active Challenges</h5>
                            </div>
                            <a href="${pageContext.request.contextPath}/user/challenges" class="text-accent fw-bold" style="font-size: 0.85rem;">
                                Explore <i class="fa-solid fa-arrow-right ms-1"></i>
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${not empty joinedChallenges}">
                                <c:forEach var="c" items="${joinedChallenges}">
                                    <div class="goal-item-card">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h6 class="mb-1 text-white fw-bold">${c.title}</h6>
                                                <small class="text-secondary">
                                                    <fmt:formatNumber value="${c.userParticipation.progress}" pattern="#,##0.#"/> / <fmt:formatNumber value="${c.targetValue}" pattern="#,##0.#"/> ${c.unit}
                                                </small>
                                            </div>
                                            <span class="badge-custom badge-accent">${c.userParticipation.progressPercentage}%</span>
                                        </div>

                                        <div class="progress-custom mb-2">
                                            <div class="progress-bar-custom" style="width: ${c.userParticipation.progressPercentage}%;"></div>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center" style="font-size: 0.75rem;">
                                            <span class="text-muted"><i class="fa-regular fa-clock me-1"></i> ${c.daysRemaining} days remaining</span>
                                            <button type="button" class="btn btn-sm btn-link text-accent p-0 text-decoration-none"
                                                    onclick="openChallengeProgressModal('${c.userParticipation.id}', '${c.title}', '${c.userParticipation.progress}', '${c.targetValue}', '${c.unit}')">
                                                Update Progress
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-trophy fs-2 mb-2"></i>
                                    <p class="mb-2">You have not joined any challenges yet.</p>
                                    <a href="${pageContext.request.contextPath}/user/challenges" class="btn btn-sm btn-accent">Browse Challenges</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- Modal: Quick Add Workout -->
<div class="modal fade" id="quickWorkoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-white"><i class="fa-solid fa-plus text-accent me-2"></i> Log New Workout</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form id="quickWorkoutForm" action="${pageContext.request.contextPath}/workout/add" method="POST" class="needs-validation" novalidate>
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
                            <input type="number" name="durationMinutes" class="form-control-custom" placeholder="e.g. 45" min="1" max="1440" required>
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
                            <textarea name="notes" class="form-control-custom" rows="2" placeholder="e.g. 5x5 squats, felt energized"></textarea>
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

<!-- Modal: Goal Progress Updater -->
<div class="modal fade" id="goalProgressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h6 class="modal-title text-white">Update Goal Progress</h6>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/goal/progress" method="POST">
                <input type="hidden" name="id" id="progressGoalId">
                <div class="modal-body p-3">
                    <p class="mb-1 text-white fw-bold" id="progressGoalTitle"></p>
                    <p class="text-secondary mb-3" style="font-size: 0.8rem;">Target: <span id="progressGoalTarget" class="text-accent fw-bold"></span></p>

                    <label class="form-label-custom">New Current Value (<span id="progressUnitLabel"></span>)</label>
                    <input type="number" step="0.1" name="currentValue" id="progressCurrentValue" class="form-control-custom" required>
                </div>
                <div class="modal-footer modal-footer-custom p-2">
                    <button type="button" class="btn btn-sm btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-accent">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Challenge Progress Updater -->
<div class="modal fade" id="challengeProgressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h6 class="modal-title text-white">Update Challenge Progress</h6>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/challenge/progress" method="POST">
                <input type="hidden" name="participantId" id="modalParticipantId">
                <div class="modal-body p-3">
                    <p class="mb-1 text-white fw-bold" id="modalChallengeTitle"></p>
                    <p class="text-secondary mb-3" style="font-size: 0.8rem;">Target: <span id="modalChallengeTarget" class="text-accent fw-bold"></span></p>

                    <label class="form-label-custom">New Accumulated Progress (<span id="modalProgressUnit"></span>)</label>
                    <input type="number" step="0.1" name="progress" id="modalProgressInput" class="form-control-custom" required>
                </div>
                <div class="modal-footer modal-footer-custom p-2">
                    <button type="button" class="btn btn-sm btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-accent">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Initialize dynamic charts using backend JSON data
        const weeklyData = ${weeklyDurationJson != null ? weeklyDurationJson : "{}"};
        const monthlyData = ${monthlyDurationJson != null ? monthlyDurationJson : "{}"};
        const weeklyCaloriesData = ${weeklyCaloriesJson != null ? weeklyCaloriesJson : "{}"};
        const goalPct = ${summary.goalCompletionPercentage != null ? summary.goalCompletionPercentage : 0};

        initWorkoutActivityChart(weeklyData, monthlyData);
        initFitnessDonutChart(goalPct);
        initProgressAnalyticsChart(weeklyCaloriesData);

        // Auto MET calorie calculation for modal form
        autoCalculateCalories('quickWorkoutForm', ${sessionScope.currentUser.profile != null && sessionScope.currentUser.profile.weightKg != null ? sessionScope.currentUser.profile.weightKg : 70});
    });

    function openQuickWorkoutPreset(title, type, duration, calories) {
        const modal = new bootstrap.Modal(document.getElementById('quickWorkoutModal'));
        const form = document.getElementById('quickWorkoutForm');
        form.querySelector('[name="workoutType"]').value = (type === 'Cardio' ? 'Running' : (type === 'Strength' ? 'Gym' : (type === 'Recovery' ? 'Yoga' : 'Other')));
        form.querySelector('[name="durationMinutes"]').value = duration;
        form.querySelector('[name="caloriesBurned"]').value = calories;
        form.querySelector('[name="notes"]').value = 'Recommended Routine: ' + title;
        modal.show();
    }
</script>

<jsp:include page="../includes/footer.jsp"/>
