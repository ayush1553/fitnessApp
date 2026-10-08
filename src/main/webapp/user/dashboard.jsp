<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Dashboard - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="dashboard" scope="request"/>
<c:set var="pageHeaderTitle" value="DASHBOARD" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <!-- Sidebar Navigation -->
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <!-- Main Content Area -->
    <div class="app-main">
        <!-- Top Navbar -->
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <!-- Alert Notifications -->
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- CINEMATIC TIME-BASED GLASS WELCOME HERO -->
            <div class="cinematic-welcome-hero mb-4">
                <img id="dashboardHeroBgImg"
                     src="${pageContext.request.contextPath}/assets/images/challenges/running.jpg" 
                     alt="Cinematic Fitness Background" 
                     class="cinematic-welcome-bg">
                <div class="cinematic-welcome-overlay-layer"></div>
                <h1 class="cinematic-welcome-text" id="dashboardHeroGreeting">GOOD MORNING</h1>
            </div>

            <!-- Dashboard Grid Composition -->
            <div class="dashboard-grid">
                
                <!-- SECTION 1: WORKOUT ACTIVITY & CAPSULE CHART -->
                <div class="grid-col-8">
                    <div class="fitness-card h-100 d-flex flex-column">
                        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-active mb-1">Activity Breakdown</span>
                                <h5 class="mb-0 text-crystal">Workout Activity</h5>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <div class="btn-group btn-group-sm p-1 rounded-pill" style="background-color: var(--bg-secondary); border: 1px solid var(--border-color);">
                                    <button type="button" id="btnChartWeekly" class="btn btn-sm btn-accent rounded-pill px-3">Weekly</button>
                                    <button type="button" id="btnChartMonthly" class="btn btn-sm btn-outline-custom rounded-pill px-3">Monthly</button>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-4 mb-3 pb-2 border-bottom" style="border-color: var(--border-color) !important;">
                            <div>
                                <small class="text-secondary d-block" style="font-size: 0.75rem;">Total Duration</small>
                                <span class="fw-bold fs-5 text-theme-primary">${summary.durationFormatted}</span>
                            </div>
                            <div class="vr" style="background-color: var(--border-color); opacity: 1;"></div>
                            <div>
                                <small class="text-secondary d-block" style="font-size: 0.75rem;">Total Workouts</small>
                                <span class="fw-bold fs-5 text-theme-primary">${summary.totalWorkouts}</span>
                            </div>
                            <div class="vr" style="background-color: var(--border-color); opacity: 1;"></div>
                            <div>
                                <small class="text-secondary d-block" style="font-size: 0.75rem;">Calories Burned</small>
                                <span class="fw-bold fs-5" style="color: var(--accent-primary);"><fmt:formatNumber value="${summary.totalCalories}" pattern="#,###"/> kcal</span>
                            </div>
                        </div>

                        <div class="flex-grow-1" style="min-height: 220px; position: relative;">
                            <canvas id="workoutActivityChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- SECTION 2: FITNESS OVERVIEW & DONUT CHART -->
                <div class="grid-col-4">
                    <div class="fitness-card h-100 d-flex flex-column justify-content-between">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="mb-0 text-crystal">Overview</h5>
                            <span class="badge-custom badge-accent">${summary.goalCompletionPercentage}% Done</span>
                        </div>

                        <!-- Donut Chart -->
                        <div class="donut-chart-container my-2">
                            <canvas id="fitnessDonutChart"></canvas>
                            <div class="donut-center-text">
                                <div class="donut-pct-large">${summary.goalCompletionPercentage}%</div>
                                <div class="donut-pct-label">Goal Met</div>
                            </div>
                        </div>

                        <!-- Macro / Nutrition / Calorie Rows -->
                        <div class="mt-2">
                            <div class="stat-pill-row">
                                <span class="stat-pill-label">
                                    <i class="fa-solid fa-fire text-danger"></i> Calory burn
                                </span>
                                <span class="stat-pill-value text-theme-primary">33.5% <small class="text-accent" style="font-size: 0.75rem;">+1.25%</small></span>
                            </div>
                            <div class="stat-pill-row">
                                <span class="stat-pill-label">
                                    <i class="fa-solid fa-drumstick-bite text-info"></i> Protein
                                </span>
                                <span class="stat-pill-value text-theme-primary">23.02% <small class="text-accent" style="font-size: 0.75rem;">+3.43%</small></span>
                            </div>
                            <div class="stat-pill-row">
                                <span class="stat-pill-label">
                                    <i class="fa-solid fa-wheat-awn text-warning"></i> Carbs
                                </span>
                                <span class="stat-pill-value text-theme-primary">11.24% <small class="text-accent" style="font-size: 0.75rem;">+2.12%</small></span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION 3: IMAGE-RICH FITNESS GOAL CARDS -->
                <div class="grid-col-12">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <span class="badge-custom badge-accent mb-1">Target Goals</span>
                            <h5 class="mb-0 text-crystal">Fitness Focus & Daily Goals</h5>
                        </div>
                        <a href="${pageContext.request.contextPath}/user/goals" class="view-all-goals-link">
                            View All Goals <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>

                    <div class="row g-3">
                        <!-- Goal Card 1: Side Planks -->
                        <div class="col-md-4">
                            <div class="goal-photo-card" onclick="openExerciseDetailModal('side_planks')" role="button" tabindex="0" title="Click to view full exercise guide & details">
                                <div class="goal-image-container">
                                    <img src="${pageContext.request.contextPath}/assets/images/goals/side_plank.jpg" alt="Side Planks">
                                    <div class="goal-image-overlay-fade"></div>
                                </div>
                                <div class="goal-card-header-row">
                                    <span class="goal-card-badge"><i class="fa-solid fa-fire"></i> Core & Obliques</span>
                                    <span class="goal-card-status-pill"><i class="fa-solid fa-circle-check text-accent"></i> Active</span>
                                </div>
                                <div class="goal-card-content">
                                    <h4 class="goal-card-title">Side planks</h4>
                                    <p class="goal-card-target">12 sets/day</p>
                                    <div class="goal-card-action-link">
                                        <span>Exercise Guide</span>
                                        <i class="fa-solid fa-arrow-right"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Goal Card 2: Rope Lifting / Battle Ropes -->
                        <div class="col-md-4">
                            <div class="goal-photo-card" onclick="openExerciseDetailModal('rope_lifting')" role="button" tabindex="0" title="Click to view full exercise guide & details">
                                <div class="goal-image-container">
                                    <img src="${pageContext.request.contextPath}/assets/images/goals/rope_lifting.jpg" alt="Rope Lifting">
                                    <div class="goal-image-overlay-fade"></div>
                                </div>
                                <div class="goal-card-header-row">
                                    <span class="goal-card-badge"><i class="fa-solid fa-bolt"></i> HIIT Conditioning</span>
                                    <span class="goal-card-status-pill"><i class="fa-solid fa-circle-check text-accent"></i> Active</span>
                                </div>
                                <div class="goal-card-content">
                                    <h4 class="goal-card-title">Rope lifting</h4>
                                    <p class="goal-card-target">10 sets/day</p>
                                    <div class="goal-card-action-link">
                                        <span>Exercise Guide</span>
                                        <i class="fa-solid fa-arrow-right"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Goal Card 3: ABS & Strength -->
                        <div class="col-md-4">
                            <div class="goal-photo-card" onclick="openExerciseDetailModal('abs_strength')" role="button" tabindex="0" title="Click to view full exercise guide & details">
                                <div class="goal-image-container">
                                    <img src="${pageContext.request.contextPath}/assets/images/goals/abs_strength.jpg" alt="ABS & Strength">
                                    <div class="goal-image-overlay-fade"></div>
                                </div>
                                <div class="goal-card-header-row">
                                    <span class="goal-card-badge"><i class="fa-solid fa-shield-halved"></i> Core Strength</span>
                                    <span class="goal-card-status-pill"><i class="fa-solid fa-bullseye text-accent"></i> Daily Target</span>
                                </div>
                                <div class="goal-card-content">
                                    <h4 class="goal-card-title">ABS & Strength</h4>
                                    <p class="goal-card-target">10 min/day</p>
                                    <div class="goal-card-action-link">
                                        <span>Exercise Guide</span>
                                        <i class="fa-solid fa-arrow-right"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION 4: METRIC OUTPUT PILLS & CALORIE BURN LINE CHART -->
                <div class="grid-col-4 d-flex flex-column gap-3 justify-content-between">
                    <!-- Metric Pill 1: Calory Loss -->
                    <div class="metric-pill-card lime-pill">
                        <div>
                            <span class="text-secondary d-block" style="font-size: 0.78rem; font-weight: 600;">Calory loss</span>
                            <span class="fw-bold text-theme-primary fs-5">540 kcal <small class="text-muted" style="font-size: 0.75rem;">(.123 gm)</small></span>
                        </div>
                        <span class="badge rounded-pill" style="background: rgba(200, 255, 69, 0.2); color: var(--accent-primary); font-size: 0.8rem; font-weight: 700; padding: 0.4rem 0.8rem;">
                            😍 WOW
                        </span>
                    </div>

                    <!-- Metric Pill 2: Weight Loss -->
                    <div class="metric-pill-card cyan-pill">
                        <div>
                            <span class="text-secondary d-block" style="font-size: 0.78rem; font-weight: 600;">Weight loss</span>
                            <span class="fw-bold text-theme-primary fs-5">1.23 kg <small class="text-muted" style="font-size: 0.75rem;">(This week)</small></span>
                        </div>
                        <span class="badge rounded-pill" style="background: rgba(69, 255, 202, 0.2); color: #45ffca; font-size: 0.8rem; font-weight: 700; padding: 0.4rem 0.8rem;">
                            🔥 Great
                        </span>
                    </div>

                    <!-- Heart Rate Mini Card -->
                    <div class="fitness-card py-3 px-4 d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rec-icon-box" style="width: 42px; height: 42px; background: rgba(255, 92, 92, 0.15); color: #ff5c5c;">
                                <i class="fa-solid fa-heart-pulse"></i>
                            </div>
                            <div>
                                <small class="text-secondary d-block" style="font-size: 0.75rem;">Heart Rate</small>
                                <span class="fw-bold text-theme-primary fs-6">70 beats/m</span>
                            </div>
                        </div>
                        <span class="badge bg-danger bg-opacity-25 text-danger rounded-pill px-2 py-1" style="font-size: 0.72rem;">Normal</span>
                    </div>
                </div>

                <div class="grid-col-8">
                    <div class="fitness-card h-100">
                        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-accent mb-1">Trends</span>
                                <h5 class="mb-0 text-crystal">Calorie Burning & Energy Expenditure</h5>
                            </div>
                            <span class="text-secondary" style="font-size: 0.85rem;"><i class="fa-solid fa-chart-line me-1 text-accent"></i> 7-Day Performance</span>
                        </div>
                        <div style="height: 180px; position: relative;">
                            <canvas id="progressAnalyticsChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- SECTION 7: RECOMMENDED FOOD (NUTRITION LIBRARY CARDS) -->
                <div class="grid-col-12">
                    <div class="fitness-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-accent mb-1">Diet & Nutrition</span>
                                <h5 class="mb-0 text-crystal">Recommended Food</h5>
                            </div>
                            <a href="${pageContext.request.contextPath}/user/nutrition" class="view-all-goals-link">
                                View Nutrition Plan <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </div>

                        <div class="food-card-grid">
                            <!-- Food Card 1: Veggies and Hummus -->
                            <div class="food-portrait-card" onclick="openFoodDetailModal('veggies_hummus')" role="button" tabindex="0" title="Click to view meal recipe & exact serving quantity">
                                <img src="${pageContext.request.contextPath}/assets/images/food/veggies_hummus.jpg" 
                                     alt="Veggies and Hummus" 
                                     class="food-card-bg-img" 
                                     loading="lazy">
                                <div class="food-portrait-overlay"></div>
                                
                                <div class="food-portrait-header">
                                    <span class="food-day-badge-pill">Day 1</span>
                                    <span class="badge rounded-pill" style="background: rgba(0,0,0,0.6); color: rgba(255,255,255,0.85); font-size: 0.68rem; border: 1px solid rgba(255,255,255,0.12);">Dinner</span>
                                </div>
                                
                                <div class="food-portrait-content">
                                    <div class="food-meal-type-label">
                                        <i class="fa-solid fa-utensils"></i> DINNER
                                    </div>
                                    <h5 class="food-card-title-text">Veggies & Hummus</h5>
                                    <div class="food-card-macros-row">
                                        <span class="text-accent fw-bold">240 kcal</span>
                                        <span class="macro-dot">&bull;</span>
                                        <span>10g protein</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Food Card 2: A bowl of salad (Active Today) -->
                            <div class="food-portrait-card" onclick="openFoodDetailModal('salad_bowl')" role="button" tabindex="0" title="Click to view meal recipe & exact serving quantity">
                                <img src="${pageContext.request.contextPath}/assets/images/food/fresh_salad.jpg" 
                                     alt="A bowl of salad" 
                                     class="food-card-bg-img" 
                                     loading="lazy">
                                <div class="food-portrait-overlay"></div>
                                
                                <div class="food-portrait-header">
                                    <span class="food-day-badge-pill">Day 2</span>
                                    <span class="food-active-status-pill"><i class="fa-solid fa-fire"></i> Active Today</span>
                                </div>
                                
                                <div class="food-portrait-content">
                                    <div class="food-meal-type-label" style="color: #45ffca;">
                                        <i class="fa-solid fa-bowl-food"></i> LUNCH
                                    </div>
                                    <h5 class="food-card-title-text">Bowl of Salad</h5>
                                    <div class="food-card-macros-row">
                                        <span style="color: #45ffca; font-weight: 700;">310 kcal</span>
                                        <span class="macro-dot">&bull;</span>
                                        <span>14g protein</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Food Card 3: Green variety foods -->
                            <div class="food-portrait-card" onclick="openFoodDetailModal('green_bowl')" role="button" tabindex="0" title="Click to view meal recipe & exact serving quantity">
                                <img src="${pageContext.request.contextPath}/assets/images/food/green_variety.jpg" 
                                     alt="Green variety foods" 
                                     class="food-card-bg-img" 
                                     loading="lazy">
                                <div class="food-portrait-overlay"></div>
                                
                                <div class="food-portrait-header">
                                    <span class="food-day-badge-pill">Day 3</span>
                                    <span class="badge rounded-pill" style="background: rgba(0,0,0,0.6); color: rgba(255,255,255,0.85); font-size: 0.68rem; border: 1px solid rgba(255,255,255,0.12);">Breakfast</span>
                                </div>
                                
                                <div class="food-portrait-content">
                                    <div class="food-meal-type-label">
                                        <i class="fa-solid fa-sun"></i> BREAKFAST
                                    </div>
                                    <h5 class="food-card-title-text">Spinach & Green Bowl</h5>
                                    <div class="food-card-macros-row">
                                        <span class="text-accent fw-bold">380 kcal</span>
                                        <span class="macro-dot">&bull;</span>
                                        <span>18g protein</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Food Card 4: A bowl of berries -->
                            <div class="food-portrait-card" onclick="openFoodDetailModal('berry_bowl')" role="button" tabindex="0" title="Click to view meal recipe & exact serving quantity">
                                <img src="${pageContext.request.contextPath}/assets/images/food/berries_bowl.jpg" 
                                     alt="A bowl of berries" 
                                     class="food-card-bg-img" 
                                     loading="lazy">
                                <div class="food-portrait-overlay"></div>
                                
                                <div class="food-portrait-header">
                                    <span class="food-day-badge-pill">Day 4</span>
                                    <span class="badge rounded-pill" style="background: rgba(0,0,0,0.6); color: rgba(255,255,255,0.85); font-size: 0.68rem; border: 1px solid rgba(255,255,255,0.12);">Snack</span>
                                </div>
                                
                                <div class="food-portrait-content">
                                    <div class="food-meal-type-label">
                                        <i class="fa-solid fa-apple-whole"></i> SNACK
                                    </div>
                                    <h5 class="food-card-title-text">Oats & Berry Parfait</h5>
                                    <div class="food-card-macros-row">
                                        <span class="text-accent fw-bold">180 kcal</span>
                                        <span class="macro-dot">&bull;</span>
                                        <span>15g protein</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Food Card 5: Protein Meal Prep Bowl -->
                            <div class="food-portrait-card" onclick="openFoodDetailModal('protein_bowl')" role="button" tabindex="0" title="Click to view meal recipe & exact serving quantity">
                                <img src="${pageContext.request.contextPath}/assets/images/content/protein-meal-prep.jpg" 
                                     alt="Protein Meal Prep" 
                                     class="food-card-bg-img" 
                                     loading="lazy">
                                <div class="food-portrait-overlay"></div>
                                
                                <div class="food-portrait-header">
                                    <span class="food-day-badge-pill">Day 5</span>
                                    <span class="badge rounded-pill" style="background: rgba(0,0,0,0.6); color: rgba(255,255,255,0.85); font-size: 0.68rem; border: 1px solid rgba(255,255,255,0.12);">Lunch</span>
                                </div>
                                
                                <div class="food-portrait-content">
                                    <div class="food-meal-type-label">
                                        <i class="fa-solid fa-drumstick-bite"></i> LUNCH
                                    </div>
                                    <h5 class="food-card-title-text">Protein Meal Prep</h5>
                                    <div class="food-card-macros-row">
                                        <span class="text-accent fw-bold">420 kcal</span>
                                        <span class="macro-dot">&bull;</span>
                                        <span>38g protein</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Food Card 6: Superfood Harvest Salad -->
                            <div class="food-portrait-card" onclick="openFoodDetailModal('harvest_bowl')" role="button" tabindex="0" title="Click to view meal recipe & exact serving quantity">
                                <img src="${pageContext.request.contextPath}/assets/images/content/healthy-nutrition.jpg" 
                                     alt="Superfood Harvest Salad" 
                                     class="food-card-bg-img" 
                                     loading="lazy">
                                <div class="food-portrait-overlay"></div>
                                
                                <div class="food-portrait-header">
                                    <span class="food-day-badge-pill">Day 6</span>
                                    <span class="badge rounded-pill" style="background: rgba(0,0,0,0.6); color: rgba(255,255,255,0.85); font-size: 0.68rem; border: 1px solid rgba(255,255,255,0.12);">Dinner</span>
                                </div>
                                
                                <div class="food-portrait-content">
                                    <div class="food-meal-type-label">
                                        <i class="fa-solid fa-leaf"></i> DINNER
                                    </div>
                                    <h5 class="food-card-title-text">Harvest Superfood</h5>
                                    <div class="food-card-macros-row">
                                        <span class="text-accent fw-bold">340 kcal</span>
                                        <span class="macro-dot">&bull;</span>
                                        <span>16g protein</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION 8: RECENT WORKOUTS -->
                <div class="grid-col-6">
                    <div class="fitness-card h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-active mb-1">Activity</span>
                                <h5 class="mb-0 text-crystal">Recent Workouts</h5>
                            </div>
                            <a href="${pageContext.request.contextPath}/user/workouts" class="text-accent fw-bold" style="font-size: 0.85rem;">
                                View History <i class="fa-solid fa-arrow-right ms-1"></i>
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${not empty recentWorkouts}">
                                <c:forEach var="w" items="${recentWorkouts}">
                                    <div class="workout-item-row">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rec-icon-box" style="width: 38px; height: 38px;">
                                                <c:choose>
                                                    <c:when test="${w.workoutType == 'Running'}"><i class="fa-solid fa-person-running"></i></c:when>
                                                    <c:when test="${w.workoutType == 'Cycling'}"><i class="fa-solid fa-person-biking"></i></c:when>
                                                    <c:when test="${w.workoutType == 'Swimming'}"><i class="fa-solid fa-person-swimming"></i></c:when>
                                                    <c:when test="${w.workoutType == 'Gym' || w.workoutType == 'Strength Training'}"><i class="fa-solid fa-dumbbell"></i></c:when>
                                                    <c:when test="${w.workoutType == 'Yoga'}"><i class="fa-solid fa-spa"></i></c:when>
                                                    <c:otherwise><i class="fa-solid fa-bolt"></i></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <h6 class="mb-0 text-theme-primary fw-bold" style="font-size: 0.9rem;">${w.workoutType}</h6>
                                                <small class="text-muted"><fmt:formatDate value="${w.workoutDate}" pattern="MMM dd, yyyy"/> &bull; ${w.intensity} Intensity</small>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-theme-primary" style="font-size: 0.9rem;">${w.durationMinutes} min</div>
                                            <small style="color: var(--accent-primary); font-weight: 600;">${w.caloriesBurned} kcal</small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-dumbbell fs-2 mb-2"></i>
                                    <p class="mb-0">No workouts logged yet.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- SECTION 7: CHALLENGE PROGRESS -->
                <div class="grid-col-6">
                    <div class="fitness-card h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <span class="badge-custom badge-accent mb-1">Community</span>
                                <h5 class="mb-0 text-crystal">Active Challenges</h5>
                            </div>
                            <a href="${pageContext.request.contextPath}/user/challenges" class="text-accent fw-bold" style="font-size: 0.85rem;">
                                Explore <i class="fa-solid fa-arrow-right ms-1"></i>
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${not empty joinedChallenges}">
                                <c:forEach var="c" items="${joinedChallenges}">
                                    <div class="goal-item-card">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h6 class="mb-1 text-theme-primary fw-bold">${c.title}</h6>
                                                <small class="text-secondary">
                                                    <fmt:formatNumber value="${c.userParticipation.progress}" pattern="#,##0.#"/> / <fmt:formatNumber value="${c.targetValue}" pattern="#,##0.#"/> ${c.unit}
                                                </small>
                                            </div>
                                            <span class="badge-custom badge-accent">${c.userParticipation.progressPercentage}%</span>
                                        </div>

                                        <div class="progress-custom mb-2">
                                            <div class="progress-bar-custom" style="width: ${c.userParticipation.progressPercentage}%;"></div>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center" style="font-size: 0.75rem;">
                                            <span class="text-muted"><i class="fa-regular fa-clock me-1"></i> ${c.daysRemaining} days remaining</span>
                                            <button type="button" class="btn btn-sm btn-link text-accent p-0 text-decoration-none"
                                                    onclick="openChallengeProgressModal('${c.userParticipation.id}', '${c.title}', '${c.userParticipation.progress}', '${c.targetValue}', '${c.unit}')">
                                                Update Progress
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-trophy fs-2 mb-2"></i>
                                    <p class="mb-2">You have not joined any challenges yet.</p>
                                    <a href="${pageContext.request.contextPath}/user/challenges" class="btn btn-sm btn-accent">Browse Challenges</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- Modal: Quick Add Workout -->
