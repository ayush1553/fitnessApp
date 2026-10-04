<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Page Not Found - FitFlow Pro" scope="request"/>
<jsp:include page="includes/header.jsp"/>

<div class="min-vh-100 d-flex align-items-center justify-content-center p-4">
    <div class="fitness-card text-center p-5" style="max-width: 500px;">
        <div class="mb-3" style="font-size: 3.5rem; color: var(--accent-primary);">
            <i class="fa-solid fa-magnifying-glass-location"></i>
        </div>
        <h2 class="display-6 fw-bold text-white mb-2">404</h2>
        <h4 class="text-white mb-2">Page Not Found</h4>
        <p class="text-secondary mb-4">
            The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/user/dashboard" class="btn-accent">
                <i class="fa-solid fa-house"></i> Go to Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn-outline-custom">
                <i class="fa-solid fa-earth-americas"></i> Home
            </a>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp"/>
