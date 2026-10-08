<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Community Challenges - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="challenges" scope="request"/>
<c:set var="greetingTitle" value="Challenges" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h3 class="mb-1 text-theme-primary">Community Challenges</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        Join structured fitness challenges, compete with the community, and earn badges.
                    </p>
                </div>
                <span class="badge-custom badge-accent fs-6">
                    <i class="fa-solid fa-trophy me-1"></i> ${completedCount} Completed
                </span>
            </div>

            <!-- Challenges Grid -->
            <div class="row g-4">
                <c:choose>
                    <c:when test="${not empty challenges}">
                        <c:forEach var="c" items="${challenges}">
                            <div class="col-lg-6">
                                <div class="challenge-card-rich">
                                    <!-- Fitness Photograph Header -->
                                    <div class="challenge-card-image">
                                        <img src="${pageContext.request.contextPath}/${c.imageUrl}"
                                             alt="${c.imageAltText}"
                                             loading="lazy"
                                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/challenges/running.jpg';">
                                        <div class="challenge-image-overlay">
                                            <span class="badge-custom badge-active fw-bold" style="font-size: 0.78rem;">
                                                <i class="fa-solid fa-layer-group me-1"></i> ${c.category}
                                            </span>
                                            <span class="badge rounded-pill" style="background: var(--bg-modal); backdrop-filter: blur(6px); color: var(--text-primary); font-size: 0.75rem; border: 1px solid var(--border-color);">
                                                <i class="fa-solid fa-users me-1 text-accent"></i> ${c.participantCount} Joined
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Challenge Content Body -->
                                    <div class="challenge-card-body">
                                        <div>
                                            <h4 class="text-theme-primary fw-bold mb-2">${c.title}</h4>
                                            <p class="text-secondary mb-3" style="font-size: 0.88rem; line-height: 1.45;">
                                                ${c.description}
                                            </p>

                                            <!-- Target & Timeline Box -->
                                            <div class="challenge-target-box">
                                                <div>
                                                    <small class="text-secondary d-block" style="font-size: 0.75rem;">Challenge Target</small>
                                                    <span class="fw-bold fs-5" style="color: var(--accent-primary);">
                                                        <fmt:formatNumber value="${c.targetValue}" pattern="#,##0.#"/> ${c.unit}
                                                    </span>
                                                </div>
                                                <div class="text-end">
                                                    <small class="text-secondary d-block" style="font-size: 0.75rem;">Timeline</small>
                                                    <span class="fw-semibold text-theme-primary" style="font-size: 0.85rem;">
                                                        <fmt:formatDate value="${c.startDate}" pattern="MMM d"/> – <fmt:formatDate value="${c.endDate}" pattern="MMM d, yyyy"/>
                                                    </span>
                                                </div>
                                            </div>

                                            <!-- Enrolled User Progress Bar -->
                                            <c:if test="${c.userJoined}">
                                                <div class="mb-3 p-3 rounded-3" style="background-color: rgba(200, 255, 69, 0.05); border: 1px solid rgba(200, 255, 69, 0.15);">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <span class="text-theme-primary fw-bold" style="font-size: 0.85rem;">
                                                            Your Progress: <fmt:formatNumber value="${c.userParticipation.progress}" pattern="#,##0.#"/> / <fmt:formatNumber value="${c.targetValue}" pattern="#,##0.#"/> ${c.unit}
                                                        </span>
                                                        <span class="fw-bold" style="color: var(--accent-primary); font-size: 0.9rem;">
                                                            ${c.userParticipation.progressPercentage}%
                                                        </span>
                                                    </div>
                                                    <div class="progress-custom mb-1">
                                                        <div class="progress-bar-custom" style="width: ${c.userParticipation.progressPercentage}%;"></div>
                                                    </div>
                                                    <small class="text-muted" style="font-size: 0.72rem;">
                                                        <i class="fa-solid fa-bolt text-accent me-1"></i> Keep logging your activities to achieve this milestone.
                                                    </small>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Bottom Action Bar -->
                                        <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-2" style="border-color: var(--border-color) !important;">
                                            <span class="text-muted" style="font-size: 0.8rem;">
                                                <i class="fa-regular fa-clock me-1 text-accent"></i>
                                                <c:choose>
                                                    <c:when test="${c.expired}">Ended</c:when>
                                                    <c:otherwise>${c.daysRemaining} days remaining</c:otherwise>
                                                </c:choose>
                                            </span>

                                            <c:choose>
                                                <c:when test="${c.userJoined}">
                                                    <div class="d-flex gap-2">
                                                        <button type="button" class="btn btn-sm btn-accent"
                                                                onclick="openChallengeProgressModal('${c.userParticipation.id}', '${c.title}', '${c.userParticipation.progress}', '${c.targetValue}', '${c.unit}')">
                                                            <i class="fa-solid fa-plus"></i> Update Progress
                                                        </button>
                                                        <form action="${pageContext.request.contextPath}/challenge/leave" method="POST" onsubmit="return confirm('Leave this challenge? Your current progress will be reset.');">
                                                            <input type="hidden" name="participantId" value="${c.userParticipation.id}">
                                                            <button type="submit" class="btn btn-sm btn-danger-custom">Leave</button>
                                                        </form>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/challenge/join" method="POST">
                                                        <input type="hidden" name="challengeId" value="${c.id}">
                                                        <button type="submit" class="btn-accent" ${c.expired ? 'disabled' : ''}>
                                                            <i class="fa-solid fa-arrow-right-to-bracket"></i> Join Challenge
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5 text-muted">
                            <i class="fa-solid fa-trophy fs-1 mb-3"></i>
                            <h5 class="text-theme-primary">No active challenges available</h5>
                            <p>Check back soon for new community fitness challenges.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Challenge Progress Updater -->
<div class="modal fade" id="challengeProgressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h6 class="modal-title text-theme-primary">Update Challenge Progress</h6>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/challenge/progress" method="POST">
                <input type="hidden" name="participantId" id="modalParticipantId">
                <div class="modal-body p-3">
                    <p class="mb-1 text-theme-primary fw-bold" id="modalChallengeTitle"></p>
                    <p class="text-secondary mb-3" style="font-size: 0.8rem;">Target: <span id="modalChallengeTarget" class="text-accent fw-bold"></span></p>

                    <label class="form-label-custom">New Accumulated Progress (<span id="modalProgressUnit"></span>)</label>
                    <input type="number" step="0.1" name="progress" id="modalProgressInput" class="form-control-custom" required>
                </div>
                <div class="modal-footer modal-footer-custom p-2">
                    <button type="button" class="btn btn-sm btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-accent">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
