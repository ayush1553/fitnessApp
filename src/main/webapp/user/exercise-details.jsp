<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="${exercise.name} - Exercise Guide | FitFlow Pro" scope="request"/>
<c:set var="activePage" value="content" scope="request"/>
<c:set var="greetingTitle" value="Exercise Guide" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Breadcrumb Navigation -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb mb-0" style="background: transparent; padding: 0;">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/user/content?tab=exercises" class="text-secondary">
                            <i class="fa-solid fa-arrow-left me-1"></i> Learning Hub
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/user/content?tab=exercises&subtab=${exercise.category}" class="text-secondary">
                            ${exercise.category}
                        </a>
                    </li>
                    <li class="breadcrumb-item text-theme-primary active fw-semibold" aria-current="page">${exercise.name}</li>
                </ol>
            </nav>

            <article class="exercise-guide-container">
                <!-- Large Video Player Hero -->
                <div class="exercise-hero-video-box mb-4">
                    <c:choose>
                        <c:when test="${not empty exercise.videoUrl}">
                            <video id="exerciseMainVideo" 
                                   controls 
                                   playsinline 
                                   preload="metadata"
                                   poster="${pageContext.request.contextPath}/${exercise.thumbnailUrl}">
                                <source src="${exercise.videoUrl}" type="video/mp4">
                                Your browser does not support the video tag.
                            </video>
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/${exercise.thumbnailUrl}" 
                                 alt="${exercise.name}" 
                                 style="width: 100%; max-height: 480px; object-fit: cover;">
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Exercise Header & Meta Info -->
                <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                    <div>
                        <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                            <span class="chip-pill ${exercise.difficulty == 'Beginner' ? 'chip-diff-beginner' : (exercise.difficulty == 'Advanced' ? 'chip-diff-advanced' : 'chip-diff-intermediate')} px-3 py-1 fs-6">
                                <i class="fa-solid fa-chart-simple"></i> ${exercise.difficulty}
                            </span>
                            <span class="chip-pill px-3 py-1 fs-6">
                                <i class="fa-solid fa-layer-group"></i> ${exercise.category}
                            </span>
                            <span class="chip-pill px-3 py-1 fs-6">
                                <i class="fa-solid fa-toolbox"></i> ${exercise.equipment}
                            </span>
                        </div>

                        <h1 class="display-6 fw-bold text-theme-primary mb-2">${exercise.name}</h1>
                        <p class="text-secondary mb-0" style="font-size: 1.05rem;">${exercise.description}</p>
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <button type="button" class="btn btn-outline-custom" onclick="navigator.clipboard.writeText(window.location.href); alert('Exercise guide link copied to clipboard!');">
                            <i class="fa-solid fa-share-nodes me-1"></i> Share
                        </button>
                        <a href="${pageContext.request.contextPath}/user/workouts?action=add&exercise=${exercise.name}" class="btn btn-accent">
                            <i class="fa-solid fa-plus me-1"></i> Log Workout
                        </a>
                    </div>
                </div>

                <!-- Recommended Protocol Card -->
                <div class="fitness-card mb-4">
                    <div class="row g-3 text-center">
                        <div class="col-md-4 col-12 border-end" style="border-color: var(--border-color) !important;">
                            <div class="text-secondary small fw-bold text-uppercase mb-1">Recommended Sets</div>
                            <div class="fs-4 fw-bold text-theme-primary">${exercise.defaultSets} Sets</div>
                        </div>
                        <div class="col-md-4 col-12 border-end" style="border-color: var(--border-color) !important;">
                            <div class="text-secondary small fw-bold text-uppercase mb-1">Target Repetitions / Duration</div>
                            <div class="fs-4 fw-bold text-theme-primary">${exercise.defaultReps}</div>
                        </div>
                        <div class="col-md-4 col-12">
                            <div class="text-secondary small fw-bold text-uppercase mb-1">Rest Interval</div>
                            <div class="fs-4 fw-bold text-theme-primary">${exercise.restTimeSeconds} Seconds</div>
                        </div>
                    </div>
                </div>

                <!-- Structured Guide Grid -->
                <div class="row g-4 mb-5">
                    <!-- Left Column: How to Perform & Muscles -->
                    <div class="col-lg-8 col-12">
                        <!-- Step-by-Step Instructions -->
                        <div class="fitness-card mb-4 p-4 p-md-5">
                            <h4 class="text-theme-primary fw-bold mb-4 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-list-ol text-accent"></i> How to Perform (Step-by-Step)
                            </h4>

                            <c:forEach var="step" items="${fn:split(exercise.instructions, '
