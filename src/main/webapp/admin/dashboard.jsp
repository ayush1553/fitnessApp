<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Admin Dashboard - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="admin-dashboard" scope="request"/>
<c:set var="greetingTitle" value="System Administration" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <span class="badge-custom badge-warning mb-2"><i class="fa-solid fa-shield-halved"></i> Operational Command</span>
                    <h3 class="mb-1 text-theme-primary">Platform Health & Overview</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        Real-time metrics, user growth, pending moderations, and system audit trail.
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/settings" class="btn-outline-custom">
                    <i class="fa-solid fa-sliders"></i> System Settings
                </a>
            </div>

            <!-- Metric Summary Cards -->
            <div class="row g-3 mb-4">
                <div class="col-lg-2 col-md-4 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1">Total Users</small>
                        <h3 class="mb-0 text-theme-primary">${summary.totalUsers}</h3>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1">Active Accounts</small>
                        <h3 class="mb-0" style="color: var(--accent-primary);">${summary.activeUsers}</h3>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1">Total Workouts</small>
                        <h3 class="mb-0 text-info">${summary.totalWorkouts}</h3>
                    </div>
                </div>
                <div class="col-lg-2 col-md-6 col-sm-6">
                    <div class="fitness-card fitness-card-sm">
                        <small class="text-secondary d-block mb-1">Active Challenges</small>
                        <h3 class="mb-0 text-warning">${summary.activeChallenges}</h3>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 col-sm-12">
                    <div class="fitness-card fitness-card-sm d-flex justify-content-between align-items-center">
                        <div>
                            <small class="text-secondary d-block mb-1">Pending Content</small>
                            <h3 class="mb-0 text-danger">${summary.pendingContentCount}</h3>
                        </div>
                        <c:if test="${summary.pendingContentCount > 0}">
                            <a href="${pageContext.request.contextPath}/admin/content" class="btn btn-sm btn-accent">
                                Review <i class="fa-solid fa-arrow-right ms-1"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Charts & Activity Grid -->
            <div class="row g-4">
                <!-- Registration Growth Chart -->
                <div class="col-lg-7">
                    <div class="fitness-card h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0 text-theme-primary">Monthly User Registrations</h5>
                            <span class="badge-custom badge-active">Growth Trend</span>
                        </div>
                        <div style="height: 240px; position: relative;">
                            <canvas id="adminRegistrationChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Workout Distribution Breakdown -->
                <div class="col-lg-5">
                    <div class="fitness-card h-100 d-flex flex-column justify-content-between">
                        <div class="mb-3">
                            <h5 class="mb-0 text-theme-primary">Global Activity Breakdown</h5>
                        </div>
                        <div style="height: 220px; position: relative;">
                            <canvas id="workoutTypeChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity Logs Table -->
                <div class="col-12">
                    <div class="fitness-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0 text-theme-primary"><i class="fa-solid fa-clock-rotate-left text-accent me-2"></i> Recent System Audit Logs</h5>
                            <a href="${pageContext.request.contextPath}/admin/activity" class="text-accent fw-semibold" style="font-size: 0.85rem;">
                                View Full Log Archive <i class="fa-solid fa-arrow-right ms-1"></i>
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Timestamp</th>
                                        <th>Action</th>
                                        <th>Details</th>
                                        <th>User</th>
                                        <th>IP Address</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="log" items="${recentLogs}">
                                        <tr>
                                            <td style="font-size: 0.8rem; color: var(--text-muted);"><fmt:formatDate value="${log.createdAt}" pattern="MMM dd, yyyy HH:mm:ss"/></td>
                                            <td><span class="badge-custom badge-active">${log.action}</span></td>
                                            <td class="text-theme-primary">${log.details}</td>
                                            <td>${empty log.userName ? 'System' : log.userName}</td>
                                            <td><code>${log.ipAddress}</code></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
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
