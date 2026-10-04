<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Challenge Management - Admin FitFlow Pro" scope="request"/>
<c:set var="activePage" value="admin-challenges" scope="request"/>
<c:set var="greetingTitle" value="Challenge Control" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/admin-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header Toolbar -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h3 class="mb-1 text-white">Community Challenges Management</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        Create community fitness events, adjust targets, and manage active competitions.
                    </p>
                </div>
                <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#createChallengeModal">
                    <i class="fa-solid fa-plus"></i> Create Challenge
                </button>
            </div>

            <!-- Challenges Table -->
            <div class="fitness-card">
                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Challenge</th>
                                <th>Category</th>
                                <th>Target</th>
                                <th>Dates</th>
                                <th>Participants</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${challenges}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${pageContext.request.contextPath}/${c.imageUrl}" 
                                                 alt="${c.title}" 
                                                 style="width: 48px; height: 36px; object-fit: cover; border-radius: 6px; border: 1px solid var(--border-color);"
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/challenges/running.jpg';">
                                            <div>
                                                <div class="text-white fw-bold">${c.title}</div>
                                                <small class="text-muted" style="display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden;">
                                                    ${c.description}
                                                </small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge-custom badge-active">${c.category}</span></td>
                                    <td class="fw-bold" style="color: var(--accent-primary);"><fmt:formatNumber value="${c.targetValue}" pattern="#,##0.#"/> ${c.unit}</td>
                                    <td>
                                        <small class="text-white d-block"><fmt:formatDate value="${c.startDate}" pattern="MMM d"/> – <fmt:formatDate value="${c.endDate}" pattern="MMM d, yyyy"/></small>
                                        <small class="text-muted">${c.daysRemaining} days left</small>
                                    </td>
                                    <td>
                                        <span class="badge-custom badge-accent">
                                            <i class="fa-solid fa-users"></i> ${c.participantCount}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${c.status == 'ACTIVE'}"><span class="badge-custom badge-completed">ACTIVE</span></c:when>
                                            <c:when test="${c.status == 'UPCOMING'}"><span class="badge-custom badge-active">UPCOMING</span></c:when>
                                            <c:otherwise><span class="badge-custom badge-warning">${c.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-inline-flex gap-1">
                                            <!-- Toggle Status Form -->
                                            <form action="${pageContext.request.contextPath}/admin-actions/challenge/status" method="POST" class="d-inline">
                                                <input type="hidden" name="id" value="${c.id}">
                                                <c:choose>
                                                    <c:when test="${c.status == 'ACTIVE'}">
                                                        <input type="hidden" name="status" value="ARCHIVED">
                                                        <button type="submit" class="btn btn-sm btn-outline-custom p-1 px-2" title="Archive">
                                                            <i class="fa-solid fa-box-archive text-warning"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="status" value="ACTIVE">
                                                        <button type="submit" class="btn btn-sm btn-outline-custom p-1 px-2" title="Activate">
                                                            <i class="fa-solid fa-play text-success"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>

                                            <!-- Delete Challenge Form -->
                                            <form action="${pageContext.request.contextPath}/admin-actions/challenge/delete" method="POST" class="d-inline"
                                                  onsubmit="return confirm('Delete challenge ${c.title}? All enrolled participant progress will be deleted.');">
                                                <input type="hidden" name="id" value="${c.id}">
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

<!-- Modal: Create Challenge -->
<div class="modal fade" id="createChallengeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-white"><i class="fa-solid fa-trophy text-accent me-2"></i> Create Global Challenge</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin-actions/challenge/create" method="POST" class="needs-validation" novalidate>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-custom">Challenge Title</label>
                            <input type="text" name="title" class="form-control-custom" placeholder="e.g. 100K Century Cycling Challenge" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Description</label>
                            <textarea name="description" class="form-control-custom" rows="2" placeholder="Rules, expectations, and milestones..." required></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Category</label>
                            <input type="text" name="category" class="form-control-custom" placeholder="Cardio, Strength, Cycling" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">Target</label>
                            <input type="number" step="0.1" name="targetValue" class="form-control-custom" placeholder="100.0" required min="0.1">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label-custom">Unit</label>
                            <input type="text" name="unit" class="form-control-custom" placeholder="KM, kcal, etc" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Start Date</label>
                            <input type="date" name="startDate" class="form-control-custom" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">End Date</label>
                            <input type="date" name="endDate" class="form-control-custom" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Challenge Photograph Preset / Image Path</label>
                            <select name="imageUrl" class="form-control-custom">
                                <option value="assets/images/challenges/running.jpg">Running - 30-Day Trail & Track Runner</option>
                                <option value="assets/images/challenges/hiit.jpg">HIIT / Endurance - Intense Battle Ropes & Calorie Burn</option>
                                <option value="assets/images/challenges/cycling.jpg">Cycling - Century Scenic Road Ride</option>
                                <option value="assets/images/challenges/strength.jpg">Strength Training - Weights & Gym</option>
                                <option value="assets/images/challenges/swimming.jpg">Swimming - Olympic Pool Aquatic Endurance</option>
                                <option value="assets/images/challenges/yoga.jpg">Yoga & Mindfulness - Studio Flow</option>
                                <option value="assets/images/challenges/walking.jpg">Walking & Daily Steps - Outdoor Trail</option>
                                <option value="assets/images/challenges/core.jpg">Core & Abs - Plank & Functional Strength</option>
                                <option value="assets/images/challenges/flexibility.jpg">Flexibility & Recovery - Stretching</option>
                                <option value="assets/images/challenges/full-body.jpg">Full Body Conditioning - Kettlebells & Power</option>
                            </select>
                            <small class="text-muted" style="font-size: 0.72rem;">Select high-resolution studio photography asset to visually represent this challenge.</small>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-check"></i> Launch Challenge</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