<div class="modal fade" id="quickWorkoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-theme-primary"><i class="fa-solid fa-plus text-accent me-2"></i> Log New Workout</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form id="quickWorkoutForm" action="${pageContext.request.contextPath}/workout/add" method="POST" class="needs-validation" novalidate>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-custom">Workout Type</label>
                            <select name="workoutType" class="form-control-custom" required>
                                <option value="Running">Running</option>
                                <option value="Walking">Walking</option>
                                <option value="Cycling">Cycling</option>
                                <option value="Swimming">Swimming</option>
                                <option value="Gym">Gym / Weightlifting</option>
                                <option value="Yoga">Yoga</option>
                                <option value="Strength Training">Strength Training</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Duration (Minutes)</label>
                            <input type="number" name="durationMinutes" class="form-control-custom" placeholder="e.g. 45" min="1" max="1440" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Intensity</label>
                            <select name="intensity" class="form-control-custom">
                                <option value="Low">Low</option>
                                <option value="Medium" selected>Medium</option>
                                <option value="High">High</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Calories Burned (kcal)</label>
                            <input type="number" name="caloriesBurned" class="form-control-custom" placeholder="Auto-calculated">
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Date</label>
                            <input type="date" name="workoutDate" class="form-control-custom" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Session Notes (Optional)</label>
                            <textarea name="notes" class="form-control-custom" rows="2" placeholder="e.g. 5x5 squats, felt energized"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-check"></i> Save Workout</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Goal Progress Updater -->
