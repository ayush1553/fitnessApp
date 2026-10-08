<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Activity Logs - Admin FitFlow Pro" scope="request"/>
<c:set var="activePage" value="admin-activity" scope="request"/>
<c:set var="greetingTitle" value="Activity Auditing" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header -->
            <div class="mb-4">
                <h3 class="mb-1 text-theme-primary">System Audit & Security Logs</h3>
                <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                    Chronological audit trail tracking all crucial platform operations, logins, and moderation actions.
                </p>
            </div>

            <!-- Logs Table -->
            <div class="fitness-card">
                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Timestamp</th>
                                <th>Action Event</th>
                                <th>Description / Details</th>
                                <th>Initiating User</th>
                                <th>Origin IP</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${logs}">
                                <tr>
                                    <td style="font-size: 0.8rem; color: var(--text-muted);"><fmt:formatDate value="${log.createdAt}" pattern="MMM dd, yyyy HH:mm:ss"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${log.action.contains('DELETE') || log.action.contains('REJECT')}">
                                                <span class="badge-custom badge-danger">${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action.contains('APPROVED') || log.action.contains('COMPLETED')}">
                                                <span class="badge-custom badge-completed">${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action.contains('LOGIN') || log.action.contains('REGISTER')}">
                                                <span class="badge-custom badge-active">${log.action}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-custom badge-accent">${log.action}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-theme-primary">${log.details}</td>
                                    <td>
                                        <div class="text-theme-primary">${empty log.userName ? 'System Daemon' : log.userName}</div>
                                        <c:if test="${not empty log.userEmail}">
                                            <small class="text-muted">${log.userEmail}</small>
                                        </c:if>
                                    </td>
                                    <td><code>${empty log.ipAddress ? '127.0.0.1' : log.ipAddress}</code></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
