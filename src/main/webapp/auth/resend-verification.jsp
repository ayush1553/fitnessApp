<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Resend Verification - FitFlow Pro" scope="request"/>
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
            <p class="text-secondary mt-2 mb-0" style="font-size: 0.9rem;">Resend Account Verification Email</p>
        </div>

        <!-- Alert Notifications -->
        <jsp:include page="../includes/alerts.jsp"/>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                <i class="fa-solid fa-circle-exclamation"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <!-- Resend Card -->
        <div class="fitness-card">
            <form action="${pageContext.request.contextPath}/resend-verification" method="POST" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label class="form-label-custom" for="resendEmail">Email Address</label>
                    <input type="email" id="resendEmail" name="email" class="form-control-custom" 
                           value="${not empty email ? email : (param.email != null ? param.email : '')}" 
                           placeholder="you@example.com" required autocomplete="email">
                </div>

                <div class="p-3 mb-4 rounded-3" style="background: rgba(255, 255, 255, 0.03); border: 1px solid var(--border-color);">
                    <p class="text-secondary mb-0" style="font-size: 0.8rem; line-height: 1.4;">
                        Enter the email associated with your account and we will send a fresh verification link valid for 24 hours.
                    </p>
                </div>

                <button type="submit" id="resendBtn" class="btn-accent w-100 justify-content-center py-2 mb-3"
                        <c:if test="${not empty cooldownRemaining and cooldownRemaining > 0}">disabled</c:if>>
                    <i class="fa-solid fa-paper-plane me-2"></i> 
                    <span id="btnText">
                        <c:choose>
                            <c:when test="${not empty cooldownRemaining and cooldownRemaining > 0}">
                                Please wait ${cooldownRemaining}s
                            </c:when>
                            <c:otherwise>
                                Send Verification Link
                            </c:otherwise>
                        </c:choose>
                    </span>
                </button>
            </form>

            <div class="text-center pt-2 border-top" style="border-color: var(--border-color) !important;">
                <p class="text-secondary mb-0" style="font-size: 0.85rem;">
                    Remembered your login? <a href="${pageContext.request.contextPath}/login.jsp" class="text-accent fw-semibold">Sign In</a>
                </p>
            </div>
        </div>

    </div>
</div>

<c:if test="${not empty cooldownRemaining and cooldownRemaining > 0}">
<script>
    (function() {
        let remaining = parseInt('${cooldownRemaining}', 10);
        const btn = document.getElementById('resendBtn');
        const btnText = document.getElementById('btnText');
        if (!btn || !btnText) return;

        const interval = setInterval(() => {
            remaining--;
            if (remaining <= 0) {
                clearInterval(interval);
                btn.removeAttribute('disabled');
                btnText.textContent = 'Send Verification Link';
            } else {
                btnText.textContent = 'Please wait ' + remaining + 's';
            }
        }, 1000);
    })();
</script>
</c:if>

<jsp:include page="../includes/footer.jsp"/>
