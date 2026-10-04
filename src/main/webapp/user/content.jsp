<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Fitness Content & Articles - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="content" scope="request"/>
<c:set var="greetingTitle" value="Fitness Community" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header Toolbar -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h3 class="mb-1 text-white">Fitness Content & Community Articles</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        Discover training guides, nutritional tips, recovery practices, and share your own knowledge.
                    </p>
                </div>
                <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#submitContentModal">
                    <i class="fa-solid fa-pen-nib"></i> Submit Article
                </button>
            </div>

            <!-- Category Filter Tabs -->
            <div class="d-flex flex-wrap gap-2 mb-4 pb-2 border-bottom" style="border-color: var(--border-color) !important;">
                <a href="${pageContext.request.contextPath}/user/content" 
                   class="btn btn-sm ${empty selectedCategory || selectedCategory == 'ALL' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                    All Categories
                </a>
                <a href="${pageContext.request.contextPath}/user/content?category=Workout+Routines" 
                   class="btn btn-sm ${selectedCategory == 'Workout Routines' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                    <i class="fa-solid fa-dumbbell me-1"></i> Workout Routines
                </a>
                <a href="${pageContext.request.contextPath}/user/content?category=Nutrition+%26+Diet" 
                   class="btn btn-sm ${selectedCategory == 'Nutrition & Diet' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                    <i class="fa-solid fa-apple-whole me-1"></i> Nutrition & Diet
                </a>
                <a href="${pageContext.request.contextPath}/user/content?category=Cardio+%26+Endurance" 
                   class="btn btn-sm ${selectedCategory == 'Cardio & Endurance' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                    <i class="fa-solid fa-person-running me-1"></i> Cardio & Endurance
                </a>
                <a href="${pageContext.request.contextPath}/user/content?category=Recovery+%26+Wellness" 
                   class="btn btn-sm ${selectedCategory == 'Recovery & Wellness' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                    <i class="fa-solid fa-spa me-1"></i> Recovery & Wellness
                </a>
                <a href="${pageContext.request.contextPath}/user/content?category=Motivation" 
                   class="btn btn-sm ${selectedCategory == 'Motivation' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                    <i class="fa-solid fa-fire me-1"></i> Motivation
                </a>
            </div>

            <!-- Published Articles Grid -->
            <div class="row g-4 mb-5">
                <c:choose>
                    <c:when test="${not empty articles}">
                        <c:forEach var="art" items="${articles}">
                            <div class="col-lg-4 col-md-6">
                                <div class="fitness-card h-100 d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="badge-custom badge-accent">${art.category}</span>
                                            <small class="text-muted"><fmt:formatDate value="${art.createdAt}" pattern="MMM d, yyyy"/></small>
                                        </div>
                                        <h5 class="text-white fw-bold mb-2">${art.title}</h5>
                                        <p class="text-secondary mb-3" style="font-size: 0.88rem; line-height: 1.6;">
                                            ${art.description}
                                        </p>
                                    </div>
                                    <div class="pt-3 border-top d-flex align-items-center justify-content-between" style="border-color: var(--border-color) !important;">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="avatar-circle" style="width: 28px; height: 28px; font-size: 0.75rem;">
                                                ${empty art.authorName ? 'A' : art.authorName.substring(0, 1)}
                                            </div>
                                            <small class="text-secondary">${empty art.authorName ? 'Anonymous' : art.authorName}</small>
                                        </div>
                                        <span class="badge-custom badge-completed">
                                            <i class="fa-solid fa-check"></i> Verified
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5 text-muted">
                            <i class="fa-solid fa-newspaper fs-1 mb-3"></i>
                            <h5 class="text-white">No articles published yet</h5>
                            <p>Be the first member to submit a guide or routine to the community.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- User's Personal Submissions Section -->
            <c:if test="${not empty userSubmissions}">
                <div class="fitness-card">
                    <h5 class="text-white fw-bold mb-3"><i class="fa-solid fa-file-pen text-accent me-2"></i> Your Submitted Articles</h5>
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Admin Feedback</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sub" items="${userSubmissions}">
                                    <tr>
                                        <td class="text-white fw-bold">${sub.title}</td>
                                        <td><span class="badge-custom badge-active">${sub.category}</span></td>
                                        <td><fmt:formatDate value="${sub.createdAt}" pattern="MMM dd, yyyy"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${sub.status == 'APPROVED'}"><span class="badge-custom badge-completed">Approved</span></c:when>
                                                <c:when test="${sub.status == 'REJECTED'}"><span class="badge-custom badge-danger">Rejected</span></c:when>
                                                <c:otherwise><span class="badge-custom badge-warning">Pending Review</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-muted">${empty sub.rejectionReason ? '—' : sub.rejectionReason}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

        </div>
    </div>
</div>

<!-- Modal: Submit Article -->
<div class="modal fade" id="submitContentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-white"><i class="fa-solid fa-pen-nib text-accent me-2"></i> Submit Fitness Article</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/content/submit" method="POST" class="needs-validation" novalidate>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label-custom">Article Title</label>
                            <input type="text" name="title" class="form-control-custom" placeholder="e.g. 5 Strategies for Marathon Pacing" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Category</label>
                            <select name="category" class="form-control-custom" required>
                                <option value="Workout Routines">Workout Routines</option>
                                <option value="Nutrition & Diet">Nutrition & Diet</option>
                                <option value="Cardio & Endurance">Cardio & Endurance</option>
                                <option value="Recovery & Wellness">Recovery & Wellness</option>
                                <option value="Motivation">Motivation</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Article Content / Description</label>
                            <textarea name="description" class="form-control-custom" rows="6" placeholder="Provide detailed, helpful instructions and fitness tips..." required></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-paper-plane"></i> Submit for Review</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
