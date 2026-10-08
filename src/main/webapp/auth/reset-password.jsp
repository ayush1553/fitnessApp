<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Set New Password - FitFlow Pro" scope="request"/>
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
            <p class="text-secondary mt-2 mb-0" style="font-size: 0.9rem;">Set a new secure password</p>
        </div>

        <!-- Alert Notifications -->
        <jsp:include page="../includes/alerts.jsp"/>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                <i class="fa-solid fa-circle-exclamation"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <!-- Reset Form Card -->
        <div class="fitness-card">
            <div class="text-center mb-4">
                <div class="mx-auto mb-3 d-inline-flex align-items-center justify-content-center rounded-circle" 
                     style="width: 64px; height: 64px; background: rgba(16, 185, 129, 0.12); border: 1px solid rgba(16, 185, 129, 0.3); color: #10b981; font-size: 26px;">
                    <i class="fa-solid fa-lock"></i>
                </div>
                <h4 class="fw-bold text-theme-primary mb-1">Create New Password</h4>
                <p class="text-secondary mb-0" style="font-size: 0.85rem;">
                    Please enter your new password below.
                </p>
            </div>

            <form action="${pageContext.request.contextPath}/reset-password" method="POST" class="needs-validation" novalidate>
                <input type="hidden" name="token" value="${token}">

                <div class="mb-3">
                    <label class="form-label-custom" for="newPass">New Password</label>
                    <input type="password" id="newPass" name="password" class="form-control-custom" 
                           placeholder="Min 6 characters" required minlength="6" autocomplete="new-password">
                </div>

                <div class="mb-4">
                    <label class="form-label-custom" for="confirmPass">Confirm New Password</label>
                    <input type="password" id="confirmPass" name="confirmPassword" class="form-control-custom" 
                           placeholder="Re-enter new password" required minlength="6" autocomplete="new-password">
                </div>

                <button type="submit" class="btn-accent w-100 justify-content-center py-2 mb-3">
                    <i class="fa-solid fa-check me-2"></i> Update Password
                </button>
            </form>

            <div class="text-center pt-2 border-top" style="border-color: var(--border-color) !important;">
                <p class="text-secondary mb-0" style="font-size: 0.85rem;">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="text-accent fw-semibold">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back to Sign In
                    </a>
                </p>
            </div>
        </div>

    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
