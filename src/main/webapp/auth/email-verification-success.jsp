<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Email Verified - FitFlow Pro" scope="request"/>
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

        <!-- Verification Success Card -->
        <div class="fitness-card text-center p-4 p-md-5">
            <div class="mx-auto mb-4 d-inline-flex align-items-center justify-content-center rounded-circle" 
                 style="width: 80px; height: 80px; background: rgba(16, 185, 129, 0.15); border: 2px solid #10b981; color: #10b981; font-size: 38px; box-shadow: 0 0 25px rgba(16, 185, 129, 0.3);">
                <i class="fa-solid fa-circle-check"></i>
            </div>

            <h3 class="fw-bold mb-2 text-theme-primary">Email Verified!</h3>
            
            <p class="text-secondary mb-4" style="font-size: 0.95rem; line-height: 1.6;">
                ${not empty successMessage ? successMessage : 'Your email address has been successfully verified. Your FitFlow account is active and ready to use.'}
            </p>

            <a href="${pageContext.request.contextPath}/login.jsp" class="btn-accent w-100 justify-content-center py-2 fs-6">
                <i class="fa-solid fa-arrow-right-to-bracket me-2"></i> Sign In to Your Dashboard
            </a>
        </div>

    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
