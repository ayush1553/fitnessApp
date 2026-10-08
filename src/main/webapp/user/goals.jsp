<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Fitness Goals - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="goals" scope="request"/>
<c:set var="greetingTitle" value="Goals" scope="request"/>

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
                    <h3 class="mb-1 text-theme-primary">Fitness Goals & Milestones</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        Set actionable targets, monitor milestone completion, and stay consistent.
                    </p>
                </div>
                <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#addGoalModal">
                    <i class="fa-solid fa-bullseye"></i> Create New Goal
                </button>
            </div>

            <!-- Stats Highlight Bar -->
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                        <div class="rec-icon-box">
                            <i class="fa-solid fa-spinner"></i>
                        </div>
                        <div>
                            <small class="text-secondary d-block">In Progress</small>
                            <span class="fs-4 fw-bold text-theme-primary">${activeCount} Active</span>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                        <div class="rec-icon-box">
                            <i class="fa-solid fa-circle-check text-success"></i>
                        </div>
                        <div>
                            <small class="text-secondary d-block">Completed</small>
                            <span class="fs-4 fw-bold text-theme-primary">${completedCount} Goals</span>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                        <div class="rec-icon-box">
                            <i class="fa-solid fa-trophy" style="color: var(--accent-primary);"></i>
                        </div>
                        <div>
                            <small class="text-secondary d-block">Avg Completion Rate</small>
                            <span class="fs-4 fw-bold" style="color: var(--accent-primary);">${overallPct}%</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Goals Grid -->
            <div class="row g-4">
                <c:choose>
                    <c:when test="${not empty goals}">
                        <c:forEach var="g" items="${goals}">
                            <div class="col-lg-4 col-md-6">
                                <div class="fitness-card h-100 d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <span class="badge-custom ${g.status == 'COMPLETED' ? 'badge-completed' : 'badge-accent'}">
                                                <i class="fa-solid ${g.status == 'COMPLETED' ? 'fa-check' : 'fa-spinner'}"></i> ${g.status}
                                            </span>
                                            <div class="dropdown">
                                                <button class="btn btn-sm text-secondary p-0" data-bs-toggle="dropdown">
                                                    <i class="fa-solid fa-ellipsis-vertical"></i>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end " style="background-color: var(--bg-card); border-color: var(--border-color);">
                                                    <li>
                                                        <button class="dropdown-item" onclick="openEditGoalModal('${g.id}', '${g.title}', '${g.targetValue}', '${g.currentValue}', '${g.unit}', '${g.deadline}', '${g.status}', '${g.description}')">
                                                            <i class="fa-solid fa-pen-to-square me-2"></i> Edit
                                                        </button>
                                                    </li>
                                                    <c:if test="${g.status != 'COMPLETED'}">
                                                        <li>
                                                            <form action="${pageContext.request.contextPath}/goal/complete" method="POST">
                                                                <input type="hidden" name="id" value="${g.id}">
                                                                <button type="submit" class="dropdown-item text-success">
                                                                    <i class="fa-solid fa-check-double me-2"></i> Mark Completed
                                                                </button>
                                                            </form>
                                                        </li>
                                                    </c:if>
                                                    <li><hr class="dropdown-divider" style="border-color: var(--border-color);"></li>
                                                    <li>
                                                        <form action="${pageContext.request.contextPath}/goal/delete" method="POST" onsubmit="return confirm('Delete this goal permanently?');">
                                                            <input type="hidden" name="id" value="${g.id}">
                                                            <button type="submit" class="dropdown-item text-danger">
                                                                <i class="fa-solid fa-trash me-2"></i> Delete
                                                            </button>
                                                        </form>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>

                                        <h5 class="text-theme-primary fw-bold mb-2">${g.title}</h5>
                                        <p class="text-secondary mb-3" style="font-size: 0.85rem; min-height: 38px;">
                                            ${empty g.description ? 'No description provided.' : g.description}
                                        </p>

                                        <!-- Progress Bar -->
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="text-theme-primary fw-bold" style="font-size: 0.85rem;">
                                                <fmt:formatNumber value="${g.currentValue}" pattern="#,##0.#"/> / <fmt:formatNumber value="${g.targetValue}" pattern="#,##0.#"/> ${g.unit}
                                            </span>
                                            <span class="fw-bold" style="color: var(--accent-primary); font-size: 0.85rem;">${g.progressPercentage}%</span>
                                        </div>
                                        <div class="progress-custom mb-3">
                                            <div class="progress-bar-custom" style="width: ${g.progressPercentage}%;"></div>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center pt-3 border-top" style="border-color: var(--border-color) !important; font-size: 0.8rem;">
                                        <span class="text-muted">
                                            <i class="fa-regular fa-calendar me-1"></i> Due: <fmt:formatDate value="${g.deadline}" pattern="MMM dd, yyyy"/>
                                        </span>
                                        <button class="btn btn-sm btn-outline-custom p-1 px-3"
                                                onclick="openGoalProgressModal('${g.id}', '${g.title}', '${g.currentValue}', '${g.targetValue}', '${g.unit}')">
                                            Update
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5 text-muted">
                            <i class="fa-solid fa-bullseye fs-1 mb-3"></i>
                            <h5 class="text-theme-primary">No fitness goals yet</h5>
                            <p class="mb-3">Set your first fitness goal to start tracking progress towards your milestones.</p>
                            <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#addGoalModal">
                                <i class="fa-solid fa-plus"></i> Create Goal
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Create Goal -->
<div class="modal fade" id="addGoalModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-theme-primary"><i class="fa-solid fa-bullseye text-accent me-2"></i> Create Fitness Goal</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/goal/add" method="POST" class="needs-validation" novalidate>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-custom">Goal Title</label>
                            <input type="text" name="title" class="form-control-custom" placeholder="e.g. Run 50 KM this Month" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Description</label>
                            <textarea name="description" class="form-control-custom" rows="2" placeholder="Describe your objective and motivation"></textarea>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Target Value</label>
                            <input type="number" step="0.1" name="targetValue" class="form-control-custom" placeholder="50.0" required min="0.1">
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Current Value</label>
                            <input type="number" step="0.1" name="currentValue" class="form-control-custom" placeholder="0.0" value="0.0">
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Unit</label>
                            <input type="text" name="unit" class="form-control-custom" placeholder="KM, kcal, sessions, kg" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Target Deadline</label>
                            <input type="date" name="deadline" class="form-control-custom" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-check"></i> Save Goal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Edit Goal -->
