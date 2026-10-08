<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Progress & Analytics - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="progress" scope="request"/>
<c:set var="greetingTitle" value="Analytics" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header -->
            <div class="mb-4">
                <h3 class="mb-1 text-theme-primary">Fitness Progress Analytics</h3>
                <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                    In-depth performance metrics generated in real-time from your logged activities.
                </p>
            </div>

            <!-- Metric Cards -->
            <div class="row g-3 mb-4">
                <div class="col-md-3 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1"><i class="fa-solid fa-fire text-danger me-1"></i> Lifetime Calories</small>
                        <h4 class="mb-0 text-theme-primary" style="color: var(--accent-primary) !important;"><fmt:formatNumber value="${analytics.totalCalories}" pattern="#,###"/> kcal</h4>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1"><i class="fa-solid fa-stopwatch text-info me-1"></i> Total Time Trained</small>
                        <h4 class="mb-0 text-theme-primary">${analytics.totalDurationMinutes} min</h4>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1"><i class="fa-solid fa-bullseye text-warning me-1"></i> Goals Completed</small>
                        <h4 class="mb-0 text-theme-primary">${analytics.completedGoals}</h4>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1"><i class="fa-solid fa-trophy text-accent me-1"></i> Challenges Won</small>
                        <h4 class="mb-0 text-theme-primary">${analytics.completedChallenges}</h4>
                    </div>
                </div>
            </div>

            <!-- Charts Row 1: Weekly & Monthly Workout Duration -->
            <div class="row g-4 mb-4">
                <div class="col-lg-8">
                    <div class="fitness-card h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-accent mb-1">Consistency</span>
                                <h5 class="mb-0">Workout Duration (Past 7 Days)</h5>
                            </div>
                            <span class="text-secondary" style="font-size: 0.8rem;">Daily Minutes</span>
                        </div>
                        <div style="height: 260px; position: relative;">
                            <canvas id="workoutActivityChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="fitness-card h-100 d-flex flex-column justify-content-between">
                        <div class="mb-3">
                            <span class="badge-custom badge-active mb-1">Discipline</span>
                            <h5 class="mb-0">Workout Type Breakdown</h5>
                        </div>
                        <div style="height: 220px; position: relative;">
                            <canvas id="workoutTypeChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Row 2: Calorie Burning Trend -->
            <div class="row g-4">
                <div class="col-12">
                    <div class="fitness-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-accent mb-1">Energy Burn</span>
                                <h5 class="mb-0">Weekly Calorie Burning Trajectory</h5>
                            </div>
                            <span class="text-secondary" style="font-size: 0.8rem;">kcal per Day</span>
                        </div>
                        <div style="height: 240px; position: relative;">
                            <canvas id="progressAnalyticsChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const weeklyData = ${weeklyDurationJson != null ? weeklyDurationJson : "{}"};
        const monthlyData = ${monthlyDurationJson != null ? monthlyDurationJson : "{}"};
        const weeklyCaloriesData = ${weeklyCaloriesJson != null ? weeklyCaloriesJson : "{}"};
        const workoutTypeData = ${workoutTypeJson != null ? workoutTypeJson : "{}"};

        initWorkoutActivityChart(weeklyData, monthlyData);
        initProgressAnalyticsChart(weeklyCaloriesData);
        initWorkoutTypeChart(workoutTypeData);
    });
</script>

<jsp:include page="../includes/footer.jsp"/>
