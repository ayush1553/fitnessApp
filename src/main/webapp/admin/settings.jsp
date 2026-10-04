<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="System Settings - Admin FitFlow Pro" scope="request"/>
<c:set var="activePage" value="admin-settings" scope="request"/>
<c:set var="greetingTitle" value="System Configuration" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header -->
            <div class="mb-4">
                <h3 class="mb-1 text-white">System Settings & Dynamic Parameters</h3>
                <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                    Configure application parameters stored directly in MySQL without recompiling or redeploying code.
                </p>
            </div>

            <!-- Settings Form Card -->
            <div class="fitness-card" style="max-width: 800px;">
                <form action="${pageContext.request.contextPath}/admin-actions/settings/save" method="POST">
                    <div class="row g-4">
                        <div class="col-12">
                            <label class="form-label-custom">Application Brand Name</label>
                            <input type="text" name="app_name" class="form-control-custom" value="${settings['app_name'] != null ? settings['app_name'] : 'FITFLOW Pro Fitness Tracker'}" required>
                            <small class="text-muted">Displays in page headers and navigation elements.</small>
                        </div>

                        <div class="col-12"><hr style="border-color: var(--border-color);"></div>

                        <div class="col-12">
                            <h6 class="text-white fw-bold mb-3">Feature Toggles & Governance</h6>
                            
                            <!-- Allow Registration Toggle -->
                            <div class="d-flex justify-content-between align-items-center mb-3 p-3 rounded-3" style="background-color: var(--bg-secondary); border: 1px solid var(--border-color);">
                                <div>
                                    <div class="text-white fw-bold">Public User Registration</div>
                                    <small class="text-secondary">Allow new members to register accounts freely.</small>
                                </div>
                                <div class="form-check form-switch fs-4 mb-0">
                                    <input class="form-check-input" type="checkbox" name="allow_registration" value="true" ${settings['allow_registration'] == 'true' ? 'checked' : ''}>
                                </div>
                            </div>

                            <!-- Challenges Toggle -->
                            <div class="d-flex justify-content-between align-items-center mb-3 p-3 rounded-3" style="background-color: var(--bg-secondary); border: 1px solid var(--border-color);">
                                <div>
                                    <div class="text-white fw-bold">Enable Community Challenges</div>
                                    <small class="text-secondary">Permit users to join global fitness competitions and log challenge milestones.</small>
                                </div>
                                <div class="form-check form-switch fs-4 mb-0">
                                    <input class="form-check-input" type="checkbox" name="challenges_enabled" value="true" ${settings['challenges_enabled'] == 'true' ? 'checked' : ''}>
                                </div>
                            </div>

                            <!-- Content Moderation Toggle -->
                            <div class="d-flex justify-content-between align-items-center mb-3 p-3 rounded-3" style="background-color: var(--bg-secondary); border: 1px solid var(--border-color);">
                                <div>
                                    <div class="text-white fw-bold">Require Content Moderation</div>
                                    <small class="text-secondary">Articles submitted by users require manual administrator approval before publication.</small>
                                </div>
                                <div class="form-check form-switch fs-4 mb-0">
                                    <input class="form-check-input" type="checkbox" name="content_moderation" value="true" ${settings['content_moderation'] == 'true' ? 'checked' : ''}>
                                </div>
                            </div>
                        </div>

                        <div class="col-12"><hr style="border-color: var(--border-color);"></div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Maximum Challenge Duration (Days)</label>
                            <input type="number" name="max_challenge_days" class="form-control-custom" value="${settings['max_challenge_days'] != null ? settings['max_challenge_days'] : '60'}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Default Baseline Daily Calorie Recommendation (kcal)</label>
                            <input type="number" name="default_calorie_target" class="form-control-custom" value="${settings['default_calorie_target'] != null ? settings['default_calorie_target'] : '2200'}" required>
                        </div>
                    </div>

                    <div class="mt-4 pt-3 border-top" style="border-color: var(--border-color) !important;">
                        <button type="submit" class="btn-accent">
                            <i class="fa-solid fa-floppy-disk"></i> Save System Settings
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
