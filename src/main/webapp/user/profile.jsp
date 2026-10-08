<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="User Profile - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="profile" scope="request"/>
<c:set var="greetingTitle" value="Profile Settings" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <div class="row g-4">
                <!-- Profile Biometric Overview Card -->
                <div class="col-lg-4">
                    <div class="fitness-card text-center mb-4">
                        <div class="avatar-circle mx-auto mb-3" style="width: 80px; height: 80px; font-size: 2rem;">
                            ${sessionScope.currentUser.name.substring(0, 1)}
                        </div>
                        <h4 class="text-theme-primary fw-bold mb-1">${sessionScope.currentUser.name}</h4>
                        <p class="text-secondary mb-3" style="font-size: 0.85rem;">${sessionScope.currentUser.email}</p>
                        <span class="badge-custom badge-accent mb-4">
                            <i class="fa-solid fa-shield me-1"></i> ${sessionScope.currentUser.roleName}
                        </span>

                        <div class="p-3 rounded-3 text-start" style="background-color: var(--bg-secondary); border: 1px solid var(--border-color);">
                            <div class="stat-pill-row">
                                <span class="stat-pill-label"><i class="fa-solid fa-scale-balanced text-accent"></i> Calculated BMI</span>
                                <span class="stat-pill-value">${profile.calculateBMI() != null ? profile.calculateBMI() : "N/A"}</span>
                            </div>
                            <div class="stat-pill-row">
                                <span class="stat-pill-label"><i class="fa-solid fa-heart-pulse text-danger"></i> BMI Status</span>
                                <span class="badge-custom badge-active">${profile.BMICategory}</span>
                            </div>
                            <div class="stat-pill-row">
                                <span class="stat-pill-label"><i class="fa-solid fa-fire text-warning"></i> Daily Target</span>
                                <span class="stat-pill-value"><fmt:formatNumber value="${sessionScope.currentUser.calculateDailyCalorieRecommendation()}" pattern="#,###"/> kcal</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Profile Editing Form -->
                <div class="col-lg-8">
                    <div class="fitness-card mb-4">
                        <h5 class="text-theme-primary fw-bold mb-3"><i class="fa-solid fa-user-gear text-accent me-2"></i> Biometric & Fitness Profile</h5>
                        <form action="${pageContext.request.contextPath}/profile/update" method="POST" class="needs-validation" novalidate>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label-custom">Full Name</label>
                                    <input type="text" name="name" class="form-control-custom" value="${sessionScope.currentUser.name}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Email Address (Read-only)</label>
                                    <input type="email" class="form-control-custom" value="${sessionScope.currentUser.email}" readonly disabled style="opacity: 0.6;">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label-custom">Age (Years)</label>
                                    <input type="number" name="age" class="form-control-custom" value="${profile.age}" placeholder="e.g. 28">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label-custom">Height (cm)</label>
                                    <input type="number" step="0.1" name="heightCm" class="form-control-custom" value="${profile.heightCm}" placeholder="e.g. 178">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label-custom">Weight (kg)</label>
                                    <input type="number" step="0.1" name="weightKg" class="form-control-custom" value="${profile.weightKg}" placeholder="e.g. 74.5">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Primary Fitness Goal</label>
                                    <input type="text" name="fitnessGoal" class="form-control-custom" value="${profile.fitnessGoal}" placeholder="e.g. Marathon training, Fat loss">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Activity Level</label>
                                    <select name="activityLevel" class="form-control-custom">
                                        <option value="SEDENTARY" ${profile.activityLevel == 'SEDENTARY' ? 'selected' : ''}>Sedentary (Little/No Exercise)</option>
                                        <option value="LIGHTLY_ACTIVE" ${profile.activityLevel == 'LIGHTLY_ACTIVE' ? 'selected' : ''}>Lightly Active (1-3 days/week)</option>
                                        <option value="MODERATELY_ACTIVE" ${profile.activityLevel == 'MODERATELY_ACTIVE' ? 'selected' : ''}>Moderately Active (3-5 days/week)</option>
                                        <option value="VERY_ACTIVE" ${profile.activityLevel == 'VERY_ACTIVE' ? 'selected' : ''}>Very Active (6-7 days/week)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mt-4 pt-3 border-top" style="border-color: var(--border-color) !important;">
                                <button type="submit" class="btn-accent">
                                    <i class="fa-solid fa-check"></i> Save Changes
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Change Password Card -->
                    <div class="fitness-card">
                        <h5 class="text-theme-primary fw-bold mb-3"><i class="fa-solid fa-lock text-accent me-2"></i> Update Password</h5>
                        <form action="${pageContext.request.contextPath}/profile/password" method="POST" class="needs-validation" novalidate>
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label-custom">Current Password</label>
                                    <input type="password" name="currentPassword" class="form-control-custom" required autocomplete="current-password">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label-custom">New Password</label>
                                    <input type="password" name="newPassword" class="form-control-custom" required minlength="6" autocomplete="new-password">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label-custom">Confirm New Password</label>
                                    <input type="password" name="confirmPassword" class="form-control-custom" required minlength="6" autocomplete="new-password">
                                </div>
                            </div>
                            <div class="mt-4 pt-3 border-top" style="border-color: var(--border-color) !important;">
                                <button type="submit" class="btn-outline-custom">
                                    <i class="fa-solid fa-key"></i> Change Password
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
