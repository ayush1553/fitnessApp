<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Sign In - FitFlow Pro" scope="request"/>
<jsp:include page="includes/header.jsp"/>

<div class="min-vh-100 d-flex align-items-center justify-content-center p-3" style="background: radial-gradient(circle at center, #151817 0%, #080909 70%);">
    <div class="w-100" style="max-width: 440px;">
        
        <!-- Logo -->
        <div class="text-center mb-4">
            <a href="${pageContext.request.contextPath}/" class="d-inline-flex align-items-center gap-2 text-decoration-none">
                <div class="brand-logo-icon">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <div class="brand-text fs-3">FIT<span>FLOW</span></div>
            </a>
            <p class="text-secondary mt-2 mb-0" style="font-size: 0.9rem;">Sign in to your fitness dashboard</p>
        </div>

        <!-- Alert Notifications -->
        <jsp:include page="includes/alerts.jsp"/>

        <!-- Login Card -->
        <div class="fitness-card">
            <form action="${pageContext.request.contextPath}/auth/login" method="POST" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label class="form-label-custom" for="loginEmail">Email Address</label>
                    <div class="input-group">
                        <input type="email" id="loginEmail" name="email" class="form-control-custom" 
                               value="${param.email != null ? param.email : ''}" 
                               placeholder="you@example.com" required autocomplete="email">
                    </div>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label class="form-label-custom mb-0" for="loginPassword">Password</label>
                    </div>
                    <input type="password" id="loginPassword" name="password" class="form-control-custom" 
                           placeholder="Enter your password" required autocomplete="current-password">
                </div>

                <button type="submit" class="btn-accent w-100 justify-content-center py-2 mb-3">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In
                </button>
            </form>

            <div class="text-center pt-2 border-top" style="border-color: var(--border-color) !important;">
                <p class="text-secondary mb-0" style="font-size: 0.85rem;">
                    Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp" class="text-accent fw-semibold">Sign Up</a>
                </p>
            </div>
        </div>

        <!-- Quick Demo Accounts Auto-Fill Buttons -->
        <div class="p-3 mt-3 rounded-3" style="background-color: var(--bg-card); border: 1px dashed var(--border-color);">
            <div class="text-muted fw-semibold mb-2" style="font-size: 0.75rem; text-transform: uppercase;">Quick Demo Sign-In</div>
            <div class="d-flex gap-2">
                <button type="button" class="btn btn-sm btn-outline-secondary w-100 text-white" onclick="fillCredentials('adam.sterling@example.com', 'user123')">
                    <i class="fa-solid fa-user me-1 text-accent"></i> User Demo
                </button>
                <button type="button" class="btn btn-sm btn-outline-secondary w-100 text-white" onclick="fillCredentials('admin@fitnesstracker.com', 'admin123')">
                    <i class="fa-solid fa-shield-halved me-1 text-warning"></i> Admin Demo
                </button>
            </div>
        </div>

    </div>
</div>

<script>
    function fillCredentials(email, password) {
        document.getElementById('loginEmail').value = email;
        document.getElementById('loginPassword').value = password;
    }
</script>

<jsp:include page="includes/footer.jsp"/>
