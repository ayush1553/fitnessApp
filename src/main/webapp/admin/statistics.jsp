<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Platform Analytics - Admin FitFlow Pro" scope="request"/>
<c:set var="activePage" value="admin-stats" scope="request"/>
<c:set var="greetingTitle" value="Platform Statistics" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header -->
            <div class="mb-4">
                <h3 class="mb-1 text-theme-primary">Global Fitness Analytics</h3>
                <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                    Aggregated platform usage, user activity distribution, and platform growth metrics.
                </p>
            </div>

            <!-- Highlights -->
            <div class="row g-3 mb-4">
                <div class="col-md-3 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1">Total Users</small>
                        <h3 class="mb-0 text-theme-primary">${summary.totalUsers}</h3>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1">Active Accounts</small>
                        <h3 class="mb-0 text-accent" style="color: var(--accent-primary) !important;">${summary.activeUsers}</h3>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1">Total Workouts Logged</small>
                        <h3 class="mb-0 text-info">${summary.totalWorkouts}</h3>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1">Active Challenges</small>
                        <h3 class="mb-0 text-warning">${summary.activeChallenges}</h3>
                    </div>
                </div>
            </div>

            <!-- Charts -->
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="fitness-card h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0 text-theme-primary">User Growth (6 Months)</h5>
                            <span class="badge-custom badge-active">Registrations</span>
                        </div>
                        <div style="height: 280px; position: relative;">
                            <canvas id="adminRegistrationChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="fitness-card h-100 d-flex flex-column justify-content-between">
                        <div class="mb-3">
                            <h5 class="mb-0 text-theme-primary">Activity Types Popularity</h5>
                        </div>
                        <div style="height: 240px; position: relative;">
                            <canvas id="workoutTypeChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const regData = ${monthlyRegistrationsJson != null ? monthlyRegistrationsJson : "{}"};
        const statsData = ${workoutActivityStatsJson != null ? workoutActivityStatsJson : "{}"};

        initAdminRegistrationChart(regData);
        initWorkoutTypeChart(statsData);
    });
</script>

<jsp:include page="../includes/footer.jsp"/>