<div class="modal fade" id="goalProgressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h6 class="modal-title text-theme-primary">Update Goal Progress</h6>
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

<!-- Modal: Exercise / Goal Detail & Video Guide (Apple TV Styled) -->
<div class="modal fade exercise-detail-modal" id="exerciseDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header border-0 pb-0 pt-3 px-4 d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                    <span id="modalExCategoryBadge" class="goal-card-badge"><i class="fa-solid fa-fire"></i> Core Focus</span>
                    <span id="modalExDifficultyBadge" class="goal-card-status-pill"><i class="fa-solid fa-gauge-high text-accent"></i> Intermediate</span>
                </div>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            
            <div class="modal-body px-4 py-3">
                <!-- Video / Instructional Media Player -->
                <div class="exercise-video-wrap mb-4" id="modalVideoContainer">
                    <img id="modalExPosterImg" src="" alt="Exercise Thumbnail" class="exercise-video-poster">
                    <div class="exercise-video-overlay">
                        <button class="exercise-video-play-btn" type="button" onclick="playExerciseDemoVideo()" title="Play Exercise Demonstration">
                            <i class="fa-solid fa-play"></i>
                        </button>
                    </div>
                    <div class="exercise-video-title-overlay">
                        <span class="badge bg-dark bg-opacity-75 text-accent px-2 py-1 mb-1 rounded-pill" style="font-size: 0.72rem; letter-spacing: 0.05em; font-weight: 700;">
                            <i class="fa-solid fa-circle-play me-1"></i> 4K TECHNIQUE DEMO
                        </span>
                        <h4 id="modalExVideoTitle" class="mb-0 text-white fw-bold" style="text-shadow: 0 2px 10px rgba(0,0,0,0.8);">Side Planks</h4>
                    </div>
                </div>

                <!-- Title & Action Bar -->
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 pb-3 mb-3 border-bottom border-secondary border-opacity-25">
                    <div>
                        <h3 id="modalExTitle" class="fw-bold mb-1 text-theme-primary">Side Planks</h3>
                        <p id="modalExSubtitle" class="text-secondary mb-0" style="font-size: 0.9rem;">Isometric Core & Lateral Stability Focus</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="px-3 py-2 rounded-3" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <small class="text-secondary d-block" style="font-size: 0.7rem; font-weight: 600; text-transform: uppercase;">Daily Goal</small>
                            <span id="modalExTargetText" class="fw-bold text-accent" style="font-size: 0.95rem;">12 sets / day</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/user/goals" class="btn btn-accent px-3 py-2 fw-semibold">
                            <i class="fa-solid fa-bullseye me-1"></i> Track in Goals
                        </a>
                    </div>
                </div>

                <!-- Exercise Overview & Benefits -->
                <div class="row g-3 mb-4">
                    <div class="col-md-7">
                        <div class="p-3 rounded-4 h-100" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <h6 class="fw-bold text-theme-primary mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-circle-info text-accent"></i> Overview
                            </h6>
                            <p id="modalExOverview" class="text-secondary mb-3" style="font-size: 0.88rem; line-height: 1.6;"></p>

                            <h6 class="fw-bold text-theme-primary mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-heart-pulse text-accent"></i> Why It Matters
                            </h6>
                            <p id="modalExWhyItMatters" class="text-secondary mb-0" style="font-size: 0.88rem; line-height: 1.6;"></p>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="p-3 rounded-4 h-100" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <h6 class="fw-bold text-theme-primary mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-person-running text-accent"></i> Target Muscles
                            </h6>
                            <div id="modalExMuscles" class="d-flex flex-wrap gap-1 mb-3"></div>

                            <h6 class="fw-bold text-theme-primary mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-triangle-exclamation text-warning"></i> Form Mistakes
                            </h6>
                            <ul id="modalExMistakes" class="exercise-mistakes-list mb-0" style="padding-left: 1.2rem; font-size: 0.82rem; color: var(--text-secondary);"></ul>
                        </div>
                    </div>
                </div>

                <!-- Step-by-Step Instructions -->
                <div class="p-3 rounded-4" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                    <h6 class="fw-bold text-theme-primary mb-3 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-list-check text-accent"></i> Step-by-Step Execution
                    </h6>
                    <ol id="modalExSteps" class="exercise-steps-list mb-0" style="padding-left: 1.2rem; font-size: 0.88rem; color: var(--text-primary); line-height: 1.65;"></ol>
                </div>
            </div>

            <div class="modal-footer border-0 pt-0 pb-3 px-4 d-flex justify-content-end">
                <button type="button" class="btn btn-outline-custom" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Food & Nutrition Detail (Apple TV Styled) -->
