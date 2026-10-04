<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar-overlay"></div>

<aside class="app-sidebar">
    <div class="sidebar-header">
        <div class="brand-logo-icon">
            <i class="fa-solid fa-bolt"></i>
        </div>
        <div class="brand-text">FIT<span>FLOW</span></div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section-title">Menu</div>
        
        <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-item-link ${activePage == 'dashboard' ? 'active' : ''}">
            <i class="fa-solid fa-house"></i>
            <span>Dashboard</span>
        </a>

        <a href="${pageContext.request.contextPath}/user/workouts" class="nav-item-link ${activePage == 'workouts' ? 'active' : ''}">
            <i class="fa-solid fa-dumbbell"></i>
            <span>Workouts</span>
        </a>

        <a href="${pageContext.request.contextPath}/user/progress" class="nav-item-link ${activePage == 'progress' ? 'active' : ''}">
            <i class="fa-solid fa-chart-simple"></i>
            <span>Progress</span>
        </a>

        <a href="${pageContext.request.contextPath}/user/goals" class="nav-item-link ${activePage == 'goals' ? 'active' : ''}">
            <i class="fa-solid fa-bullseye"></i>
            <span>Goals</span>
        </a>

        <a href="${pageContext.request.contextPath}/user/challenges" class="nav-item-link ${activePage == 'challenges' ? 'active' : ''}">
            <i class="fa-solid fa-trophy"></i>
            <span>Challenges</span>
        </a>

        <a href="${pageContext.request.contextPath}/user/content" class="nav-item-link ${activePage == 'content' ? 'active' : ''}">
            <i class="fa-solid fa-newspaper"></i>
            <span>Fitness Content</span>
        </a>

        <div class="nav-section-title mt-3">Account</div>

        <a href="${pageContext.request.contextPath}/user/profile" class="nav-item-link ${activePage == 'profile' ? 'active' : ''}">
            <i class="fa-solid fa-user"></i>
            <span>Profile</span>
        </a>

        <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item-link text-warning">
                <i class="fa-solid fa-shield-halved"></i>
                <span>Admin Panel</span>
            </a>
        </c:if>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link text-danger">
            <i class="fa-solid fa-arrow-right-from-bracket"></i>
            <span>Sign Out</span>
        </a>
    </div>
</aside>
