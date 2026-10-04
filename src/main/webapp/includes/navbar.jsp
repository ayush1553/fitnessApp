<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="app-topbar">
    <div class="d-flex align-items-center gap-3">
        <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle navigation menu">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="topbar-greeting">
            <h2>${greetingTitle != null ? greetingTitle : "Good Day"}</h2>
            <p>Welcome back, <strong class="text-white">${sessionScope.currentUser.name}</strong></p>
        </div>
    </div>

    <div class="topbar-actions">
        <div class="search-input-wrapper">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" class="form-control-custom" placeholder="Quick search metrics..." aria-label="Search">
        </div>

        <div class="dropdown">
            <div class="user-profile-menu" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="avatar-circle">
                    ${sessionScope.currentUser.name.substring(0, 1)}
                </div>
                <div class="user-meta-name">
                    ${sessionScope.currentUser.name}
                </div>
                <i class="fa-solid fa-chevron-down text-muted" style="font-size: 0.75rem; margin-left: 0.25rem;"></i>
            </div>
            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark" style="background-color: var(--bg-card); border-color: var(--border-color); border-radius: var(--radius-md);">
                <li>
                    <h6 class="dropdown-header text-muted" style="font-size: 0.75rem;">Signed in as</h6>
                    <span class="dropdown-item-text text-white fw-bold" style="font-size: 0.85rem;">${sessionScope.currentUser.email}</span>
                </li>
                <li><hr class="dropdown-divider" style="border-color: var(--border-color);"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile"><i class="fa-solid fa-user me-2 text-accent"></i> My Profile</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/workouts"><i class="fa-solid fa-dumbbell me-2 text-accent"></i> My Workouts</a></li>
                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                    <li><a class="dropdown-item text-warning" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-shield-halved me-2"></i> Admin Panel</a></li>
                </c:if>
                <li><hr class="dropdown-divider" style="border-color: var(--border-color);"></li>
                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Sign Out</a></li>
            </ul>
        </div>
    </div>
</header>
