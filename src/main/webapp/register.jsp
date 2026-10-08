<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Create Account - FitFlow Pro" scope="request"/>
<jsp:include page="includes/header.jsp"/>

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
            <p class="text-secondary mt-2 mb-0" style="font-size: 0.9rem;">Start your fitness journey today</p>
        </div>

        <!-- Alert Notifications -->
        <jsp:include page="includes/alerts.jsp"/>

        <!-- Register Card -->
        <div class="fitness-card">
            <form action="${pageContext.request.contextPath}/auth/register" method="POST" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label class="form-label-custom" for="regName">Full Name</label>
                    <input type="text" id="regName" name="name" class="form-control-custom" 
                           value="${param.name != null ? param.name : ''}"
                           placeholder="e.g. Alex Morgan" required>
                </div>

                <div class="mb-3">
                    <label class="form-label-custom" for="regEmail">Email Address</label>
                    <input type="email" id="regEmail" name="email" class="form-control-custom" 
                           value="${param.email != null ? param.email : ''}"
                           placeholder="alex@example.com" required autocomplete="email">
                </div>

                <div class="row g-2 mb-3">
                    <div class="col-sm-6">
                        <label class="form-label-custom" for="regPassword">Password</label>
                        <input type="password" id="regPassword" name="password" class="form-control-custom" 
                               placeholder="Min 6 characters" required minlength="6" autocomplete="new-password">
                    </div>
                    <div class="col-sm-6">
                        <label class="form-label-custom" for="regConfirmPassword">Confirm Password</label>
                        <input type="password" id="regConfirmPassword" name="confirmPassword" class="form-control-custom" 
                               placeholder="Re-enter password" required minlength="6" autocomplete="new-password">
                    </div>
                </div>

                <button type="submit" class="btn-accent w-100 justify-content-center py-2 mb-3">
                    <i class="fa-solid fa-user-plus"></i> Create Account
                </button>
            </form>

            <div class="text-center pt-2 border-top" style="border-color: var(--border-color) !important;">
                <p class="text-secondary mb-0" style="font-size: 0.85rem;">
                    Already have an account? <a href="${pageContext.request.contextPath}/login.jsp" class="text-accent fw-semibold">Sign In</a>
                </p>
            </div>
        </div>

    </div>
</div>

<jsp:include page="includes/footer.jsp"/>
