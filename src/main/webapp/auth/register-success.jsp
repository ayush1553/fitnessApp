<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Verify Your Email - FitFlow Pro" scope="request"/>
<jsp:include page="../includes/header.jsp"/>

<div class="min-vh-100 d-flex align-items-center justify-content-center p-3 position-relative" style="z-index: 1;">
    <div class="w-100" style="max-width: 500px;">
        
        <!-- Logo -->
        <div class="text-center mb-4">
            <a href="${pageContext.request.contextPath}/" class="d-inline-flex align-items-center gap-2 text-decoration-none">
                <div class="brand-logo-icon">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <div class="brand-text fs-3">FIT<span>FLOW</span></div>
            </a>
        </div>

        <!-- Success Verification Card -->
        <div class="fitness-card text-center p-4 p-md-5">
            <div class="mx-auto mb-4 d-inline-flex align-items-center justify-content-center rounded-circle" 
                 style="width: 80px; height: 80px; background: rgba(16, 185, 129, 0.12); border: 1px solid rgba(16, 185, 129, 0.3); color: #10b981; font-size: 36px;">
                <i class="fa-solid fa-envelope-circle-check"></i>
            </div>

            <h3 class="fw-bold mb-2 text-theme-primary">Check Your Inbox</h3>
            
            <p class="text-secondary mb-3" style="font-size: 0.95rem; line-height: 1.6;">
                We have sent a verification link to<br>
                <strong class="text-accent fs-6">${not empty email ? email : 'your email address'}</strong>
            </p>

            <div class="p-3 mb-4 rounded-3 text-start" style="background: rgba(255, 255, 255, 0.03); border: 1px solid var(--border-color);">
                <div class="d-flex align-items-center gap-2 text-theme-primary fw-semibold mb-1" style="font-size: 0.85rem;">
                    <i class="fa-solid fa-clock text-warning"></i> Link Expires in 24 Hours
                </div>
                <p class="text-secondary mb-0" style="font-size: 0.8rem; line-height: 1.4;">
                    Please click the link in the email to activate your account. If you don't see it, check your spam or promotions folder.
                </p>
            </div>

            <div class="d-flex flex-column gap-2">
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-accent w-100 justify-content-center py-2">
                    <i class="fa-solid fa-arrow-right-to-bracket me-2"></i> Go to Sign In
                </a>
                <a href="${pageContext.request.contextPath}/resend-verification?email=${not empty email ? email : ''}" class="btn btn-outline-secondary w-100 py-2 text-theme-primary" style="border-color: var(--border-color); font-size: 0.9rem;">
                    <i class="fa-solid fa-rotate-right me-2"></i> Didn't receive email? Resend
                </a>
            </div>
        </div>

    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