<div class="modal fade exercise-detail-modal" id="foodDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header border-0 pb-0 pt-3 px-4 d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                    <span id="modalFoodDayBadge" class="food-day-badge-pill"><i class="fa-solid fa-calendar-day me-1"></i> Day 1</span>
                    <span id="modalFoodMealTypeBadge" class="goal-card-badge"><i class="fa-solid fa-utensils"></i> Dinner</span>
                </div>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            
            <div class="modal-body px-4 py-3">
                <!-- Full Food Image Banner -->
                <div class="exercise-video-wrap mb-4 position-relative" style="aspect-ratio: 16 / 9; max-height: 280px; overflow: hidden; border-radius: 18px;">
                    <img id="modalFoodBannerImg" src="" alt="Food Preview" class="w-100 h-100" style="object-fit: cover; object-position: center;">
                    <div class="position-absolute bottom-0 start-0 end-0 p-3" style="background: linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.85) 100%);">
                        <span id="modalFoodTimingBadge" class="badge bg-dark bg-opacity-75 text-accent px-2 py-1 mb-1 rounded-pill" style="font-size: 0.72rem; font-weight: 700;">
                            <i class="fa-solid fa-clock me-1"></i> RECOMMENDED MEAL
                        </span>
                        <h4 id="modalFoodBannerTitle" class="mb-0 text-white fw-bold" style="text-shadow: 0 2px 10px rgba(0,0,0,0.8);">Veggies & Hummus</h4>
                    </div>
                </div>

                <!-- Title & Action Bar -->
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 pb-3 mb-3 border-bottom border-secondary border-opacity-25">
                    <div>
                        <h3 id="modalFoodTitle" class="fw-bold mb-1 text-theme-primary">Veggies & Hummus</h3>
                        <p id="modalFoodSubtitle" class="text-secondary mb-0" style="font-size: 0.9rem;">Clean Micronutrient & Fiber Focus</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="px-3 py-2 rounded-3 text-center" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <small class="text-secondary d-block" style="font-size: 0.7rem; font-weight: 600; text-transform: uppercase;">Energy</small>
                            <span id="modalFoodCaloriesText" class="fw-bold text-accent" style="font-size: 1.1rem;">240 kcal</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/user/nutrition" class="btn btn-accent px-3 py-2 fw-semibold">
                            <i class="fa-solid fa-bowl-rice me-1"></i> View Full Plan
                        </a>
                    </div>
                </div>

                <!-- Nutrition Breakdown (Macros Grid) -->
                <div class="row g-2 mb-4">
                    <div class="col">
                        <div class="p-2 rounded-3 text-center" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <small class="text-secondary d-block" style="font-size: 0.7rem;">PROTEIN</small>
                            <span id="modalFoodProtein" class="fw-bold text-theme-primary fs-6">10 g</span>
                        </div>
                    </div>
                    <div class="col">
                        <div class="p-2 rounded-3 text-center" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <small class="text-secondary d-block" style="font-size: 0.7rem;">CARBS</small>
                            <span id="modalFoodCarbs" class="fw-bold text-theme-primary fs-6">28 g</span>
                        </div>
                    </div>
                    <div class="col">
                        <div class="p-2 rounded-3 text-center" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <small class="text-secondary d-block" style="font-size: 0.7rem;">FAT</small>
                            <span id="modalFoodFat" class="fw-bold text-theme-primary fs-6">9 g</span>
                        </div>
                    </div>
                    <div class="col">
                        <div class="p-2 rounded-3 text-center" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <small class="text-secondary d-block" style="font-size: 0.7rem;">FIBER</small>
                            <span id="modalFoodFiber" class="fw-bold text-theme-primary fs-6">7 g</span>
                        </div>
                    </div>
                </div>

                <!-- Description & Exact Serving Quantity -->
                <div class="row g-3 mb-4">
                    <div class="col-md-7">
                        <div class="p-3 rounded-4 h-100" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <h6 class="fw-bold text-theme-primary mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-align-left text-accent"></i> Description
                            </h6>
                            <p id="modalFoodDescription" class="text-secondary mb-3" style="font-size: 0.88rem; line-height: 1.6;"></p>

                            <h6 class="fw-bold text-theme-primary mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-scale-balanced text-accent"></i> Quantity / Serving Size
                            </h6>
                            <p class="text-secondary mb-2" style="font-size: 0.82rem;">Exact measurable portions for this meal:</p>
                            <div id="modalFoodServingItems" class="d-flex flex-column gap-1 mb-2"></div>
                            <div class="pt-2 border-top d-flex justify-content-between align-items-center" style="border-color: var(--border-color) !important;">
                                <span class="fw-bold text-theme-primary" style="font-size: 0.85rem;">Total Meal Weight:</span>
                                <span id="modalFoodTotalServing" class="fw-bold text-accent" style="font-size: 0.88rem;">360 g</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="p-3 rounded-4 h-100" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                            <h6 class="fw-bold text-theme-primary mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-carrot text-accent"></i> Ingredients & Measurements
                            </h6>
                            <ul id="modalFoodIngredientsList" class="mb-3" style="padding-left: 0; list-style: none; font-size: 0.84rem; color: var(--text-secondary);"></ul>

                            <h6 class="fw-bold text-theme-primary mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-calendar-check text-accent"></i> Best Time to Eat
                            </h6>
                            <div class="p-2 rounded-3 mb-1" style="background: var(--surface-primary); border: 1px solid var(--border-color); font-size: 0.8rem;">
                                <div class="d-flex justify-content-between">
                                    <span class="text-secondary">Best for:</span>
                                    <span id="modalFoodBestTime" class="fw-bold text-theme-primary">Dinner</span>
                                </div>
                                <div class="d-flex justify-content-between mt-1">
                                    <span class="text-secondary">Recommended:</span>
                                    <span id="modalFoodFrequency" class="fw-bold text-accent">7 days</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- How to Prepare -->
                <div class="p-3 rounded-4" style="background: var(--surface-secondary); border: 1px solid var(--border-color);">
                    <h6 class="fw-bold text-theme-primary mb-3 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-kitchen-set text-accent"></i> How to Prepare
                    </h6>
                    <ol id="modalFoodPrepSteps" class="exercise-steps-list mb-0" style="padding-left: 1.2rem; font-size: 0.88rem; color: var(--text-primary); line-height: 1.65;"></ol>
                </div>
            </div>

            <div class="modal-footer border-0 pt-0 pb-3 px-4 d-flex justify-content-end">
                <button type="button" class="btn btn-outline-custom" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
    const FOOD_LIBRARY = {
        veggies_hummus: {
            title: "Veggies & Hummus",
            subtitle: "Clean Micronutrient, Healthy Fats & Plant-Based Fiber",
            day: "Day 1",
            mealType: "Dinner",
            calories: "240 kcal",
            protein: "10 g",
            carbs: "28 g",
            fat: "9 g",
            fiber: "7 g",
            image: "${pageContext.request.contextPath}/assets/images/food/veggies_hummus.jpg",
            description: "A light, fiber-rich evening meal combining fresh garden vegetables with artisanal chickpea hummus for a balanced source of complex carbohydrates, healthy unsaturated fats, and plant-based protein.",
            servingItems: [
                { name: "Creamy chickpea hummus", weight: "100 g" },
                { name: "Fresh English cucumber", weight: "100 g" },
                { name: "Organic carrot sticks", weight: "80 g" },
                { name: "Ripe cherry tomatoes", weight: "80 g" }
            ],
            totalServing: "360 g",
            ingredients: [
                "✓ Fresh cucumber (sliced rounds) — 100 g",
                "✓ Sweet organic carrots (cut into sticks) — 80 g",
                "✓ Cherry tomatoes (washed & halved) — 80 g",
                "✓ Artisanal chickpea hummus — 100 g",
                "✓ Freshly squeezed lemon juice — 10 ml",
                "✓ Smoked paprika & Mediterranean oregano — 5 g"
            ],
            bestTime: "Dinner",
            frequency: "7 days",
            prepSteps: [
                "Thoroughly wash and pat dry the cucumber, carrots, and cherry tomatoes.",
                "Slice the cucumber into even rounds and slice the peeled carrots into crisp dipping sticks.",
                "Spoon 100g of fresh chickpea hummus into a shallow serving bowl and lightly dust with paprika.",
                "Arrange the sliced vegetables neatly around the hummus and finish with a spritz of fresh lemon juice."
            ]
        },
        salad_bowl: {
            title: "Mediterranean Salad Bowl",
            subtitle: "Antioxidant-Rich Greens with Greek Feta & Olive Oil",
            day: "Day 2",
            mealType: "Lunch",
            calories: "310 kcal",
            protein: "14 g",
            carbs: "22 g",
            fat: "18 g",
            fiber: "6 g",
            image: "${pageContext.request.contextPath}/assets/images/food/fresh_salad.jpg",
            description: "A refreshing Mediterranean garden salad featuring crisp mixed greens, kalamata olives, diced avocado, and crumbled feta cheese dressed with cold-pressed extra virgin olive oil vinaigrette.",
            servingItems: [
                { name: "Organic mixed greens & arugula", weight: "120 g" },
                { name: "Crumbled low-fat feta cheese", weight: "50 g" },
                { name: "Diced Hass avocado", weight: "60 g" },
                { name: "Pitted Kalamata olives", weight: "30 g" },
                { name: "Olive oil & lemon vinaigrette", weight: "20 g" }
            ],
            totalServing: "280 g",
            ingredients: [
                "✓ Crisp mixed salad greens & wild arugula — 120 g",
                "✓ Authentic crumbled Greek feta — 50 g",
                "✓ Fresh ripe Hass avocado (diced) — 60 g",
                "✓ Pitted dark Kalamata olives — 30 g",
                "✓ Cold-pressed extra virgin olive oil — 15 ml",
                "✓ Aged red wine vinegar & dried Greek oregano — 5 ml"
            ],
            bestTime: "Lunch",
            frequency: "12 days",
            prepSteps: [
                "Toss rinsed and spun mixed greens in a wide ceramic salad bowl.",
                "Dice ripe avocado and gently distribute over the greens along with pitted olives.",
                "Crumble fresh feta cheese evenly across the salad.",
                "Whisk olive oil, red wine vinegar, oregano, and sea salt in a small ramekin; drizzle over salad right before serving."
            ]
        },
        green_bowl: {
            title: "Green Variety & Spinach Bowl",
            subtitle: "Micronutrient-Dense Superfood Power Breakfast",
            day: "Day 3",
            mealType: "Breakfast",
            calories: "380 kcal",
            protein: "18 g",
            carbs: "35 g",
            fat: "16 g",
            fiber: "9 g",
            image: "${pageContext.request.contextPath}/assets/images/food/green_variety.jpg",
            description: "An energizing green superfood breakfast bowl combining baby spinach, edamame, pumpkin seeds, and avocado cubes for high morning micronutrient density, sustained satiety, and steady energy.",
            servingItems: [
                { name: "Baby spinach & steamed kale", weight: "100 g" },
                { name: "Cooked green edamame beans", weight: "80 g" },
                { name: "Fresh Hass avocado cubes", weight: "70 g" },
                { name: "Toasted pumpkin & sunflower seeds", weight: "25 g" },
                { name: "Lime tahini dressing", weight: "25 g" }
            ],
            totalServing: "300 g",
            ingredients: [
                "✓ Baby spinach leaves & steamed curly kale — 100 g",
                "✓ Shelled cooked edamame beans — 80 g",
                "✓ Fresh Hass avocado cubes — 70 g",
                "✓ Roasted pumpkin & sunflower seeds — 25 g",
                "✓ Light lime-infused tahini dressing — 25 ml"
            ],
            bestTime: "Breakfast",
            frequency: "13 days",
            prepSteps: [
                "Lightly steam chopped kale for 2 minutes until tender, then mix with crisp raw baby spinach.",
                "Add warm cooked edamame beans and freshly cubed Hass avocado.",
                "Scatter toasted crunchy pumpkin and sunflower seeds over the top.",
                "Drizzle with zesty lime tahini dressing and enjoy immediately."
            ]
        },
        berry_bowl: {
            title: "Oats & Berry Parfait",
            subtitle: "Antioxidant Rich Berries & Probiotic Greek Yogurt",
            day: "Day 4",
            mealType: "Snack",
            calories: "180 kcal",
            protein: "15 g",
            carbs: "24 g",
            fat: "3 g",
            fiber: "5 g",
            image: "${pageContext.request.contextPath}/assets/images/food/berries_bowl.jpg",
            description: "Antioxidant-dense organic blueberries, strawberries, and blackberries layered over high-protein non-fat Greek yogurt with chia seeds for gut microbiome support and rapid post-workout recovery.",
            servingItems: [
                { name: "0% Non-Fat Authentic Greek Yogurt", weight: "170 g" },
                { name: "Fresh blueberries & blackberries", weight: "70 g" },
                { name: "Sliced fresh strawberries", weight: "50 g" },
                { name: "Organic black chia seeds", weight: "10 g" },
                { name: "Pure raw honey", weight: "5 g" }
            ],
            totalServing: "305 g",
            ingredients: [
                "✓ Thick strained Greek yogurt (0% fat) — 170 g",
                "✓ Fresh wild blueberries & blackberries — 70 g",
                "✓ Fresh ripe strawberries (hulled & sliced) — 50 g",
                "✓ Raw black chia seeds — 10 g",
                "✓ Pure clover honey drizzle — 5 g"
            ],
            bestTime: "Snack / Afternoon",
            frequency: "9 days",
            prepSteps: [
                "Spoon chilled thick Greek yogurt into a glass parfait cup or bowl.",
                "Rinse fresh berries and gently pat dry with a paper towel.",
                "Layer the blueberries, blackberries, and sliced strawberries over the yogurt.",
                "Dust with organic chia seeds and finish with a light drizzle of honey."
            ]
        },
        protein_bowl: {
            title: "Protein Meal Prep Bowl",
            subtitle: "Herb-Grilled Chicken Breast, Quinoa & Steamed Greens",
            day: "Day 5",
            mealType: "Lunch",
            calories: "420 kcal",
            protein: "38 g",
            carbs: "42 g",
            fat: "10 g",
            fiber: "8 g",
            image: "${pageContext.request.contextPath}/assets/images/content/protein-meal-prep.jpg",
            description: "A macronutrient-optimized fitness meal prep bowl with tender herb-grilled chicken breast, steamed tri-color quinoa, roasted broccoli florets, and caramelized sweet potato cubes.",
            servingItems: [
                { name: "Grilled chicken breast fillet", weight: "160 g" },
                { name: "Cooked tri-color quinoa", weight: "120 g" },
                { name: "Steamed broccoli florets", weight: "100 g" },
                { name: "Roasted sweet potato cubes", weight: "80 g" }
            ],
            totalServing: "460 g",
            ingredients: [
                "✓ Skinless lean chicken breast fillet — 160 g",
                "✓ Tri-color organic quinoa (cooked fluffy) — 120 g",
                "✓ Fresh broccoli florets — 100 g",
                "✓ Diced sweet potatoes — 80 g",
                "✓ Extra virgin olive oil spray, garlic powder & sea salt — 5 g"
            ],
            bestTime: "Lunch",
            frequency: "14 days",
            prepSteps: [
                "Season chicken with garlic powder, paprika, and sea salt; grill 6 minutes per side until 75°C internal temp.",
                "Simmer quinoa in low-sodium broth for 15 minutes; steam broccoli for 3 minutes until vibrant green.",
                "Toss sweet potatoes in olive oil spray and roast at 200°C for 20 minutes.",
                "Portion quinoa, sliced chicken breast, sweet potato cubes, and broccoli into meal prep container."
            ]
        },
        harvest_bowl: {
            title: "Superfood Harvest Salad",
            subtitle: "Roasted Chickpeas, Spinach, Walnuts & Goddess Dressing",
            day: "Day 6",
            mealType: "Dinner",
            calories: "340 kcal",
            protein: "16 g",
            carbs: "30 g",
            fat: "14 g",
            fiber: "7 g",
            image: "${pageContext.request.contextPath}/assets/images/content/healthy-nutrition.jpg",
            description: "A nourishing plant-forward harvest bowl with crisp baby spinach, oven-roasted spiced chickpeas, halved cherry tomatoes, California walnuts, and creamy avocado green goddess dressing.",
            servingItems: [
                { name: "Fresh organic baby spinach", weight: "100 g" },
                { name: "Crispy oven-roasted chickpeas", weight: "90 g" },
                { name: "Halved cherry tomatoes", weight: "70 g" },
                { name: "Raw California walnut halves", weight: "20 g" },
                { name: "Avocado green goddess dressing", weight: "20 g" }
            ],
            totalServing: "300 g",
            ingredients: [
                "✓ Organic baby spinach leaves — 100 g",
                "✓ Spiced roasted chickpeas (cumin & sea salt) — 90 g",
                "✓ Sweet cherry tomatoes (halved) — 70 g",
                "✓ Raw walnut halves (lightly crushed) — 20 g",
                "✓ Creamy avocado goddess vinaigrette — 20 ml"
            ],
            bestTime: "Dinner",
            frequency: "7 days",
            prepSteps: [
                "Wash and dry baby spinach thoroughly, placing into a wide salad bowl.",
                "Top with spiced roasted chickpeas and freshly halved cherry tomatoes.",
                "Crush raw walnut halves over the bowl for heart-healthy crunch.",
                "Drizzle with avocado dressing and toss lightly before enjoying."
            ]
        }
    };

    function openFoodDetailModal(foodKey) {
        const data = FOOD_LIBRARY[foodKey];
        if (!data) return;

        document.getElementById('modalFoodTitle').textContent = data.title;
        document.getElementById('modalFoodBannerTitle').textContent = data.title;
        document.getElementById('modalFoodSubtitle').textContent = data.subtitle;
        document.getElementById('modalFoodDayBadge').innerHTML = '<i class="fa-solid fa-calendar-day me-1"></i> ' + data.day;
        document.getElementById('modalFoodMealTypeBadge').innerHTML = '<i class="fa-solid fa-utensils me-1"></i> ' + data.mealType;
        document.getElementById('modalFoodBannerImg').src = data.image;
        document.getElementById('modalFoodCaloriesText').textContent = data.calories;
        document.getElementById('modalFoodProtein').textContent = data.protein;
        document.getElementById('modalFoodCarbs').textContent = data.carbs;
        document.getElementById('modalFoodFat').textContent = data.fat;
        document.getElementById('modalFoodFiber').textContent = data.fiber;
        document.getElementById('modalFoodDescription').textContent = data.description;
        document.getElementById('modalFoodTotalServing').textContent = data.totalServing;
        document.getElementById('modalFoodBestTime').textContent = data.bestTime;
        document.getElementById('modalFoodFrequency').textContent = data.frequency;

        // Serving items list
        const servingContainer = document.getElementById('modalFoodServingItems');
        servingContainer.innerHTML = '';
        data.servingItems.forEach(item => {
            const row = document.createElement('div');
            row.className = 'd-flex justify-content-between align-items-center py-1 border-bottom border-secondary border-opacity-10';
            row.style.fontSize = '0.84rem';
            row.innerHTML = '<span class="text-theme-primary">' + item.name + '</span><span class="fw-bold text-accent">' + item.weight + '</span>';
            servingContainer.appendChild(row);
        });

        // Ingredients list
        const ingredientsContainer = document.getElementById('modalFoodIngredientsList');
        ingredientsContainer.innerHTML = '';
        data.ingredients.forEach(ing => {
            const li = document.createElement('li');
            li.className = 'mb-1';
            li.textContent = ing;
            ingredientsContainer.appendChild(li);
        });

        // Preparation steps
        const prepContainer = document.getElementById('modalFoodPrepSteps');
        prepContainer.innerHTML = '';
        data.prepSteps.forEach(step => {
            const li = document.createElement('li');
            li.className = 'mb-2';
            li.textContent = step;
            prepContainer.appendChild(li);
        });

        const modal = new bootstrap.Modal(document.getElementById('foodDetailModal'));
        modal.show();
    }

    const EXERCISE_GUIDES = {
        side_planks: {
            title: "Side Planks",
            subtitle: "Isometric Core & Lateral Stability Focus",
            category: "Core & Obliques",
            difficulty: "Intermediate",
            target: "12 sets / day",
            image: "${pageContext.request.contextPath}/assets/images/goals/side_plank.jpg",
            overview: "The side plank is an essential isometric core exercise targeting the lateral abdominal wall, specifically the internal and external obliques, transverse abdominis, and quadratus lumborum to provide spinal stability.",
            whyItMatters: "Strong obliques and lateral stabilizers protect the lumbar spine against shearing forces during rotational movements, improve posture, reduce lower back fatigue, and enhance kinetic force transfer.",
            muscles: ["External Obliques", "Internal Obliques", "Transverse Abdominis", "Gluteus Medius", "Quadratus Lumborum", "Deltoids"],
            steps: [
                "Lie on your side with legs extended and feet stacked directly on top of each other. Rest weight on your forearm with elbow directly beneath shoulder.",
                "Contract your core and elevate your hips until your body forms a straight line from head to heels.",
                "Keep neck neutral by gazing forward. Do not allow your hips to sag or roll forward.",
                "Hold the position firmly for 30 to 45 seconds per set, breathing steadily through your diaphragm.",
                "Lower slowly with control, switch to the opposite side, and repeat for equal duration."
            ],
            mistakes: [
                "Allowing the hips to sag downward toward the floor.",
                "Rotating chest toward the ground instead of keeping shoulders vertically stacked.",
                "Holding breath during the isometric hold.",
                "Placing the supporting elbow too far in front of the shoulder."
            ]
        },
        rope_lifting: {
            title: "Rope Lifting (Battle Ropes)",
            subtitle: "High-Intensity Dynamic Power & Conditioning",
            category: "HIIT Conditioning",
            difficulty: "Intermediate",
            target: "10 sets / day",
            image: "${pageContext.request.contextPath}/assets/images/goals/rope_lifting.jpg",
            overview: "Battle rope lifting and waves provide a high-power, low-impact conditioning workout that taxes upper body musculature, raises anaerobic threshold, and develops rotational core endurance.",
            whyItMatters: "Delivers maximum cardiovascular output and metabolic conditioning without joint impact on knees and ankles. It simultaneously challenges grip strength, shoulder stability, and unilateral kinetic linking.",
            muscles: ["Anterior Deltoids", "Latissimus Dorsi", "Forearms & Grip", "Core Stabilizers", "Glutes & Quads", "Trapezius"],
            steps: [
                "Stand facing anchor point with feet shoulder-width apart in an athletic quarter-squat with flat back.",
                "Grip ends of ropes firmly with palms facing inward and elbows slightly bent.",
                "Initiate alternating rapid wave motions by raising one arm to shoulder height while slamming the other downward.",
                "Brace core tight throughout movement, absorbing momentum through hips and legs rather than lower back.",
                "Maintain explosive rhythm for 30-45 seconds per set with maximum effort."
            ],
            mistakes: [
                "Standing upright with locked knees, transferring stress to lower back.",
                "Relying solely on arm power without bracing core and anchoring hips.",
                "Gripping ropes too loosely or standing too far back with excessive tension."
            ]
        },
        abs_strength: {
            title: "ABS & Midline Strength",
            subtitle: "Advanced Hanging Leg Raises & Core Control",
            category: "Core Strength",
            difficulty: "Advanced",
            target: "10 min / day",
            image: "${pageContext.request.contextPath}/assets/images/goals/abs_strength.jpg",
            overview: "Targeted midline strength training focusing on dynamic flexion and anti-extension movements such as hanging leg raises, hollow holds, and dragon flags to forge functional core power.",
            whyItMatters: "Deep abdominal strength is the primary foundation for all heavy compound lifts. Developing rectus and transverse abdominis prevents pelvic anterior tilt and maximizes intra-abdominal pressure.",
            muscles: ["Rectus Abdominis", "Transverse Abdominis", "Iliopsoas", "Serratus Anterior", "Forearms & Grip"],
            steps: [
                "Grip pull-up bar with overhand grip, arms extended and shoulders actively depressed.",
                "Engage abdominals to curl pelvis upward before raising legs or knees toward chest.",
                "Pause at peak contraction for 1 full second, squeezing abs tightly without swinging.",
                "Lower legs down with slow, controlled 3-second eccentric tempo to starting dead-hang position.",
                "Perform consecutive strict repetitions without utilizing swinging momentum."
            ],
            mistakes: [
                "Using swinging momentum (kipping) to heave legs upward instead of pure abdominal contraction.",
                "Failing to posteriorly tilt pelvis at the top of movement.",
                "Dropping legs quickly on descent, losing the eccentric training phase."
            ]
        }
    };

    function openExerciseDetailModal(exerciseKey) {
        const data = EXERCISE_GUIDES[exerciseKey];
        if (!data) return;

        document.getElementById('modalExTitle').textContent = data.title;
        document.getElementById('modalExVideoTitle').textContent = data.title;
        document.getElementById('modalExSubtitle').textContent = data.subtitle;
        document.getElementById('modalExCategoryBadge').innerHTML = '<i class="fa-solid fa-fire"></i> ' + data.category;
        document.getElementById('modalExDifficultyBadge').innerHTML = '<i class="fa-solid fa-gauge-high text-accent"></i> ' + data.difficulty;
        document.getElementById('modalExTargetText').textContent = data.target;
        document.getElementById('modalExPosterImg').src = data.image;
        document.getElementById('modalExOverview').textContent = data.overview;
        document.getElementById('modalExWhyItMatters').textContent = data.whyItMatters;

        // Muscles chips
        const musclesContainer = document.getElementById('modalExMuscles');
        musclesContainer.innerHTML = '';
        data.muscles.forEach(m => {
            const chip = document.createElement('span');
            chip.className = 'badge rounded-pill px-2 py-1';
            chip.style.cssText = 'background: var(--surface-primary); border: 1px solid var(--border-color); color: var(--text-primary); font-size: 0.72rem; font-weight: 500;';
            chip.textContent = m;
            musclesContainer.appendChild(chip);
        });

        // Mistakes list
        const mistakesContainer = document.getElementById('modalExMistakes');
        mistakesContainer.innerHTML = '';
        data.mistakes.forEach(mistake => {
            const li = document.createElement('li');
            li.className = 'mb-1';
            li.textContent = mistake;
            mistakesContainer.appendChild(li);
        });

        // Steps list
        const stepsContainer = document.getElementById('modalExSteps');
        stepsContainer.innerHTML = '';
        data.steps.forEach(step => {
            const li = document.createElement('li');
            li.className = 'mb-2';
            li.textContent = step;
            stepsContainer.appendChild(li);
        });

        const modal = new bootstrap.Modal(document.getElementById('exerciseDetailModal'));
        modal.show();
    }

    function playExerciseDemoVideo() {
        const poster = document.getElementById('modalExPosterImg');
        const overlay = document.querySelector('.exercise-video-overlay');
        if (overlay) {
            overlay.innerHTML = '<div class="spinner-border text-accent" role="status"><span class="visually-hidden">Loading...</span></div>';
            setTimeout(() => {
                overlay.style.background = 'rgba(0,0,0,0.2)';
                overlay.innerHTML = '<span class="badge bg-dark text-accent px-3 py-2 rounded-pill shadow"><i class="fa-solid fa-circle-play me-1"></i> Playing Demonstration Stream</span>';
            }, 800);
        }
    }

    function updateCinematicGreeting() {
        const greetingEl = document.getElementById('dashboardHeroGreeting');
        const bgImgEl = document.getElementById('dashboardHeroBgImg');
        if (!greetingEl) return;

        const now = new Date();
        const hour = now.getHours();
        const contextPath = '${pageContext.request.contextPath}';

        let greeting = 'GOOD MORNING';
        let imgSrc = contextPath + '/assets/images/challenges/running.jpg';

        if (hour >= 5 && hour < 12) {
            greeting = 'GOOD MORNING';
            imgSrc = contextPath + '/assets/images/challenges/running.jpg';
        } else if (hour >= 12 && hour < 17) {
            greeting = 'GOOD AFTERNOON';
            imgSrc = contextPath + '/assets/images/challenges/strength.jpg';
        } else if (hour >= 17 && hour < 21) {
            greeting = 'GOOD EVENING';
            imgSrc = contextPath + '/assets/images/challenges/hiit.jpg';
        } else {
            greeting = 'GOOD NIGHT';
            imgSrc = contextPath + '/assets/images/challenges/yoga.jpg';
        }

        greetingEl.textContent = greeting;
        if (bgImgEl && !bgImgEl.getAttribute('data-init')) {
            bgImgEl.src = imgSrc;
            bgImgEl.setAttribute('data-init', 'true');
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        // Initialize dynamic time-based greeting
        updateCinematicGreeting();
        setInterval(updateCinematicGreeting, 60000);

        // Initialize dynamic charts using backend JSON data
        const weeklyData = ${weeklyDurationJson != null ? weeklyDurationJson : "{}"};
        const monthlyData = ${monthlyDurationJson != null ? monthlyDurationJson : "{}"};
        const weeklyCaloriesData = ${weeklyCaloriesJson != null ? weeklyCaloriesJson : "{}"};
        const goalPct = ${summary.goalCompletionPercentage != null ? summary.goalCompletionPercentage : 0};

        initWorkoutActivityChart(weeklyData, monthlyData);
        initFitnessDonutChart(goalPct);
        initProgressAnalyticsChart(weeklyCaloriesData);

        // Auto MET calorie calculation for modal form
        autoCalculateCalories('quickWorkoutForm', ${sessionScope.currentUser.profile != null && sessionScope.currentUser.profile.weightKg != null ? sessionScope.currentUser.profile.weightKg : 70});
    });
</script>

<jsp:include page="../includes/footer.jsp"/>