')}">
                                <c:if test="${not empty fn:trim(step)}">
                                    <div class="instruction-step-item">
                                        <div class="instruction-step-num">
                                            <c:choose>
                                                <c:when test="${fn:contains(step, '.')}">
                                                    ${fn:substringBefore(fn:trim(step), '.')}
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-solid fa-check"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="instruction-step-content">
                                            <c:choose>
                                                <c:when test="${fn:contains(step, '.')}">
                                                    ${fn:substringAfter(fn:trim(step), '.')}
                                                </c:when>
                                                <c:otherwise>
                                                    ${fn:trim(step)}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>

                        <!-- Form & Safety Tips -->
                        <c:if test="${not empty exercise.formTips}">
                            <div class="tip-box mb-4">
                                <h5 class="text-accent fw-bold mb-2 d-flex align-items-center gap-2">
                                    <i class="fa-solid fa-lightbulb"></i> Form & Technique Golden Cues
                                </h5>
                                <p class="mb-0 text-theme-primary" style="font-size: 0.95rem; line-height: 1.6;">
                                    ${exercise.formTips}
                                </p>
                            </div>
                        </c:if>

                        <!-- Common Mistakes to Avoid -->
                        <c:if test="${not empty exercise.commonMistakes}">
                            <div class="mistake-box mb-4">
                                <h5 class="text-danger fw-bold mb-2 d-flex align-items-center gap-2">
                                    <i class="fa-solid fa-triangle-exclamation"></i> Common Mistakes to Avoid
                                </h5>
                                <p class="mb-0 text-theme-primary" style="font-size: 0.95rem; line-height: 1.6;">
                                    ${exercise.commonMistakes}
                                </p>
                            </div>
                        </c:if>

                        <!-- Safety & Joint Protection -->
                        <c:if test="${not empty exercise.safetyTips}">
                            <div class="tip-box mb-4" style="background: rgba(14, 165, 233, 0.08); border-left-color: #0ea5e9;">
                                <h5 class="fw-bold mb-2 d-flex align-items-center gap-2" style="color: #0ea5e9;">
                                    <i class="fa-solid fa-shield-halved"></i> Safety & Injury Prevention
                                </h5>
                                <p class="mb-0 text-theme-primary" style="font-size: 0.95rem; line-height: 1.6;">
                                    ${exercise.safetyTips}
                                </p>
                            </div>
                        </c:if>
                    </div>

                    <!-- Right Column: Muscle Anatomy & Details -->
                    <div class="col-lg-4 col-12">
                        <!-- Target Muscles Card -->
                        <div class="fitness-card mb-4">
                            <h5 class="text-theme-primary fw-bold mb-3 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-person text-accent"></i> Muscular Engagement
                            </h5>

                            <div class="mb-3">
                                <span class="text-secondary small d-block mb-1">Primary Target:</span>
                                <span class="badge-custom badge-accent fs-6 px-3 py-1">
                                    <i class="fa-solid fa-bullseye me-1"></i> ${exercise.targetMuscles}
                                </span>
                            </div>

                            <c:if test="${not empty exercise.secondaryMuscles}">
                                <div class="mb-3">
                                    <span class="text-secondary small d-block mb-1">Secondary Synergists:</span>
                                    <div class="d-flex flex-wrap gap-1 mt-1">
                                        <c:forEach var="synergist" items="${fn:split(exercise.secondaryMuscles, ',')}">
                                            <span class="chip-pill">${fn:trim(synergist)}</span>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>

                            <hr style="border-color: var(--border-color) !important;">

                            <div>
                                <span class="text-secondary small d-block mb-1">Equipment Needed:</span>
                                <div class="text-theme-primary fw-semibold">${exercise.equipment}</div>
                            </div>
                        </div>

                        <!-- Quick Checklist Card -->
                        <div class="fitness-card mb-4">
                            <h5 class="text-theme-primary fw-bold mb-3 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-circle-check text-accent"></i> Pre-Set Checklist
                            </h5>
                            <ul class="list-unstyled mb-0 d-flex flex-column gap-2 small text-secondary">
                                <li class="d-flex align-items-center gap-2">
                                    <i class="fa-solid fa-check text-accent"></i> Warm up target joints 3-5 mins
                                </li>
                                <li class="d-flex align-items-center gap-2">
                                    <i class="fa-solid fa-check text-accent"></i> Establish strong foot / hand base
                                </li>
                                <li class="d-flex align-items-center gap-2">
                                    <i class="fa-solid fa-check text-accent"></i> Inhale & brace abdominal wall
                                </li>
                                <li class="d-flex align-items-center gap-2">
                                    <i class="fa-solid fa-check text-accent"></i> Control 2-3s negative eccentric
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Related Exercises in Same Category -->
                <c:if test="${not empty relatedExercises}">
                    <div class="mb-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h4 class="text-theme-primary fw-bold mb-1">More ${exercise.category} Exercises</h4>
                                <p class="text-secondary mb-0 small">Expand your routine with related compound and isolation movements.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/user/content?tab=exercises&subtab=${exercise.category}" class="text-accent small fw-bold">
                                View all in ${exercise.category} <i class="fa-solid fa-arrow-right ms-1"></i>
                            </a>
                        </div>

                        <div class="row g-4">
                            <c:forEach var="rel" items="${relatedExercises}">
                                <div class="col-lg-4 col-md-6 col-12">
                                    <div class="exercise-card">
                                        <div class="exercise-media-wrap" style="height: 160px;">
                                            <img src="${pageContext.request.contextPath}/${rel.thumbnailUrl}" 
                                                 alt="${rel.name}" 
                                                 loading="lazy"
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/strength-training.webp';">
                                            <div class="exercise-video-badge">
                                                <i class="fa-solid fa-play text-accent"></i> Video
                                            </div>
                                        </div>
                                        <div class="exercise-card-body">
                                            <div>
                                                <div class="d-flex justify-content-between align-items-center gap-2 mb-2">
                                                    <span class="chip-pill ${rel.difficulty == 'Beginner' ? 'chip-diff-beginner' : (rel.difficulty == 'Advanced' ? 'chip-diff-advanced' : 'chip-diff-intermediate')}">
                                                        ${rel.difficulty}
                                                    </span>
                                                    <small class="text-secondary">${rel.equipment}</small>
                                                </div>
                                                <h6 class="exercise-title mb-1">${rel.name}</h6>
                                                <p class="exercise-desc small mb-3">${rel.description}</p>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/user/exercise-details?id=${rel.id}" class="btn btn-sm btn-outline-custom w-100">
                                                View Guide
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Back to Hub Button -->
                <div class="pt-4 border-top text-center" style="border-color: var(--border-color) !important;">
                    <a href="${pageContext.request.contextPath}/user/content?tab=exercises" class="btn btn-outline-custom px-4">
                        <i class="fa-solid fa-arrow-left me-2"></i> Back to Fitness Learning Hub
                    </a>
                </div>
            </article>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
