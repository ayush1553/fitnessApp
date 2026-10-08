<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="User Management - Admin FitFlow Pro" scope="request"/>
<c:set var="activePage" value="admin-users" scope="request"/>
<c:set var="greetingTitle" value="User Management" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h3 class="mb-1 text-theme-primary">Platform Users</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        Inspect, modify account privileges, activate/deactivate, and audit registered members.
                    </p>
                </div>
            </div>

            <!-- Filter Search Bar -->
            <div class="fitness-card mb-4 p-3">
                <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="row g-2 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label-custom">Search Name or Email</label>
                        <input type="text" name="q" value="${selectedQuery}" class="form-control-custom" placeholder="Search users...">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label-custom">Filter Role</label>
                        <select name="role" class="form-control-custom">
                            <option value="ALL" ${selectedRole == 'ALL' ? 'selected' : ''}>All Roles</option>
                            <option value="USER" ${selectedRole == 'USER' ? 'selected' : ''}>USER</option>
                            <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label-custom">Filter Status</label>
                        <select name="status" class="form-control-custom">
                            <option value="ALL" ${selectedStatus == 'ALL' ? 'selected' : ''}>All Statuses</option>
                            <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                            <option value="INACTIVE" ${selectedStatus == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                            <option value="SUSPENDED" ${selectedStatus == 'SUSPENDED' ? 'selected' : ''}>SUSPENDED</option>
                        </select>
                    </div>
                    <div class="col-md-1 d-flex gap-1">
                        <button type="submit" class="btn-accent w-100 justify-content-center p-2"><i class="fa-solid fa-filter"></i></button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn-outline-custom p-2"><i class="fa-solid fa-rotate-left"></i></a>
                    </div>
                </form>
            </div>

            <!-- Users Table -->
            <div class="fitness-card">
                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Joined Date</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="avatar-circle">
                                                ${u.name.substring(0, 1)}
                                            </div>
                                            <div>
                                                <div class="text-theme-primary fw-bold">${u.name}</div>
                                                <small class="text-muted">${u.email}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 'ADMIN'}"><span class="badge-custom badge-warning"><i class="fa-solid fa-shield-halved"></i> ADMIN</span></c:when>
                                            <c:otherwise><span class="badge-custom badge-active">USER</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'ACTIVE'}"><span class="badge-custom badge-completed">ACTIVE</span></c:when>
                                            <c:when test="${u.status == 'SUSPENDED'}"><span class="badge-custom badge-danger">SUSPENDED</span></c:when>
                                            <c:otherwise><span class="badge-custom badge-warning">INACTIVE</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${u.createdAt}" pattern="MMM dd, yyyy"/></td>
                                    <td class="text-end">
                                        <div class="d-inline-flex gap-1">
                                            <!-- Status Toggle Form -->
                                            <form action="${pageContext.request.contextPath}/admin-actions/user/status" method="POST" class="d-inline">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <c:choose>
                                                    <c:when test="${u.status == 'ACTIVE'}">
                                                        <input type="hidden" name="status" value="INACTIVE">
                                                        <button type="submit" class="btn btn-sm btn-outline-custom p-1 px-2" title="Deactivate">
                                                            <i class="fa-solid fa-ban text-warning"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="status" value="ACTIVE">
                                                        <button type="submit" class="btn btn-sm btn-outline-custom p-1 px-2" title="Activate">
                                                            <i class="fa-solid fa-circle-check text-success"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>

                                            <!-- Role Toggle Form -->
                                            <form action="${pageContext.request.contextPath}/admin-actions/user/role" method="POST" class="d-inline"
                                                  onsubmit="return confirm('Change user role?');">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <c:choose>
                                                    <c:when test="${u.role == 'ADMIN'}">
                                                        <input type="hidden" name="role" value="USER">
                                                        <button type="submit" class="btn btn-sm btn-outline-custom p-1 px-2" title="Demote to USER">
                                                            <i class="fa-solid fa-user-minus"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="role" value="ADMIN">
                                                        <button type="submit" class="btn btn-sm btn-outline-custom p-1 px-2" title="Promote to ADMIN">
                                                            <i class="fa-solid fa-user-shield text-warning"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>

                                            <!-- Delete User Form -->
                                            <c:if test="${u.id != sessionScope.currentUser.id}">
                                                <form action="${pageContext.request.contextPath}/admin-actions/user/delete" method="POST" class="d-inline"
                                                      onsubmit="return confirm('PERMANENTLY delete user ${u.name}? All associated workout logs and goals will be wiped.');">
                                                    <input type="hidden" name="userId" value="${u.id}">
                                                    <button type="submit" class="btn btn-sm btn-danger-custom p-1 px-2" title="Delete User">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
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
