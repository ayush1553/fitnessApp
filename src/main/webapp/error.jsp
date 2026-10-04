<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Error Occurred - FitFlow Pro" scope="request"/>
<jsp:include page="includes/header.jsp"/>

<div class="min-vh-100 d-flex align-items-center justify-content-center p-4">
    <div class="fitness-card text-center p-5" style="max-width: 500px;">
        <div class="mb-3 text-danger" style="font-size: 3rem;">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
        <h3 class="mb-2 text-white">Oops! Something went wrong</h3>
        <p class="text-secondary mb-4">
            An unexpected error occurred while processing your request. Our system logged this event.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/user/dashboard" class="btn-accent">
                <i class="fa-solid fa-house"></i> Return to Dashboard
            </a>
            <a href="javascript:history.back()" class="btn-outline-custom">
                <i class="fa-solid fa-arrow-left"></i> Go Back
            </a>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp"/>
