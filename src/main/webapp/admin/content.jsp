<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Content Moderation - Admin FitFlow Pro" scope="request"/>
<c:set var="activePage" value="admin-content" scope="request"/>
<c:set var="greetingTitle" value="Content Moderation" scope="request"/>

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
                    <h3 class="mb-1 text-theme-primary">Fitness Content Moderation Queue</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        Review community submissions, approve quality fitness routines, or provide rejection feedback.
                    </p>
                </div>
                <span class="badge-custom badge-warning fs-6">
                    <i class="fa-solid fa-clock me-1"></i> ${pendingCount} Pending Review
                </span>
            </div>

            <!-- Content Submissions Table -->
            <div class="fitness-card">
                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th style="width: 70px;">Cover</th>
                                <th>Article Title</th>
                                <th>Author</th>
                                <th>Category</th>
                                <th>Submitted Date</th>
                                <th>Status</th>
                                <th class="text-end">Moderation Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${allContent}">
                                <tr>
                                    <td style="width: 70px;">
                                        <div style="width: 60px; height: 42px; border-radius: 6px; overflow: hidden; background: #121513;">
                                            <img src="${pageContext.request.contextPath}/${c.imageUrl}" 
                                                 alt="${c.title}" 
                                                 style="width: 100%; height: 100%; object-fit: cover;"
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/strength-training.webp';">
                                        </div>
                                    </td>
                                    <td>
                                        <div class="text-theme-primary fw-bold mb-1">${c.title}</div>
                                        <small class="text-secondary" style="font-size: 0.8rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            ${c.description}
                                        </small>
                                    </td>
                                    <td>
                                        <div class="text-theme-primary">${c.authorName}</div>
                                        <small class="text-muted">${c.authorEmail}</small>
                                    </td>
                                    <td><span class="badge-custom badge-active">${c.category}</span></td>
                                    <td><fmt:formatDate value="${c.createdAt}" pattern="MMM dd, yyyy"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${c.status == 'APPROVED'}"><span class="badge-custom badge-completed">APPROVED</span></c:when>
                                            <c:when test="${c.status == 'REJECTED'}"><span class="badge-custom badge-danger">REJECTED</span></c:when>
                                            <c:otherwise><span class="badge-custom badge-warning">PENDING</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-inline-flex gap-1">
                                            <a href="${pageContext.request.contextPath}/user/content/view?id=${c.id}" 
                                               target="_blank" class="btn btn-sm btn-outline-custom p-1 px-2" title="View Full Article">
                                                <i class="fa-solid fa-arrow-up-right-from-square"></i> View
                                            </a>
                                            <c:if test="${c.status != 'APPROVED'}">
                                                <form action="${pageContext.request.contextPath}/admin-actions/content/approve" method="POST" class="d-inline">
                                                    <input type="hidden" name="contentId" value="${c.id}">
                                                    <button type="submit" class="btn btn-sm btn-accent p-1 px-2" title="Approve">
                                                        <i class="fa-solid fa-check"></i> Approve
                                                    </button>
                                                </form>
                                            </c:if>

                                            <c:if test="${c.status != 'REJECTED'}">
                                                <button type="button" class="btn btn-sm btn-outline-custom p-1 px-2 text-warning"
                                                        onclick="openRejectModal('${c.id}', '${c.title}')" title="Reject with Reason">
                                                    <i class="fa-solid fa-ban"></i> Reject
                                                </button>
                                            </c:if>

                                            <form action="${pageContext.request.contextPath}/admin-actions/content/delete" method="POST" class="d-inline"
                                                  onsubmit="return confirm('Delete this article submission permanently?');">
                                                <input type="hidden" name="contentId" value="${c.id}">
                                                <button type="submit" class="btn btn-sm btn-danger-custom p-1 px-2" title="Delete">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </form>
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

<!-- Modal: Rejection Feedback -->
<div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-theme-primary"><i class="fa-solid fa-triangle-exclamation text-warning me-2"></i> Reject Content Submission</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin-actions/content/reject" method="POST">
                <input type="hidden" name="contentId" id="rejectContentId">
                <div class="modal-body p-4">
                    <p class="text-theme-primary mb-2" id="rejectArticleTitle"></p>
                    <label class="form-label-custom">Reason for Rejection (Visible to user)</label>
                    <textarea name="reason" class="form-control-custom" rows="3" placeholder="e.g. Needs more detailed instructions or formatting adjustments..." required></textarea>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger-custom"><i class="fa-solid fa-ban"></i> Confirm Rejection</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openRejectModal(id, title) {
        const modal = document.getElementById('rejectModal');
        modal.querySelector('#rejectContentId').value = id;
        modal.querySelector('#rejectArticleTitle').innerText = 'Article: ' + title;
        new bootstrap.Modal(modal).show();
    }
</script>

<jsp:include page="../includes/footer.jsp"/>
