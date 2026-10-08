<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Verification Failed - FitFlow Pro" scope="request"/>
<jsp:include page="../includes/header.jsp"/>

<div class="min-vh-100 d-flex align-items-center justify-content-center p-3 position-relative" style="z-index: 1;">
    <div class="w-100" style="max-width: 480px;">
        
        <!-- Logo -->
        <div class="text-center mb-4">
            <a href="${pageContext.request.contextPath}/" class="d-inline-flex align-items-center gap-2 text-decoration-none">
                <div class="brand-logo-icon">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <div class="brand-text fs-3">FIT<span>FLOW</span></div>
            </a>
        </div>

        <!-- Verification Error Card -->
        <div class="fitness-card text-center p-4 p-md-5">
            <div class="mx-auto mb-4 d-inline-flex align-items-center justify-content-center rounded-circle" 
                 style="width: 80px; height: 80px; background: rgba(239, 68, 68, 0.12); border: 2px solid rgba(239, 68, 68, 0.4); color: #ef4444; font-size: 38px;">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>

            <h3 class="fw-bold mb-2 text-theme-primary">${not empty errorTitle ? errorTitle : 'Verification Link Invalid'}</h3>
            
            <p class="text-secondary mb-4" style="font-size: 0.95rem; line-height: 1.6;">
                ${not empty errorMessage ? errorMessage : 'The email verification link is invalid, has expired (after 24 hours), or has already been used.'}
            </p>

            <div class="d-flex flex-column gap-2">
                <a href="${pageContext.request.contextPath}/resend-verification" class="btn-accent w-100 justify-content-center py-2">
                    <i class="fa-solid fa-rotate-right me-2"></i> Request New Verification Link
                </a>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-secondary w-100 py-2 text-theme-primary" style="border-color: var(--border-color); font-size: 0.9rem;">
                    <i class="fa-solid fa-arrow-left me-2"></i> Return to Sign In
                </a>
            </div>
        </div>

    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
