<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Forgot Password - FitFlow Pro" scope="request"/>
<jsp:include page="../includes/header.jsp"/>

<div class="min-vh-100 d-flex align-items-center justify-content-center p-3 position-relative" style="z-index: 1;">
    <div class="w-100" style="max-width: 460px;">
        
        <!-- Logo -->
        <div class="text-center mb-4">
            <a href="${pageContext.request.contextPath}/" class="d-inline-flex align-items-center gap-2 text-decoration-none">
                <div class="brand-logo-icon">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <div class="brand-text fs-3">FIT<span>FLOW</span></div>
            </a>
            <p class="text-secondary mt-2 mb-0" style="font-size: 0.9rem;">Reset your account password</p>
        </div>

        <!-- Alert Notifications -->
        <jsp:include page="../includes/alerts.jsp"/>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                <i class="fa-solid fa-circle-exclamation"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <!-- Forgot Password Card -->
        <div class="fitness-card">
            <div class="text-center mb-4">
                <div class="mx-auto mb-3 d-inline-flex align-items-center justify-content-center rounded-circle" 
                     style="width: 64px; height: 64px; background: rgba(234, 179, 8, 0.12); border: 1px solid rgba(234, 179, 8, 0.3); color: #eab308; font-size: 26px;">
                    <i class="fa-solid fa-key"></i>
                </div>
                <h4 class="fw-bold text-theme-primary mb-1">Forgot Your Password?</h4>
                <p class="text-secondary mb-0" style="font-size: 0.85rem; line-height: 1.5;">
                    Enter your registered email address and we'll send you a link to reset your password.
                </p>
            </div>

            <form action="${pageContext.request.contextPath}/forgot-password" method="POST" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label class="form-label-custom" for="resetEmail">Email Address</label>
                    <input type="email" id="resetEmail" name="email" class="form-control-custom" 
                           value="${not empty email ? email : (param.email != null ? param.email : '')}" 
                           placeholder="you@example.com" required autocomplete="email">
                </div>

                <button type="submit" id="resetBtn" class="btn-accent w-100 justify-content-center py-2 mb-3"
                        <c:if test="${not empty cooldownRemaining and cooldownRemaining > 0}">disabled</c:if>>
                    <i class="fa-solid fa-paper-plane me-2"></i> 
                    <span id="btnText">
                        <c:choose>
                            <c:when test="${not empty cooldownRemaining and cooldownRemaining > 0}">
                                Please wait ${cooldownRemaining}s
                            </c:when>
                            <c:otherwise>
                                Send Reset Link
                            </c:otherwise>
                        </c:choose>
                    </span>
                </button>
            </form>

            <div class="text-center pt-2 border-top" style="border-color: var(--border-color) !important;">
                <p class="text-secondary mb-0" style="font-size: 0.85rem;">
                    Remembered your password? <a href="${pageContext.request.contextPath}/login.jsp" class="text-accent fw-semibold">Sign In</a>
                </p>
            </div>
        </div>

    </div>
</div>

<c:if test="${not empty cooldownRemaining and cooldownRemaining > 0}">
<script>
    (function() {
        let remaining = parseInt('${cooldownRemaining}', 10);
        const btn = document.getElementById('resetBtn');
        const btnText = document.getElementById('btnText');
        if (!btn || !btnText) return;

        const interval = setInterval(() => {
            remaining--;
            if (remaining <= 0) {
                clearInterval(interval);
                btn.removeAttribute('disabled');
                btnText.textContent = 'Send Reset Link';
            } else {
                btnText.textContent = 'Please wait ' + remaining + 's';
            }
        }, 1000);
    })();
</script>
</c:if>

<jsp:include page="../includes/footer.jsp"/>
