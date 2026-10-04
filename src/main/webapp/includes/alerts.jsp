<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Session Flash Message --%>
<c:if test="${not empty sessionScope.flashMessage}">
    <div class="alert-custom alert-custom-${sessionScope.flashMessage.type.cssClass}">
        <i class="fa-solid ${sessionScope.flashMessage.type.iconClass}"></i>
        <div>${sessionScope.flashMessage.message}</div>
    </div>
    <c:remove var="flashMessage" scope="session"/>
</c:if>

<%-- Request-scoped error/success messages --%>
<c:if test="${not empty requestScope.errorMessage}">
    <div class="alert-custom alert-custom-danger">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <div>${requestScope.errorMessage}</div>
    </div>
</c:if>

<c:if test="${not empty requestScope.successMessage}">
    <div class="alert-custom alert-custom-success">
        <i class="fa-solid fa-circle-check"></i>
        <div>${requestScope.successMessage}</div>
    </div>
</c:if>
