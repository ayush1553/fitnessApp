<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="FitFlow Pro - Elite Fitness Analytics Platform" scope="request"/>
<jsp:include page="includes/header.jsp"/>

<div class="min-vh-100 d-flex flex-column justify-content-between" style="background: radial-gradient(circle at top right, #161b17 0%, #080909 60%);">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg px-4 py-3 border-bottom" style="border-color: var(--border-color) !important; background: rgba(8,9,9,0.85); backdrop-filter: blur(10px);">
        <div class="container-fluid max-w-7xl">
            <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
                <div class="brand-logo-icon">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <div class="brand-text">FIT<span>FLOW</span></div>
            </a>
            
            <div class="d-flex align-items-center gap-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <a href="${pageContext.request.contextPath}${sessionScope.currentUser.dashboardRoute}" class="btn-accent">
                            <i class="fa-solid fa-gauge-high"></i> Open Dashboard
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn-outline-custom">
                            <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In
                        </a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn-accent">
                            <i class="fa-solid fa-user-plus"></i> Join Free
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <main class="container my-auto py-5">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <div class="badge-custom badge-accent mb-3">
                    <i class="fa-solid fa-circle-check"></i> Enterprise Java Web Application
                </div>
                <h1 class="display-4 fw-extrabold text-white mb-4" style="line-height: 1.15;">
                    Track Workouts. <br>
                    Crush Goals. <br>
                    <span style="color: var(--accent-primary);">Master Your Fitness.</span>
                </h1>
                <p class="lead mb-4" style="color: var(--text-secondary); max-width: 520px;">
                    Comprehensive fitness tracking and analytics built with Jakarta Servlets, JDBC, MySQL, and dynamic Chart.js dashboards.
                </p>
                
                <div class="d-flex flex-wrap gap-3 mb-5">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn-accent px-4 py-3" style="font-size: 1rem;">
                        <i class="fa-solid fa-bolt"></i> Get Started Free
                    </a>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn-outline-custom px-4 py-3" style="font-size: 1rem;">
                        <i class="fa-solid fa-arrow-right-to-bracket"></i> Explore Demo
                    </a>
                </div>

                <div class="row g-3 pt-3 border-top" style="border-color: var(--border-color) !important;">
                    <div class="col-4">
                        <div class="h3 fw-bold text-white mb-0">100%</div>
                        <small class="text-secondary">Pure Java + JDBC</small>
                    </div>
                    <div class="col-4">
                        <div class="h3 fw-bold text-white mb-0" style="color: var(--accent-primary) !important;">Real-Time</div>
                        <small class="text-secondary">Dynamic Charts</small>
                    </div>
                    <div class="col-4">
                        <div class="h3 fw-bold text-white mb-0">RBAC</div>
                        <small class="text-secondary">Admin & User Roles</small>
                    </div>
                </div>
            </div>

            <!-- Dashboard Preview Visual Card -->
            <div class="col-lg-6">
                <div class="fitness-card p-4 position-relative" style="box-shadow: var(--shadow-subtle);">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <span class="badge-custom badge-active mb-1">Live Metrics</span>
                            <h4 class="mb-0">Workout Activity</h4>
                        </div>
                        <span class="badge-custom badge-accent">6h 25m Total</span>
                    </div>

                    <!-- Mini bar preview -->
                    <div class="d-flex align-items-end justify-content-between gap-2 mb-4" style="height: 140px; padding-bottom: 8px;">
                        <div class="w-100 bg-secondary rounded-3 d-flex flex-column align-items-center justify-content-end p-1" style="height: 65%;">
                            <div class="w-100 rounded-2" style="background: var(--accent-primary); height: 75%;"></div>
                            <small class="mt-2 text-muted" style="font-size: 0.65rem;">Mon</small>
                        </div>
                        <div class="w-100 bg-secondary rounded-3 d-flex flex-column align-items-center justify-content-end p-1" style="height: 90%;">
                            <div class="w-100 rounded-2" style="background: var(--accent-primary); height: 90%;"></div>
                            <small class="mt-2 text-muted" style="font-size: 0.65rem;">Tue</small>
                        </div>
                        <div class="w-100 bg-secondary rounded-3 d-flex flex-column align-items-center justify-content-end p-1" style="height: 45%;">
                            <div class="w-100 rounded-2" style="background: var(--accent-primary); height: 50%;"></div>
                            <small class="mt-2 text-muted" style="font-size: 0.65rem;">Wed</small>
                        </div>
                        <div class="w-100 bg-secondary rounded-3 d-flex flex-column align-items-center justify-content-end p-1" style="height: 100%;">
                            <div class="w-100 rounded-2" style="background: var(--accent-primary); height: 100%;"></div>
                            <small class="mt-2 text-muted" style="font-size: 0.65rem;">Thu</small>
                        </div>
                        <div class="w-100 bg-secondary rounded-3 d-flex flex-column align-items-center justify-content-end p-1" style="height: 55%;">
                            <div class="w-100 rounded-2" style="background: var(--accent-primary); height: 60%;"></div>
                            <small class="mt-2 text-muted" style="font-size: 0.65rem;">Fri</small>
                        </div>
                        <div class="w-100 bg-secondary rounded-3 d-flex flex-column align-items-center justify-content-end p-1" style="height: 80%;">
                            <div class="w-100 rounded-2" style="background: var(--accent-primary); height: 85%;"></div>
                            <small class="mt-2 text-muted" style="font-size: 0.65rem;">Sat</small>
                        </div>
                        <div class="w-100 bg-secondary rounded-3 d-flex flex-column align-items-center justify-content-end p-1" style="height: 40%;">
                            <div class="w-100 rounded-2" style="background: var(--accent-primary); height: 40%;"></div>
                            <small class="mt-2 text-muted" style="font-size: 0.65rem;">Sun</small>
                        </div>
                    </div>

                    <!-- Quick Sample Credentials Box -->
                    <div class="p-3 rounded-3" style="background-color: var(--bg-secondary); border: 1px solid var(--border-color);">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="text-white fw-bold" style="font-size: 0.85rem;"><i class="fa-solid fa-key me-1 text-accent"></i> Development Credentials:</span>
                            <span class="badge-custom badge-warning">Demo Ready</span>
                        </div>
                        <div class="d-flex flex-wrap gap-2 text-secondary" style="font-size: 0.8rem;">
                            <div><strong>Admin:</strong> <code>admin@fitnesstracker.com</code> / <code>admin123</code></div>
                            <div>&bull;</div>
                            <div><strong>User:</strong> <code>adam.sterling@example.com</code> / <code>user123</code></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="border-top py-3 text-center" style="border-color: var(--border-color) !important;">
        <p class="mb-0 text-muted" style="font-size: 0.85rem;">
            Online Fitness Tracking and Progress Management Application &copy; 2026. Built with Java Servlets, JSP & MySQL.
        </p>
    </footer>
</div>

<jsp:include page="includes/footer.jsp"/>