<div class="modal fade" id="editGoalModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-theme-primary"><i class="fa-solid fa-pen-to-square text-accent me-2"></i> Edit Goal</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/goal/update" method="POST" class="needs-validation" novalidate>
                <input type="hidden" name="id" id="editGoalId">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-custom">Goal Title</label>
                            <input type="text" name="title" id="editGoalTitle" class="form-control-custom" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Description</label>
                            <textarea name="description" id="editDescription" class="form-control-custom" rows="2"></textarea>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Target Value</label>
                            <input type="number" step="0.1" name="targetValue" id="editTargetValue" class="form-control-custom" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Current Value</label>
                            <input type="number" step="0.1" name="currentValue" id="editCurrentValue" class="form-control-custom" required>
                        </div>
                        <div class="col-4">
                            <label class="form-label-custom">Unit</label>
                            <input type="text" name="unit" id="editUnit" class="form-control-custom" required>
                        </div>
                        <div class="col-4">
                            <label class="form-label-custom">Deadline</label>
                            <input type="date" name="deadline" id="editDeadline" class="form-control-custom" required>
                        </div>
                        <div class="col-4">
                            <label class="form-label-custom">Status</label>
                            <select name="status" id="editStatus" class="form-control-custom">
                                <option value="IN_PROGRESS">IN_PROGRESS</option>
                                <option value="COMPLETED">COMPLETED</option>
                                <option value="EXPIRED">EXPIRED</option>
                                <option value="CANCELLED">CANCELLED</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-check"></i> Update Goal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Quick Progress Updater -->
<div class="modal fade" id="goalProgressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h6 class="modal-title text-theme-primary">Update Progress</h6>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/goal/progress" method="POST">
                <input type="hidden" name="id" id="progressGoalId">
                <div class="modal-body p-3">
                    <p class="mb-1 text-theme-primary fw-bold" id="progressGoalTitle"></p>
                    <p class="text-secondary mb-3" style="font-size: 0.8rem;">Target: <span id="progressGoalTarget" class="text-accent fw-bold"></span></p>

                    <label class="form-label-custom">New Current Value (<span id="progressUnitLabel"></span>)</label>
                    <input type="number" step="0.1" name="currentValue" id="progressCurrentValue" class="form-control-custom" required>
                </div>
                <div class="modal-footer modal-footer-custom p-2">
                    <button type="button" class="btn btn-sm btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-accent">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
