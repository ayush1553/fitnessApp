<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar-overlay"></div>
<div class="sidebar-edge-trigger" id="sidebarEdgeTrigger" aria-hidden="true"></div>

<aside class="app-sidebar">
    <div class="sidebar-header">
        <div class="brand-logo-icon bg-warning text-dark">
            <i class="fa-solid fa-shield-halved"></i>
        </div>
        <div class="brand-text">ADMIN<span>FLOW</span></div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section-title">Administration</div>
        
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item-link ${activePage == 'admin-dashboard' ? 'active' : ''}">
            <i class="fa-solid fa-chart-pie"></i>
            <span>Dashboard</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin/users" class="nav-item-link ${activePage == 'admin-users' ? 'active' : ''}">
            <i class="fa-solid fa-users"></i>
            <span>Users</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin/content" class="nav-item-link ${activePage == 'admin-content' ? 'active' : ''}">
            <i class="fa-solid fa-newspaper"></i>
            <span>Fitness Content</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin/challenges" class="nav-item-link ${activePage == 'admin-challenges' ? 'active' : ''}">
            <i class="fa-solid fa-trophy"></i>
            <span>Challenges</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin/statistics" class="nav-item-link ${activePage == 'admin-stats' ? 'active' : ''}">
            <i class="fa-solid fa-chart-line"></i>
            <span>Statistics</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin/activity" class="nav-item-link ${activePage == 'admin-activity' ? 'active' : ''}">
            <i class="fa-solid fa-clock-rotate-left"></i>
            <span>Activity Logs</span>
        </a>

        <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item-link ${activePage == 'admin-settings' ? 'active' : ''}">
            <i class="fa-solid fa-sliders"></i>
            <span>System Settings</span>
        </a>

        <div class="nav-section-title mt-3">Portal Switch</div>

        <a href="${pageContext.request.contextPath}/user/customize" class="nav-item-link ${activePage == 'customize' ? 'active' : ''}">
            <i class="fa-solid fa-palette"></i>
            <span>Customize</span>
        </a>

        <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-item-link">
            <i class="fa-solid fa-arrow-left"></i>
            <span>User View</span>
        </a>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link text-danger">
            <i class="fa-solid fa-arrow-right-from-bracket"></i>
            <span>Sign Out</span>
        </a>
    </div>
</aside>
