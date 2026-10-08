<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Fitness Learning Hub - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="content" scope="request"/>
<c:set var="greetingTitle" value="Fitness Learning Hub" scope="request"/>

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
                    <h3 class="mb-1 text-theme-primary fw-bold d-flex align-items-center gap-2">
                        <i class="fa-solid fa-graduation-cap text-accent"></i> Fitness Learning Hub & Guides
                    </h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.92rem;">
                        Master exercise biomechanics, progressive workout routines, precision nutrition, and recovery protocols.
                    </p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#submitContentModal">
                        <i class="fa-solid fa-pen-nib me-1"></i> Submit Article
                    </button>
                </div>
            </div>

            <!-- LEVEL 1: PRIMARY NAVIGATION TABS -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-3">
                <div class="hub-primary-tabs" role="tablist" id="hubPrimaryTabs">
                    <a href="${pageContext.request.contextPath}/user/content?tab=exercises${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                       class="hub-primary-tab ${activeTab == 'exercises' || empty activeTab ? 'active' : ''}" 
                       data-tab="exercises">
                        <i class="fa-solid fa-person-running"></i> Exercises
                        <span class="badge-count">${totalExerciseCount != null ? totalExerciseCount : (not empty exercises ? exercises.size() : '0')}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/user/content?tab=workouts${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                       class="hub-primary-tab ${activeTab == 'workouts' ? 'active' : ''}" 
                       data-tab="workouts">
                        <i class="fa-solid fa-dumbbell"></i> Workout Guides
                        <span class="badge-count">${totalWorkoutCount != null ? totalWorkoutCount : (not empty workoutGuides ? workoutGuides.size() : '0')}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/user/content?tab=nutrition${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                       class="hub-primary-tab ${activeTab == 'nutrition' ? 'active' : ''}" 
                       data-tab="nutrition">
                        <i class="fa-solid fa-apple-whole"></i> Nutrition
                        <span class="badge-count">${totalNutritionCount != null ? totalNutritionCount : (not empty nutritionGuides ? nutritionGuides.size() : '0')}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/user/content?tab=recovery${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                       class="hub-primary-tab ${activeTab == 'recovery' ? 'active' : ''}" 
                       data-tab="recovery">
                        <i class="fa-solid fa-spa"></i> Recovery
                        <span class="badge-count">${totalRecoveryCount != null ? totalRecoveryCount : (not empty recoveryGuides ? recoveryGuides.size() : '0')}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/user/content?tab=articles${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                       class="hub-primary-tab ${activeTab == 'articles' ? 'active' : ''}" 
                       data-tab="articles">
                        <i class="fa-solid fa-newspaper"></i> Fitness Articles
                        <span class="badge-count">${totalArticleCount != null ? totalArticleCount : (not empty fitnessArticles ? fitnessArticles.size() : '0')}</span>
                    </a>
                </div>

                <!-- Unified Search Input -->
                <form action="${pageContext.request.contextPath}/user/content" method="GET" class="d-flex gap-2" style="min-width: 280px;">
                    <input type="hidden" name="tab" value="${activeTab}">
                    <c:if test="${not empty activeSubtab && activeSubtab != 'All'}">
                        <input type="hidden" name="subtab" value="${activeSubtab}">
                    </c:if>
                    <div class="search-input-wrapper w-100">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" name="search" id="hubLiveSearch" class="form-control-custom" 
                               placeholder="Search guides, muscles, tags..." 
                               value="${searchQuery}">
                    </div>
                    <button type="submit" class="btn btn-outline-custom px-3">Search</button>
                    <c:if test="${not empty searchQuery}">
                        <a href="${pageContext.request.contextPath}/user/content?tab=${activeTab}${not empty activeSubtab && activeSubtab != 'All' ? '&subtab='.concat(activeSubtab) : ''}" 
                           class="btn btn-outline-custom px-2" title="Clear search">
                            <i class="fa-solid fa-xmark"></i>
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- LEVEL 2: SECONDARY SUB-TABS (DYNAMICALLY DISPLAYED PER PRIMARY TAB) -->
            <c:choose>
                <%-- EXERCISES SECONDARY SUB-TABS --%>
                <c:when test="${activeTab == 'exercises' || empty activeTab}">
                    <div class="hub-subnav-container" id="exercisesSubnav">
                        <c:forEach var="muscle" items="${['All', 'Chest', 'Back', 'Shoulders', 'Arms', 'Legs', 'Core', 'Full Body', 'Mobility']}">
                            <a href="${pageContext.request.contextPath}/user/content?tab=exercises&subtab=${muscle}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="hub-sub-tab ${(empty activeSubtab && muscle == 'All') || activeSubtab == muscle ? 'active' : ''}"
                               data-subtab="${muscle}">
                                <c:choose>
                                    <c:when test="${muscle == 'All'}"><i class="fa-solid fa-layer-group"></i></c:when>
                                    <c:when test="${muscle == 'Chest'}"><i class="fa-solid fa-shield-heart"></i></c:when>
                                    <c:when test="${muscle == 'Back'}"><i class="fa-solid fa-arrows-up-down"></i></c:when>
                                    <c:when test="${muscle == 'Shoulders'}"><i class="fa-solid fa-dumbbell"></i></c:when>
                                    <c:when test="${muscle == 'Arms'}"><i class="fa-solid fa-hand-fist"></i></c:when>
                                    <c:when test="${muscle == 'Legs'}"><i class="fa-solid fa-shoe-prints"></i></c:when>
                                    <c:when test="${muscle == 'Core'}"><i class="fa-solid fa-bolt"></i></c:when>
                                    <c:when test="${muscle == 'Full Body'}"><i class="fa-solid fa-fire"></i></c:when>
                                    <c:when test="${muscle == 'Mobility'}"><i class="fa-solid fa-person-walking"></i></c:when>
                                </c:choose>
                                ${muscle}
                            </a>
                        </c:forEach>
                    </div>
                </c:when>

                <%-- WORKOUT GUIDES SECONDARY SUB-TABS --%>
                <c:when test="${activeTab == 'workouts'}">
                    <div class="hub-subnav-container" id="workoutsSubnav">
                        <c:forEach var="guideTag" items="${['All', 'Beginner', 'Strength', 'Muscle Building', 'Fat Loss', 'Cardio', 'Home', 'Gym']}">
                            <a href="${pageContext.request.contextPath}/user/content?tab=workouts&subtab=${guideTag}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="hub-sub-tab ${(empty activeSubtab && guideTag == 'All') || activeSubtab == guideTag ? 'active' : ''}"
                               data-subtab="${guideTag}">
                                ${guideTag}
                            </a>
                        </c:forEach>
                    </div>
                </c:when>

                <%-- NUTRITION SECONDARY SUB-TABS --%>
                <c:when test="${activeTab == 'nutrition'}">
                    <div class="hub-subnav-container" id="nutritionSubnav">
                        <c:forEach var="nutriTag" items="${['All', 'Protein', 'Carbohydrates', 'Healthy Fats', 'Meal Prep', 'Hydration', 'Pre-Workout', 'Post-Workout', 'Weight Management']}">
                            <a href="${pageContext.request.contextPath}/user/content?tab=nutrition&subtab=${nutriTag}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="hub-sub-tab ${(empty activeSubtab && nutriTag == 'All') || activeSubtab == nutriTag ? 'active' : ''}"
                               data-subtab="${nutriTag}">
                                ${nutriTag}
                            </a>
                        </c:forEach>
                    </div>
                </c:when>

                <%-- RECOVERY SECONDARY SUB-TABS --%>
                <c:when test="${activeTab == 'recovery'}">
                    <div class="hub-subnav-container" id="recoverySubnav">
                        <c:forEach var="recovTag" items="${['All', 'Stretching', 'Mobility', 'Recovery', 'Sleep', 'Rest Day']}">
                            <a href="${pageContext.request.contextPath}/user/content?tab=recovery&subtab=${recovTag}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="hub-sub-tab ${(empty activeSubtab && recovTag == 'All') || activeSubtab == recovTag ? 'active' : ''}"
                               data-subtab="${recovTag}">
                                ${recovTag}
                            </a>
                        </c:forEach>
                    </div>
                </c:when>

                <%-- FITNESS ARTICLES SECONDARY SUB-TABS --%>
                <c:when test="${activeTab == 'articles'}">
                    <div class="hub-subnav-container" id="articlesSubnav">
                        <c:forEach var="artTag" items="${['All', 'Workout', 'Nutrition', 'Recovery', 'Motivation', 'Fitness Science']}">
                            <a href="${pageContext.request.contextPath}/user/content?tab=articles&subtab=${artTag}${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="hub-sub-tab ${(empty activeSubtab && artTag == 'All') || activeSubtab == artTag ? 'active' : ''}"
                               data-subtab="${artTag}">
                                ${artTag}
                            </a>
                        </c:forEach>
                    </div>
                </c:when>
            </c:choose>

            <!-- MAIN CONTENT SECTIONS -->

            <!-- SECTION 1: EXERCISES GRID -->
            <c:if test="${activeTab == 'exercises' || empty activeTab}">
                <div class="row g-4 mb-5" id="exercisesGrid">
                    <c:choose>
                        <c:when test="${not empty exercises}">
                            <c:forEach var="ex" items="${exercises}">
                                <div class="col-xl-4 col-lg-6 col-md-6 col-12 exercise-item-card" data-category="${ex.category}" data-difficulty="${ex.difficulty}" data-name="${fn:toLowerCase(ex.name)}">
                                    <div class="exercise-card">
                                        <!-- Top Media Container with Badge & Hover Overlay -->
                                        <div class="exercise-media-wrap">
                                            <img src="${pageContext.request.contextPath}/${ex.thumbnailUrl}" 
                                                 alt="${ex.name}" 
                                                 loading="lazy"
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/strength-training.webp';">
                                            
                                            <div class="exercise-video-badge">
                                                <i class="fa-solid fa-play text-accent"></i> Video Guide
                                            </div>

                                            <div class="exercise-play-overlay">
                                                <a href="${pageContext.request.contextPath}/user/exercise-details?id=${ex.id}" class="exercise-play-btn" title="Watch Guide">
                                                    <i class="fa-solid fa-play"></i>
                                                </a>
                                            </div>
                                        </div>

                                        <!-- Exercise Card Body -->
                                        <div class="exercise-card-body">
                                            <div>
                                                <div class="d-flex justify-content-between align-items-center gap-2 mb-2">
                                                    <span class="chip-pill ${ex.difficulty == 'Beginner' ? 'chip-diff-beginner' : (ex.difficulty == 'Advanced' ? 'chip-diff-advanced' : 'chip-diff-intermediate')}">
                                                        <i class="fa-solid fa-chart-simple"></i> ${ex.difficulty}
                                                    </span>
                                                    <span class="chip-pill">
                                                        <i class="fa-solid fa-layer-group"></i> ${ex.category}
                                                    </span>
                                                </div>

                                                <h5 class="exercise-title">${ex.name}</h5>
                                                <p class="exercise-desc">${ex.description}</p>
                                                
                                                <div class="exercise-chips">
                                                    <span class="chip-pill" title="Target Muscle">
                                                        <i class="fa-solid fa-bullseye text-accent"></i> ${ex.targetMuscles}
                                                    </span>
                                                    <span class="chip-pill" title="Equipment">
                                                        <i class="fa-solid fa-toolbox"></i> ${ex.equipment}
                                                    </span>
                                                    <span class="chip-pill" title="Standard Recommendation">
                                                        <i class="fa-solid fa-clock-rotate-left"></i> ${ex.defaultSets} sets • ${ex.defaultReps}
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="pt-3 border-top d-flex justify-content-between align-items-center" style="border-color: var(--border-color) !important;">
                                                <span class="text-secondary small">
                                                    <i class="fa-solid fa-circle-check text-accent me-1"></i> Form Verified
                                                </span>
                                                <a href="${pageContext.request.contextPath}/user/exercise-details?id=${ex.id}" class="btn btn-sm btn-accent px-3">
                                                    View Guide <i class="fa-solid fa-arrow-right ms-1"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="fitness-card text-center py-5">
                                    <i class="fa-solid fa-dumbbell fs-1 mb-3 text-muted"></i>
                                    <h4 class="text-theme-primary fw-bold">No exercises found in this category</h4>
                                    <p class="text-secondary mb-3">Try choosing a different muscle group or clearing your search filter.</p>
                                    <a href="${pageContext.request.contextPath}/user/content?tab=exercises" class="btn btn-outline-custom">
                                        <i class="fa-solid fa-rotate-left me-1"></i> Reset Filters
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- SECTION 2: WORKOUT GUIDES -->
            <c:if test="${activeTab == 'workouts'}">
                <div class="row g-4 mb-5">
                    <c:choose>
                        <c:when test="${not empty workoutGuides}">
                            <c:forEach var="wg" items="${workoutGuides}">
                                <div class="col-lg-4 col-md-6 col-12">
                                    <a href="${pageContext.request.contextPath}/user/content/view?id=${wg.id}" class="content-card-link" role="article">
                                        <div class="content-card-rich">
                                            <div class="content-card-image-wrap">
                                                <img src="${pageContext.request.contextPath}/${wg.imageUrl}" 
                                                     alt="${wg.title}" 
                                                     loading="lazy"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/strength-training.webp';">
                                                <div class="content-card-image-overlay"></div>
                                            </div>
                                            <div class="content-card-body">
                                                <div>
                                                    <div class="content-card-meta">
                                                        <span class="badge-custom badge-accent">${wg.subcategory}</span>
                                                        <small class="text-muted"><i class="fa-regular fa-clock me-1"></i>${wg.readTimeMinutes} min read</small>
                                                    </div>
                                                    <h5 class="content-card-title">${wg.title}</h5>
                                                    <p class="content-card-desc">${wg.description}</p>
                                                </div>
                                                <div class="content-card-footer">
                                                    <div class="content-author-pill">
                                                        <div class="content-author-dot">F</div>
                                                        <small class="text-secondary fw-semibold">FitFlow Coach</small>
                                                    </div>
                                                    <span class="badge-custom badge-completed">
                                                        <i class="fa-solid fa-circle-check text-accent"></i> Structured
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="fitness-card text-center py-5">
                                    <i class="fa-solid fa-clipboard-list fs-1 mb-3 text-muted"></i>
                                    <h4 class="text-theme-primary fw-bold">No workout guides match your selection</h4>
                                    <p class="text-secondary mb-3">Adjust your sub-tab or keyword filter to find routines.</p>
                                    <a href="${pageContext.request.contextPath}/user/content?tab=workouts" class="btn btn-outline-custom">Reset Filters</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- SECTION 3: NUTRITION GUIDES -->
            <c:if test="${activeTab == 'nutrition'}">
                <div class="row g-4 mb-5">
                    <c:choose>
                        <c:when test="${not empty nutritionGuides}">
                            <c:forEach var="ng" items="${nutritionGuides}">
                                <div class="col-lg-4 col-md-6 col-12">
                                    <a href="${pageContext.request.contextPath}/user/content/view?id=${ng.id}" class="content-card-link" role="article">
                                        <div class="content-card-rich">
                                            <div class="content-card-image-wrap">
                                                <img src="${pageContext.request.contextPath}/${ng.imageUrl}" 
                                                     alt="${ng.title}" 
                                                     loading="lazy"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/protein-meal-prep.webp';">
                                                <div class="content-card-image-overlay"></div>
                                            </div>
                                            <div class="content-card-body">
                                                <div>
                                                    <div class="content-card-meta">
                                                        <span class="badge-custom badge-accent">${ng.subcategory}</span>
                                                        <small class="text-muted"><i class="fa-regular fa-clock me-1"></i>${ng.readTimeMinutes} min read</small>
                                                    </div>
                                                    <h5 class="content-card-title">${ng.title}</h5>
                                                    <p class="content-card-desc">${ng.description}</p>
                                                </div>
                                                <div class="content-card-footer">
                                                    <div class="content-author-pill">
                                                        <div class="content-author-dot">N</div>
                                                        <small class="text-secondary fw-semibold">Nutritionist Approved</small>
                                                    </div>
                                                    <span class="badge-custom badge-completed">
                                                        <i class="fa-solid fa-leaf text-accent"></i> Science-Backed
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="fitness-card text-center py-5">
                                    <i class="fa-solid fa-apple-whole fs-1 mb-3 text-muted"></i>
                                    <h4 class="text-theme-primary fw-bold">No nutrition guides found</h4>
                                    <p class="text-secondary mb-3">Try another nutrient category or reset filters.</p>
                                    <a href="${pageContext.request.contextPath}/user/content?tab=nutrition" class="btn btn-outline-custom">Reset Filters</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- SECTION 4: RECOVERY GUIDES -->
            <c:if test="${activeTab == 'recovery'}">
                <div class="row g-4 mb-5">
                    <c:choose>
                        <c:when test="${not empty recoveryGuides}">
                            <c:forEach var="rg" items="${recoveryGuides}">
                                <div class="col-lg-4 col-md-6 col-12">
                                    <a href="${pageContext.request.contextPath}/user/content/view?id=${rg.id}" class="content-card-link" role="article">
                                        <div class="content-card-rich">
                                            <div class="content-card-image-wrap">
                                                <img src="${pageContext.request.contextPath}/${rg.imageUrl}" 
                                                     alt="${rg.title}" 
                                                     loading="lazy"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/mobility.webp';">
                                                <div class="content-card-image-overlay"></div>
                                            </div>
                                            <div class="content-card-body">
                                                <div>
                                                    <div class="content-card-meta">
                                                        <span class="badge-custom badge-accent">${rg.subcategory}</span>
                                                        <small class="text-muted"><i class="fa-regular fa-clock me-1"></i>${rg.readTimeMinutes} min read</small>
                                                    </div>
                                                    <h5 class="content-card-title">${rg.title}</h5>
                                                    <p class="content-card-desc">${rg.description}</p>
                                                </div>
                                                <div class="content-card-footer">
                                                    <div class="content-author-pill">
                                                        <div class="content-author-dot">R</div>
                                                        <small class="text-secondary fw-semibold">Recovery Specialist</small>
                                                    </div>
                                                    <span class="badge-custom badge-completed">
                                                        <i class="fa-solid fa-spa text-accent"></i> Wellness
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="fitness-card text-center py-5">
                                    <i class="fa-solid fa-bed fs-1 mb-3 text-muted"></i>
                                    <h4 class="text-theme-primary fw-bold">No recovery guides found</h4>
                                    <p class="text-secondary mb-3">Try another sub-category or reset filters.</p>
                                    <a href="${pageContext.request.contextPath}/user/content?tab=recovery" class="btn btn-outline-custom">Reset Filters</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- SECTION 5: FITNESS ARTICLES & COMMUNITY -->
            <c:if test="${activeTab == 'articles'}">
                <div class="row g-4 mb-5">
                    <c:choose>
                        <c:when test="${not empty fitnessArticles}">
                            <c:forEach var="art" items="${fitnessArticles}">
                                <div class="col-lg-4 col-md-6 col-12">
                                    <a href="${pageContext.request.contextPath}/user/content/view?id=${art.id}" class="content-card-link" role="article">
                                        <div class="content-card-rich">
                                            <div class="content-card-image-wrap">
                                                <img src="${pageContext.request.contextPath}/${art.imageUrl}" 
                                                     alt="${art.title}" 
                                                     loading="lazy"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/mental-fatigue.webp';">
                                                <div class="content-card-image-overlay"></div>
                                            </div>
                                            <div class="content-card-body">
                                                <div>
                                                    <div class="content-card-meta">
                                                        <span class="badge-custom badge-accent">${art.category}</span>
                                                        <small class="text-muted"><fmt:formatDate value="${art.createdAt}" pattern="MMM d, yyyy"/></small>
                                                    </div>
                                                    <h5 class="content-card-title">${art.title}</h5>
                                                    <p class="content-card-desc">${art.description}</p>
                                                </div>
                                                <div class="content-card-footer">
                                                    <div class="content-author-pill">
                                                        <div class="content-author-dot">${empty art.authorName ? 'A' : art.authorName.substring(0, 1)}</div>
                                                        <small class="text-secondary fw-semibold">${empty art.authorName ? 'FitFlow Contributor' : art.authorName}</small>
                                                    </div>
                                                    <span class="badge-custom badge-completed">
                                                        <i class="fa-solid fa-circle-check text-accent"></i> Verified
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="fitness-card text-center py-5">
                                    <i class="fa-solid fa-newspaper fs-1 mb-3 text-muted"></i>
                                    <h4 class="text-theme-primary fw-bold">No community articles match your criteria</h4>
                                    <p class="text-secondary mb-3">Be the first to submit an article on this topic!</p>
                                    <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#submitContentModal">
                                        <i class="fa-solid fa-pen-nib me-1"></i> Submit Article
                                    </button>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- User's Personal Submissions Section (Always available if user has articles) -->
            <c:if test="${not empty userSubmissions}">
                <div class="fitness-card mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="text-theme-primary fw-bold mb-0">
                            <i class="fa-solid fa-file-pen text-accent me-2"></i> Your Submitted Articles & Guides
                        </h5>
                        <span class="text-muted small">${userSubmissions.size()} Submissions</span>
                    </div>
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Submitted Date</th>
                                    <th>Status</th>
                                    <th>Admin Feedback</th>
                                    <th class="text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sub" items="${userSubmissions}">
                                    <tr>
                                        <td>
                                            <div class="text-theme-primary fw-bold">${sub.title}</div>
                                            <small class="text-muted">${sub.description}</small>
                                        </td>
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
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/user/content/view?id=${sub.id}" class="btn btn-sm btn-outline-custom py-1 px-2">
                                                <i class="fa-solid fa-eye me-1"></i> View
                                            </a>
                                        </td>
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
                <h5 class="modal-title text-theme-primary"><i class="fa-solid fa-pen-nib text-accent me-2"></i> Submit Fitness Article or Guide</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/content/submit" method="POST" class="needs-validation" novalidate>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-7">
                            <label class="form-label-custom">Article Title</label>
                            <input type="text" name="title" class="form-control-custom" placeholder="e.g. 5 Strategies for Marathon Pacing" required>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label-custom">Category</label>
                            <select name="category" class="form-control-custom" required id="articleCategorySelect">
                                <option value="Workout Routines">Workout Routines</option>
                                <option value="Nutrition & Diet">Nutrition & Diet</option>
                                <option value="Cardio & Endurance">Cardio & Endurance</option>
                                <option value="Recovery & Wellness">Recovery & Wellness</option>
                                <option value="Motivation">Motivation</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Cover Image Theme</label>
                            <select name="imageUrl" class="form-control-custom">
                                <option value="assets/images/content/strength-training.webp">Strength Training / Gym Hero</option>
                                <option value="assets/images/content/protein-meal-prep.webp">High Protein Meal Prep / Nutrition</option>
                                <option value="assets/images/content/5k-running.webp">5K Outdoor Running / Endurance</option>
                                <option value="assets/images/content/mobility.webp">Hip & Spine Mobility / Stretching</option>
                                <option value="assets/images/content/mental-fatigue.webp">Athlete Recovery & Mindset / Motivation</option>
                                <option value="assets/images/content/healthy-nutrition.webp">Fresh Healthy Superfoods</option>
                                <option value="assets/images/content/cardio.webp">Battle Ropes & Cardio Conditioning</option>
                                <option value="assets/images/content/recovery.webp">Foam Rolling & Studio Recovery</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Short Summary (Displayed on Card)</label>
                            <textarea name="description" class="form-control-custom" rows="2" placeholder="Brief 2-line summary to hook readers on the cards..." required></textarea>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Full Guide / Article Content (Markdown supported)</label>
                            <textarea name="contentBody" class="form-control-custom" rows="8" placeholder="Write your full guide here. Use ## for section headings and - for bullet points..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-paper-plane me-1"></i> Submit for Review</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('hubLiveSearch');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const query = this.value.toLowerCase().trim();
            const exerciseCards = document.querySelectorAll('.exercise-item-card');
            const contentCards = document.querySelectorAll('.content-card-link');

            if (exerciseCards.length > 0) {
                exerciseCards.forEach(card => {
                    const text = card.textContent.toLowerCase();
                    if (!query || text.includes(query)) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }

            if (contentCards.length > 0) {
                contentCards.forEach(link => {
                    const parentCol = link.closest('.col-lg-4, .col-md-6, .col-12');
                    const text = link.textContent.toLowerCase();
                    if (parentCol) {
                        if (!query || text.includes(query)) {
                            parentCol.style.display = '';
                        } else {
                            parentCol.style.display = 'none';
                        }
                    }
                });
            }
        });
    }
});
</script>

<jsp:include page="../includes/footer.jsp"/>
