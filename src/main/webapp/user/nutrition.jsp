<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Nutrition & Diet Planner - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="nutrition" scope="request"/>
<c:set var="greetingTitle" value="Nutrition" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Disclaimer Notice -->
            <div class="alert alert-dark d-flex align-items-center gap-3 mb-4 py-2 px-3" style="background: rgba(200, 255, 69, 0.05); border: 1px solid rgba(200, 255, 69, 0.2); border-radius: 12px;">
                <i class="fa-solid fa-circle-info fs-5" style="color: var(--accent-primary);"></i>
                <div style="font-size: 0.85rem; color: var(--text-secondary);">
                    <strong class="text-white">Estimated Targets:</strong> Calorie and macronutrient values are mathematical estimates based on the Mifflin-St Jeor formula and standard nutritional models. They are not intended as medical prescriptions.
                </div>
            </div>

            <c:choose>
                <%-- WIZARD SETUP (When no profile exists) --%>
                <c:when test="${empty nutritionProfile}">
                    <div class="row justify-content-center">
                        <div class="col-xl-9 col-lg-11">
                            <div class="fitness-card p-4 p-md-5">
                                <div class="text-center mb-4">
                                    <span class="badge-custom badge-accent mb-2"><i class="fa-solid fa-wand-magic-sparkles"></i> Guided Setup</span>
                                    <h2 class="text-white fw-bold mb-2">Personalized Nutrition Setup</h2>
                                    <p class="text-secondary" style="font-size: 0.95rem;">
                                        Answer a few quick questions to generate your science-backed daily calorie, macro, and meal recommendations.
                                    </p>
                                </div>

                                <!-- Step Indicators -->
                                <div class="d-flex justify-content-between position-relative mb-5 px-3">
                                    <div class="step-indicator active" id="step-node-1">
                                        <div class="step-circle">1</div>
                                        <span class="step-label">Personal Info</span>
                                    </div>
                                    <div class="step-indicator" id="step-node-2">
                                        <div class="step-circle">2</div>
                                        <span class="step-label">Activity</span>
                                    </div>
                                    <div class="step-indicator" id="step-node-3">
                                        <div class="step-circle">3</div>
                                        <span class="step-label">Fitness Goal</span>
                                    </div>
                                    <div class="step-indicator" id="step-node-4">
                                        <div class="step-circle">4</div>
                                        <span class="step-label">Diet & Foods</span>
                                    </div>
                                    <div class="step-indicator" id="step-node-5">
                                        <div class="step-circle">5</div>
                                        <span class="step-label">Meals</span>
                                    </div>
                                </div>

                                <form id="nutritionSetupForm" action="${pageContext.request.contextPath}/user/nutrition/setup" method="POST">
                                    
                                    <!-- STEP 1: Personal Info -->
                                    <div class="wizard-step" id="wizard-step-1">
                                        <h4 class="text-white mb-3"><i class="fa-solid fa-user-check text-accent me-2"></i> Step 1: Personal Information</h4>
                                        <p class="text-secondary mb-4" style="font-size: 0.9rem;">Auto-populated from your profile. Update if needed.</p>

                                        <div class="row g-4">
                                            <div class="col-md-6">
                                                <label class="form-label-custom">Age</label>
                                                <input type="number" name="age" class="form-control-custom" value="${not empty userProfile.age ? userProfile.age : 25}" min="10" max="120" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label-custom">Biological Sex</label>
                                                <select name="sex" class="form-control-custom" required>
                                                    <option value="Male" selected>Male</option>
                                                    <option value="Female">Female</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label-custom">Height (cm)</label>
                                                <input type="number" step="0.1" name="heightCm" class="form-control-custom" value="${not empty userProfile.height ? userProfile.height : 175.0}" min="50" max="280" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label-custom">Weight (kg)</label>
                                                <input type="number" step="0.1" name="weightKg" class="form-control-custom" value="${not empty userProfile.weight ? userProfile.weight : 75.0}" min="20" max="400" required>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-end mt-5">
                                            <button type="button" class="btn-accent px-4" onclick="goToStep(2)">
                                                Next: Activity Level <i class="fa-solid fa-arrow-right ms-2"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- STEP 2: Activity Level -->
                                    <div class="wizard-step d-none" id="wizard-step-2">
                                        <h4 class="text-white mb-2"><i class="fa-solid fa-person-running text-accent me-2"></i> Step 2: Activity Level</h4>
                                        <p class="text-secondary mb-4" style="font-size: 0.9rem;">What is your usual physical activity frequency?</p>

                                        <input type="hidden" name="activityLevel" id="inputActivityLevel" value="Moderately Active">

                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <div class="selectable-card" onclick="selectOption('activityLevel', 'Sedentary', this)">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <span class="card-title text-white fw-bold">Sedentary</span>
                                                        <i class="fa-solid fa-couch text-secondary"></i>
                                                    </div>
                                                    <small class="text-secondary">Little or no regular exercise, desk job.</small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="selectable-card" onclick="selectOption('activityLevel', 'Lightly Active', this)">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <span class="card-title text-white fw-bold">Lightly Active</span>
                                                        <i class="fa-solid fa-person-walking text-secondary"></i>
                                                    </div>
                                                    <small class="text-secondary">Light exercise / sports 1–3 days/week.</small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="selectable-card selected" onclick="selectOption('activityLevel', 'Moderately Active', this)">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <span class="card-title text-white fw-bold">Moderately Active</span>
                                                        <i class="fa-solid fa-person-running text-secondary"></i>
                                                    </div>
                                                    <small class="text-secondary">Moderate exercise / sports 3–5 days/week.</small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="selectable-card" onclick="selectOption('activityLevel', 'Very Active', this)">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <span class="card-title text-white fw-bold">Very Active</span>
                                                        <i class="fa-solid fa-dumbbell text-secondary"></i>
                                                    </div>
                                                    <small class="text-secondary">Hard exercise / sports 6–7 days/week.</small>
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <div class="selectable-card" onclick="selectOption('activityLevel', 'Extremely Active', this)">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <span class="card-title text-white fw-bold">Extremely Active</span>
                                                        <i class="fa-solid fa-fire-flame-curved text-secondary"></i>
                                                    </div>
                                                    <small class="text-secondary">Heavy physical job or 2x intense training sessions per day.</small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-between mt-5">
                                            <button type="button" class="btn-outline-custom px-4" onclick="goToStep(1)">
                                                <i class="fa-solid fa-arrow-left me-2"></i> Back
                                            </button>
                                            <button type="button" class="btn-accent px-4" onclick="goToStep(3)">
                                                Next: Fitness Goal <i class="fa-solid fa-arrow-right ms-2"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- STEP 3: Fitness Goal -->
                                    <div class="wizard-step d-none" id="wizard-step-3">
                                        <h4 class="text-white mb-2"><i class="fa-solid fa-bullseye text-accent me-2"></i> Step 3: Primary Fitness Goal</h4>
                                        <p class="text-secondary mb-4" style="font-size: 0.9rem;">What is your primary weight or body composition objective?</p>

                                        <input type="hidden" name="fitnessGoal" id="inputFitnessGoal" value="Maintenance">

                                        <div class="row g-3">
                                            <div class="col-md-4">
                                                <div class="selectable-card" onclick="selectOption('fitnessGoal', 'Cutting / Weight Loss', this)">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <span class="card-title text-white fw-bold">Cutting</span>
                                                        <i class="fa-solid fa-weight-scale text-danger"></i>
                                                    </div>
                                                    <p class="text-secondary mb-0" style="font-size: 0.85rem;">
                                                        Estimated calorie deficit (~500 kcal) for steady fat loss while preserving lean mass.
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="selectable-card selected" onclick="selectOption('fitnessGoal', 'Maintenance', this)">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <span class="card-title text-white fw-bold">Maintenance</span>
                                                        <i class="fa-solid fa-scale-balanced" style="color: var(--accent-primary);"></i>
                                                    </div>
                                                    <p class="text-secondary mb-0" style="font-size: 0.85rem;">
                                                        Caloric equilibrium matching your TDEE to maintain current weight and fuel workouts.
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="selectable-card" onclick="selectOption('fitnessGoal', 'Bulking / Weight Gain', this)">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <span class="card-title text-white fw-bold">Bulking</span>
                                                        <i class="fa-solid fa-chart-line text-warning"></i>
                                                    </div>
                                                    <p class="text-secondary mb-0" style="font-size: 0.85rem;">
                                                        Controlled calorie surplus (~400 kcal) rich in protein & carbohydrates to build muscle.
                                                    </p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-between mt-5">
                                            <button type="button" class="btn-outline-custom px-4" onclick="goToStep(2)">
                                                <i class="fa-solid fa-arrow-left me-2"></i> Back
                                            </button>
                                            <button type="button" class="btn-accent px-4" onclick="goToStep(4)">
                                                Next: Diet Preference <i class="fa-solid fa-arrow-right ms-2"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- STEP 4: Diet Preference & Exclusions -->
                                    <div class="wizard-step d-none" id="wizard-step-4">
                                        <h4 class="text-white mb-2"><i class="fa-solid fa-utensils text-accent me-2"></i> Step 4: Diet Preference & Exclusions</h4>
                                        <p class="text-secondary mb-4" style="font-size: 0.9rem;">Select your dietary lifestyle and specify any ingredient exclusions.</p>

                                        <input type="hidden" name="dietPreference" id="inputDietPreference" value="Non-Vegetarian">

                                        <div class="row g-3 mb-4">
                                            <div class="col-sm-6 col-md-3">
                                                <div class="selectable-card selected" onclick="selectOption('dietPreference', 'Non-Vegetarian', this)">
                                                    <span class="card-title text-white fw-bold d-block mb-1">Non-Veg</span>
                                                    <small class="text-secondary">Poultry, Meat, Fish, Dairy, Plant foods</small>
                                                </div>
                                            </div>
                                            <div class="col-sm-6 col-md-3">
                                                <div class="selectable-card" onclick="selectOption('dietPreference', 'Vegetarian', this)">
                                                    <span class="card-title text-white fw-bold d-block mb-1">Vegetarian</span>
                                                    <small class="text-secondary">Plant-based foods + Dairy (No meat/fish)</small>
                                                </div>
                                            </div>
                                            <div class="col-sm-6 col-md-3">
                                                <div class="selectable-card" onclick="selectOption('dietPreference', 'Eggetarian', this)">
                                                    <span class="card-title text-white fw-bold d-block mb-1">Eggetarian</span>
                                                    <small class="text-secondary">Vegetarian + Whole & White Eggs</small>
                                                </div>
                                            </div>
                                            <div class="col-sm-6 col-md-3">
                                                <div class="selectable-card" onclick="selectOption('dietPreference', 'Vegan', this)">
                                                    <span class="card-title text-white fw-bold d-block mb-1">Vegan</span>
                                                    <small class="text-secondary">100% Plant-based (No dairy, eggs, meat)</small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label-custom">Food Preferences / Exclusions (Optional)</label>
                                            <input type="text" name="foodExclusions" class="form-control-custom" placeholder="e.g. No dairy, no peanuts, no fish, no spicy food">
                                            <small class="text-secondary">Separate exclusions with commas.</small>
                                        </div>

                                        <div class="d-flex justify-content-between mt-5">
                                            <button type="button" class="btn-outline-custom px-4" onclick="goToStep(3)">
                                                <i class="fa-solid fa-arrow-left me-2"></i> Back
                                            </button>
                                            <button type="button" class="btn-accent px-4" onclick="goToStep(5)">
                                                Next: Meal Frequency <i class="fa-solid fa-arrow-right ms-2"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- STEP 5: Meal Preferences & Finalize -->
                                    <div class="wizard-step d-none" id="wizard-step-5">
                                        <h4 class="text-white mb-2"><i class="fa-solid fa-clock text-accent me-2"></i> Step 5: Meal Frequency</h4>
                                        <p class="text-secondary mb-4" style="font-size: 0.9rem;">How many meals and snacks do you prefer per day?</p>

                                        <input type="hidden" name="mealsPerDay" id="inputMealsPerDay" value="4">

                                        <div class="row g-3 mb-4">
                                            <div class="col-6 col-md-3">
                                                <div class="selectable-card" onclick="selectOption('mealsPerDay', '3', this)">
                                                    <span class="fs-4 fw-bold text-white d-block mb-1">3 Meals</span>
                                                    <small class="text-secondary">Breakfast, Lunch, Dinner</small>
                                                </div>
                                            </div>
                                            <div class="col-6 col-md-3">
                                                <div class="selectable-card selected" onclick="selectOption('mealsPerDay', '4', this)">
                                                    <span class="fs-4 fw-bold text-white d-block mb-1">4 Meals</span>
                                                    <small class="text-secondary">3 Meals + 1 Snack</small>
                                                </div>
                                            </div>
                                            <div class="col-6 col-md-3">
                                                <div class="selectable-card" onclick="selectOption('mealsPerDay', '5', this)">
                                                    <span class="fs-4 fw-bold text-white d-block mb-1">5 Meals</span>
                                                    <small class="text-secondary">3 Meals + 2 Snacks</small>
                                                </div>
                                            </div>
                                            <div class="col-6 col-md-3">
                                                <div class="selectable-card" onclick="selectOption('mealsPerDay', '6', this)">
                                                    <span class="fs-4 fw-bold text-white d-block mb-1">6 Meals</span>
                                                    <small class="text-secondary">Frequent micro-feedings</small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="fitness-card p-3 mb-4" style="background: rgba(255,255,255,0.02); border-color: var(--border-color);">
                                            <div class="d-flex align-items-center gap-3">
                                                <i class="fa-solid fa-calculator fs-4" style="color: var(--accent-primary);"></i>
                                                <div>
                                                    <span class="text-white fw-bold d-block" style="font-size: 0.9rem;">Instant Calculation</span>
                                                    <small class="text-secondary">FitFlow will compute your Mifflin-St Jeor BMR, activity multiplier TDEE, optimal macro split, and a customized multi-meal plan.</small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-between mt-5">
                                            <button type="button" class="btn-outline-custom px-4" onclick="goToStep(4)">
                                                <i class="fa-solid fa-arrow-left me-2"></i> Back
                                            </button>
                                            <button type="submit" class="btn-accent px-5">
                                                <i class="fa-solid fa-bolt me-2"></i> Generate My Nutrition Plan
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:when>

                <%-- NUTRITION DASHBOARD (When profile exists) --%>
                <c:otherwise>
                    <!-- Header Toolbar -->
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <h3 class="mb-0 text-white">Nutrition & Diet Planner</h3>
                                <span class="badge-custom badge-accent">${nutritionProfile.fitnessGoal}</span>
                                <span class="badge-custom" style="background: rgba(255,255,255,0.08); color: #fff;">${nutritionProfile.dietPreference}</span>
                            </div>
                            <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                                Personalized targets, daily macro tracking, meal breakdown, and hydration.
                            </p>
                        </div>
                        <div class="d-flex gap-2">
                            <button class="btn-outline-custom" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                <i class="fa-solid fa-sliders me-1"></i> Edit Profile
                            </button>
                            <button class="btn-outline-custom" data-bs-toggle="modal" data-bs-target="#regeneratePlanModal">
                                <i class="fa-solid fa-arrows-rotate me-1"></i> Regenerate Plan
                            </button>
                            <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#logFoodModal">
                                <i class="fa-solid fa-plus me-1"></i> Log Food
                            </button>
                        </div>
                    </div>

                    <!-- Top Physical & Target Summary Cards -->
                    <div class="row g-3 mb-4">
                        <div class="col-xl-3 col-sm-6">
                            <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                                <div class="rec-icon-box">
                                    <i class="fa-solid fa-gauge-high text-accent"></i>
                                </div>
                                <div>
                                    <small class="text-secondary d-block">BMI Status</small>
                                    <span class="fs-4 fw-bold text-white">
                                        <fmt:formatNumber value="${nutritionProfile.bmi}" pattern="#0.0"/>
                                    </span>
                                    <small class="text-muted ms-1">
                                        <c:choose>
                                            <c:when test="${nutritionProfile.bmi < 18.5}">(Underweight)</c:when>
                                            <c:when test="${nutritionProfile.bmi < 25}">(Normal)</c:when>
                                            <c:when test="${nutritionProfile.bmi < 30}">(Overweight)</c:when>
                                            <c:otherwise>(Obese)</c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-sm-6">
                            <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                                <div class="rec-icon-box">
                                    <i class="fa-solid fa-weight-hanging text-info"></i>
                                </div>
                                <div>
                                    <small class="text-secondary d-block">Current Weight</small>
                                    <span class="fs-4 fw-bold text-white">${nutritionProfile.weightKg} kg</span>
                                    <small class="text-muted ms-1">/ ${nutritionProfile.heightCm} cm</small>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-sm-6">
                            <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                                <div class="rec-icon-box">
                                    <i class="fa-solid fa-fire text-warning"></i>
                                </div>
                                <div>
                                    <small class="text-secondary d-block">Estimated Target Calories</small>
                                    <span class="fs-4 fw-bold" style="color: var(--accent-primary);">
                                        <fmt:formatNumber value="${nutritionTarget.targetCalories}" pattern="#,##0"/>
                                    </span>
                                    <small class="text-muted"> kcal/d</small>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-sm-6">
                            <div class="fitness-card fitness-card-sm d-flex align-items-center gap-3">
                                <div class="rec-icon-box">
                                    <i class="fa-solid fa-drumstick-bite" style="color: #60a5fa;"></i>
                                </div>
                                <div>
                                    <small class="text-secondary d-block">Protein Target</small>
                                    <span class="fs-4 fw-bold text-white">${nutritionTarget.targetProteinG}g</span>
                                    <small class="text-muted"> (${nutritionTarget.proteinPct}%)</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Macro Chart, Daily Tracker, & Hydration Row -->
                    <div class="row g-4 mb-4">
                        <!-- Left: Daily Macro Ring & Balance -->
                        <div class="col-lg-7">
                            <div class="fitness-card h-100">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="text-white fw-bold mb-0"><i class="fa-solid fa-chart-pie text-accent me-2"></i> Today's Calorie & Macro Budget</h5>
                                    <span class="text-muted" style="font-size: 0.8rem;">
                                        <i class="fa-regular fa-calendar me-1"></i> Today
                                    </span>
                                </div>

                                <div class="row align-items-center g-4">
                                    <div class="col-sm-5 text-center">
                                        <div style="position: relative; height: 180px; width: 180px; margin: 0 auto;">
                                            <canvas id="macroDonutChart"></canvas>
                                            <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center;">
                                                <div class="fs-5 fw-bold text-white mb-0">${consumedCalories}</div>
                                                <div class="text-muted" style="font-size: 0.75rem;">/ ${nutritionTarget.targetCalories} kcal</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-7">
                                        <!-- Protein -->
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="text-white fw-semibold" style="font-size: 0.85rem;">
                                                    <i class="fa-solid fa-square me-1" style="color: #60a5fa;"></i> Protein
                                                </span>
                                                <span class="text-secondary" style="font-size: 0.85rem;">
                                                    <strong class="text-white">${consumedProtein}g</strong> / ${nutritionTarget.targetProteinG}g
                                                </span>
                                            </div>
                                            <c:set var="proPct" value="${nutritionTarget.targetProteinG > 0 ? (consumedProtein * 100 / nutritionTarget.targetProteinG) : 0}"/>
                                            <div class="progress-custom">
                                                <div class="progress-bar" style="width: ${proPct > 100 ? 100 : proPct}%; background-color: #60a5fa;"></div>
                                            </div>
                                        </div>

                                        <!-- Carbs -->
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="text-white fw-semibold" style="font-size: 0.85rem;">
                                                    <i class="fa-solid fa-square me-1" style="color: var(--accent-primary);"></i> Carbohydrates
                                                </span>
                                                <span class="text-secondary" style="font-size: 0.85rem;">
                                                    <strong class="text-white">${consumedCarbs}g</strong> / ${nutritionTarget.targetCarbsG}g
                                                </span>
                                            </div>
                                            <c:set var="carbPct" value="${nutritionTarget.targetCarbsG > 0 ? (consumedCarbs * 100 / nutritionTarget.targetCarbsG) : 0}"/>
                                            <div class="progress-custom">
                                                <div class="progress-bar" style="width: ${carbPct > 100 ? 100 : carbPct}%; background-color: var(--accent-primary);"></div>
                                            </div>
                                        </div>

                                        <!-- Fats -->
                                        <div class="mb-1">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="text-white fw-semibold" style="font-size: 0.85rem;">
                                                    <i class="fa-solid fa-square me-1" style="color: #f59e0b;"></i> Fats
                                                </span>
                                                <span class="text-secondary" style="font-size: 0.85rem;">
                                                    <strong class="text-white">${consumedFat}g</strong> / ${nutritionTarget.targetFatG}g
                                                </span>
                                            </div>
                                            <c:set var="fatPct" value="${nutritionTarget.targetFatG > 0 ? (consumedFat * 100 / nutritionTarget.targetFatG) : 0}"/>
                                            <div class="progress-custom">
                                                <div class="progress-bar" style="width: ${fatPct > 100 ? 100 : fatPct}%; background-color: #f59e0b;"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right: Hydration / Water Tracker -->
                        <div class="col-lg-5">
                            <div class="fitness-card h-100 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="text-white fw-bold mb-0"><i class="fa-solid fa-glass-water text-info me-2"></i> Hydration Tracker</h5>
                                        <span class="badge-custom badge-accent">Target: ${nutritionTarget.waterTargetL} L</span>
                                    </div>

                                    <div class="text-center my-3">
                                        <span class="fs-1 fw-bold text-white">
                                            <fmt:formatNumber value="${todayWater}" pattern="#0.0#"/>
                                        </span>
                                        <span class="text-muted fs-5"> / ${nutritionTarget.waterTargetL} L</span>
                                        <c:set var="waterPct" value="${nutritionTarget.waterTargetL > 0 ? (todayWater * 100 / nutritionTarget.waterTargetL) : 0}"/>
                                        <div class="progress-custom mt-2" style="height: 10px;">
                                            <div class="progress-bar" style="width: ${waterPct > 100 ? 100 : waterPct}%; background-color: #38bdf8;"></div>
                                        </div>
                                    </div>
                                </div>

                                <div>
                                    <div class="d-flex flex-wrap gap-2 justify-content-center mb-2">
                                        <form action="${pageContext.request.contextPath}/user/nutrition/water/add" method="POST" class="d-inline">
                                            <input type="hidden" name="amountLiters" value="0.25">
                                            <button type="submit" class="btn btn-sm btn-outline-custom">+250 ml</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/user/nutrition/water/add" method="POST" class="d-inline">
                                            <input type="hidden" name="amountLiters" value="0.50">
                                            <button type="submit" class="btn btn-sm btn-outline-custom">+500 ml</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/user/nutrition/water/add" method="POST" class="d-inline">
                                            <input type="hidden" name="amountLiters" value="0.75">
                                            <button type="submit" class="btn btn-sm btn-outline-custom">+750 ml</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/user/nutrition/water/reset" method="POST" class="d-inline" onsubmit="return confirm('Reset today\\'s water count?');">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-rotate-left"></i> Reset</button>
                                        </form>
                                    </div>
                                    <p class="text-secondary text-center mb-0" style="font-size: 0.75rem;">
                                        Optimal hydration improves recovery and metabolic rate.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recommended Meal Plan Section -->
                    <div class="fitness-card mb-4">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                            <div>
                                <h4 class="text-white fw-bold mb-1"><i class="fa-solid fa-plate-wheat text-accent me-2"></i> ${mealPlan.planName}</h4>
                                <span class="text-secondary" style="font-size: 0.85rem;">
                                    Target Total: ~${mealPlan.totalCalories} kcal | ${mealPlan.totalProteinG}g Protein | ${mealPlan.totalCarbsG}g Carbs | ${mealPlan.totalFatG}g Fat
                                </span>
                            </div>
                            <span class="badge-custom badge-completed"><i class="fa-solid fa-circle-check"></i> Active Plan</span>
                        </div>

                        <div class="row g-3">
                            <c:forEach var="item" items="${mealPlan.items}">
                                <div class="col-lg-6">
                                    <div class="p-3 rounded" style="background: rgba(255,255,255,0.02); border: 1px solid var(--border-color);">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <span class="badge-custom badge-accent mb-1">Meal ${item.mealNumber}</span>
                                                <h5 class="text-white fw-bold mb-0">${item.mealName}</h5>
                                            </div>
                                            <div class="text-end">
                                                <span class="text-white fw-bold" style="font-size: 0.95rem;">${item.calories} kcal</span>
                                                <div class="text-muted" style="font-size: 0.75rem;">P: ${item.proteinG}g | C: ${item.carbsG}g | F: ${item.fatG}g</div>
                                            </div>
                                        </div>
                                        <p class="text-secondary mb-2" style="font-size: 0.85rem; line-height: 1.4;">
                                            ${item.foodItems}
                                        </p>
                                        <div class="d-flex justify-content-between align-items-center pt-2 border-top" style="border-color: var(--border-color) !important;">
                                            <small class="text-muted">${item.notes}</small>
                                            <button class="btn btn-sm btn-outline-custom p-1 px-2" style="font-size: 0.75rem;" 
                                                    onclick="quickLogMeal('${item.mealName}', '${item.calories}', '${item.proteinG}', '${item.carbsG}', '${item.fatG}')">
                                                <i class="fa-solid fa-check-double me-1"></i> Log This Meal
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Today's Logged Foods List -->
                    <div class="fitness-card mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="text-white fw-bold mb-0"><i class="fa-solid fa-clipboard-list text-accent me-2"></i> Today's Food Logs</h5>
                            <button class="btn-accent btn-sm" data-bs-toggle="modal" data-bs-target="#logFoodModal">
                                <i class="fa-solid fa-plus me-1"></i> Add Food Item
                            </button>
                        </div>

                        <c:choose>
                            <c:when test="${not empty todayLogs}">
                                <div class="table-responsive">
                                    <table class="table table-dark table-hover mb-0" style="background: transparent;">
                                        <thead>
                                            <tr style="border-bottom: 1px solid var(--border-color); color: var(--text-secondary); font-size: 0.8rem; text-transform: uppercase;">
                                                <th>Meal Type</th>
                                                <th>Food / Description</th>
                                                <th>Portion</th>
                                                <th>Calories</th>
                                                <th>Protein</th>
                                                <th>Carbs</th>
                                                <th>Fat</th>
                                                <th class="text-end">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody style="border-top: none;">
                                            <c:forEach var="log" items="${todayLogs}">
                                                <tr style="border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 0.9rem;">
                                                    <td><span class="badge-custom badge-accent">${log.mealType}</span></td>
                                                    <td class="text-white fw-bold">${log.foodName}</td>
                                                    <td class="text-secondary">${log.portionSize}</td>
                                                    <td class="text-white fw-bold">${log.calories} kcal</td>
                                                    <td class="text-info">${log.proteinG}g</td>
                                                    <td style="color: var(--accent-primary);">${log.carbsG}g</td>
                                                    <td class="text-warning">${log.fatG}g</td>
                                                    <td class="text-end">
                                                        <form action="${pageContext.request.contextPath}/user/nutrition/log/delete" method="POST" class="d-inline" onsubmit="return confirm('Remove this food item?');">
                                                            <input type="hidden" name="id" value="${log.id}">
                                                            <button type="submit" class="btn btn-sm text-danger p-0 px-2"><i class="fa-solid fa-trash"></i></button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-utensils fs-3 mb-2"></i>
                                    <p class="mb-0">No food logged yet today. Click "Log Food" or use "Log This Meal" above!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 7-Day Trend Chart -->
                    <div class="fitness-card mb-4">
                        <h5 class="text-white fw-bold mb-3"><i class="fa-solid fa-chart-line text-accent me-2"></i> 7-Day Caloric Intake History</h5>
                        <div style="height: 240px; position: relative;">
                            <canvas id="nutritionTrendsChart"></canvas>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Modal: Log Food Item -->
<div class="modal fade" id="logFoodModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-white"><i class="fa-solid fa-utensils text-accent me-2"></i> Log Food Item</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/user/nutrition/log/add" method="POST" class="needs-validation" novalidate>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-6">
                            <label class="form-label-custom">Meal Type</label>
                            <select name="mealType" id="logMealType" class="form-control-custom" required>
                                <option value="Breakfast">Breakfast</option>
                                <option value="Lunch">Lunch</option>
                                <option value="Snack">Snack</option>
                                <option value="Dinner">Dinner</option>
                                <option value="Pre-Workout">Pre-Workout</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Log Date</label>
                            <input type="date" name="logDate" class="form-control-custom" value="<fmt:formatDate value='<%= new java.util.Date() %>' pattern='yyyy-MM-dd'/>">
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Food Name / Description</label>
                            <input type="text" name="foodName" id="logFoodName" class="form-control-custom" placeholder="e.g. Grilled Chicken Salad" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Portion Size</label>
                            <input type="text" name="portionSize" id="logPortionSize" class="form-control-custom" placeholder="e.g. 1 bowl (200g)">
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Calories (kcal)</label>
                            <input type="number" name="calories" id="logCalories" class="form-control-custom" placeholder="350" required min="0">
                        </div>
                        <div class="col-4">
                            <label class="form-label-custom">Protein (g)</label>
                            <input type="number" name="proteinG" id="logProteinG" class="form-control-custom" placeholder="30" value="0" min="0">
                        </div>
                        <div class="col-4">
                            <label class="form-label-custom">Carbs (g)</label>
                            <input type="number" name="carbsG" id="logCarbsG" class="form-control-custom" placeholder="25" value="0" min="0">
                        </div>
                        <div class="col-4">
                            <label class="form-label-custom">Fat (g)</label>
                            <input type="number" name="fatG" id="logFatG" class="form-control-custom" placeholder="8" value="0" min="0">
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-check me-1"></i> Save Log</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Regenerate / Customize Plan -->
<div class="modal fade" id="regeneratePlanModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-white"><i class="fa-solid fa-arrows-rotate text-accent me-2"></i> Regenerate Meal Plan</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/user/nutrition/generate-plan" method="POST">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-custom">Fitness Goal</label>
                            <select name="fitnessGoal" class="form-control-custom">
                                <option value="Cutting / Weight Loss" ${nutritionProfile.fitnessGoal == 'Cutting / Weight Loss' ? 'selected' : ''}>Cutting / Weight Loss (Deficit)</option>
                                <option value="Maintenance" ${nutritionProfile.fitnessGoal == 'Maintenance' ? 'selected' : ''}>Maintenance (Equilibrium)</option>
                                <option value="Bulking / Weight Gain" ${nutritionProfile.fitnessGoal == 'Bulking / Weight Gain' ? 'selected' : ''}>Bulking / Muscle Gain (Surplus)</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Diet Preference</label>
                            <select name="dietPreference" class="form-control-custom">
                                <option value="Non-Vegetarian" ${nutritionProfile.dietPreference == 'Non-Vegetarian' ? 'selected' : ''}>Non-Vegetarian</option>
                                <option value="Vegetarian" ${nutritionProfile.dietPreference == 'Vegetarian' ? 'selected' : ''}>Vegetarian</option>
                                <option value="Eggetarian" ${nutritionProfile.dietPreference == 'Eggetarian' ? 'selected' : ''}>Eggetarian</option>
                                <option value="Vegan" ${nutritionProfile.dietPreference == 'Vegan' ? 'selected' : ''}>Vegan</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Meals Per Day</label>
                            <select name="mealsPerDay" class="form-control-custom">
                                <option value="3" ${nutritionProfile.mealsPerDay == 3 ? 'selected' : ''}>3 Meals</option>
                                <option value="4" ${nutritionProfile.mealsPerDay == 4 ? 'selected' : ''}>4 Meals</option>
                                <option value="5" ${nutritionProfile.mealsPerDay == 5 ? 'selected' : ''}>5 Meals</option>
                                <option value="6" ${nutritionProfile.mealsPerDay == 6 ? 'selected' : ''}>6 Meals</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Food Exclusions (Optional)</label>
                            <input type="text" name="foodExclusions" class="form-control-custom" value="${nutritionProfile.foodExclusions}">
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-wand-magic-sparkles me-1"></i> Generate Plan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Edit Profile -->
<div class="modal fade" id="editProfileModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-custom">
            <div class="modal-header modal-header-custom">
                <h5 class="modal-title text-white"><i class="fa-solid fa-sliders text-accent me-2"></i> Edit Nutrition Profile</h5>
                <button type="button" class="btn-close-custom" data-bs-dismiss="modal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="${pageContext.request.contextPath}/user/nutrition/setup" method="POST">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-6">
                            <label class="form-label-custom">Age</label>
                            <input type="number" name="age" class="form-control-custom" value="${nutritionProfile.age}" required min="10" max="120">
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Sex</label>
                            <select name="sex" class="form-control-custom">
                                <option value="Male" ${nutritionProfile.sex == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${nutritionProfile.sex == 'Female' ? 'selected' : ''}>Female</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Height (cm)</label>
                            <input type="number" step="0.1" name="heightCm" class="form-control-custom" value="${nutritionProfile.heightCm}" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Weight (kg)</label>
                            <input type="number" step="0.1" name="weightKg" class="form-control-custom" value="${nutritionProfile.weightKg}" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Activity Level</label>
                            <select name="activityLevel" class="form-control-custom">
                                <option value="Sedentary" ${nutritionProfile.activityLevel == 'Sedentary' ? 'selected' : ''}>Sedentary (Little or no exercise)</option>
                                <option value="Lightly Active" ${nutritionProfile.activityLevel == 'Lightly Active' ? 'selected' : ''}>Lightly Active (1-3 days/wk)</option>
                                <option value="Moderately Active" ${nutritionProfile.activityLevel == 'Moderately Active' ? 'selected' : ''}>Moderately Active (3-5 days/wk)</option>
                                <option value="Very Active" ${nutritionProfile.activityLevel == 'Very Active' ? 'selected' : ''}>Very Active (6-7 days/wk)</option>
                                <option value="Extremely Active" ${nutritionProfile.activityLevel == 'Extremely Active' ? 'selected' : ''}>Extremely Active (2x daily/hard)</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Fitness Goal</label>
                            <select name="fitnessGoal" class="form-control-custom">
                                <option value="Cutting / Weight Loss" ${nutritionProfile.fitnessGoal == 'Cutting / Weight Loss' ? 'selected' : ''}>Cutting / Weight Loss</option>
                                <option value="Maintenance" ${nutritionProfile.fitnessGoal == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                <option value="Bulking / Weight Gain" ${nutritionProfile.fitnessGoal == 'Bulking / Weight Gain' ? 'selected' : ''}>Bulking / Weight Gain</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Diet Preference</label>
                            <select name="dietPreference" class="form-control-custom">
                                <option value="Non-Vegetarian" ${nutritionProfile.dietPreference == 'Non-Vegetarian' ? 'selected' : ''}>Non-Vegetarian</option>
                                <option value="Vegetarian" ${nutritionProfile.dietPreference == 'Vegetarian' ? 'selected' : ''}>Vegetarian</option>
                                <option value="Eggetarian" ${nutritionProfile.dietPreference == 'Eggetarian' ? 'selected' : ''}>Eggetarian</option>
                                <option value="Vegan" ${nutritionProfile.dietPreference == 'Vegan' ? 'selected' : ''}>Vegan</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label-custom">Meals Per Day</label>
                            <select name="mealsPerDay" class="form-control-custom">
                                <option value="3" ${nutritionProfile.mealsPerDay == 3 ? 'selected' : ''}>3 Meals</option>
                                <option value="4" ${nutritionProfile.mealsPerDay == 4 ? 'selected' : ''}>4 Meals</option>
                                <option value="5" ${nutritionProfile.mealsPerDay == 5 ? 'selected' : ''}>5 Meals</option>
                                <option value="6" ${nutritionProfile.mealsPerDay == 6 ? 'selected' : ''}>6 Meals</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Food Exclusions</label>
                            <input type="text" name="foodExclusions" class="form-control-custom" value="${nutritionProfile.foodExclusions}">
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-check me-1"></i> Save & Recalculate</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
.step-indicator {
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
    z-index: 2;
}
.step-circle {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: var(--bg-card);
    border: 2px solid var(--border-color);
    color: var(--text-secondary);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    margin-bottom: 6px;
    transition: all 0.2s ease;
}
.step-label {
    font-size: 0.8rem;
    color: var(--text-secondary);
    font-weight: 500;
}
.step-indicator.active .step-circle {
    background: var(--accent-primary);
    border-color: var(--accent-primary);
    color: #000;
    box-shadow: 0 0 15px rgba(200, 255, 69, 0.4);
}
.step-indicator.active .step-label {
    color: #fff;
    font-weight: 700;
}
.selectable-card {
    background: var(--bg-card);
    border: 1px solid var(--border-color);
    border-radius: 12px;
    padding: 16px;
    cursor: pointer;
    transition: all 0.2s ease;
    height: 100%;
}
.selectable-card:hover {
    border-color: rgba(200, 255, 69, 0.5);
    transform: translateY(-2px);
}
.selectable-card.selected {
    border-color: var(--accent-primary);
    background: rgba(200, 255, 69, 0.06);
}
</style>

<script>
function goToStep(step) {
    document.querySelectorAll('.wizard-step').forEach(el => el.classList.add('d-none'));
    document.getElementById('wizard-step-' + step).classList.remove('d-none');

    for (let i = 1; i <= 5; i++) {
        const node = document.getElementById('step-node-' + i);
        if (i <= step) {
            node.classList.add('active');
        } else {
            node.classList.remove('active');
        }
    }
}

function selectOption(fieldName, val, element) {
    if (fieldName === 'activityLevel') document.getElementById('inputActivityLevel').value = val;
    if (fieldName === 'fitnessGoal') document.getElementById('inputFitnessGoal').value = val;
    if (fieldName === 'dietPreference') document.getElementById('inputDietPreference').value = val;
    if (fieldName === 'mealsPerDay') document.getElementById('inputMealsPerDay').value = val;

    // Highlight selected card within this group
    element.closest('.row').querySelectorAll('.selectable-card').forEach(el => el.classList.remove('selected'));
    element.classList.add('selected');
}

function quickLogMeal(mealName, cal, pro, carb, fat) {
    document.getElementById('logMealType').value = mealName.includes('Breakfast') ? 'Breakfast' : (mealName.includes('Lunch') ? 'Lunch' : (mealName.includes('Dinner') ? 'Dinner' : 'Snack'));
    document.getElementById('logFoodName').value = mealName + " Standard Portion";
    document.getElementById('logPortionSize').value = "1 planned meal";
    document.getElementById('logCalories').value = cal;
    document.getElementById('logProteinG').value = pro;
    document.getElementById('logCarbsG').value = carb;
    document.getElementById('logFatG').value = fat;

    const modal = new bootstrap.Modal(document.getElementById('logFoodModal'));
    modal.show();
}

// Chart.js initialization
document.addEventListener('DOMContentLoaded', function() {
    <c:if test="${not empty nutritionProfile}">
        // 1. Macro Donut
        const ctxDonut = document.getElementById('macroDonutChart');
        if (ctxDonut) {
            const consumedPro = ${consumedProtein} * 4;
            const consumedCarb = ${consumedCarbs} * 4;
            const consumedFat = ${consumedFat} * 9;
            const totalTarget = ${nutritionTarget.targetCalories};
            const remaining = Math.max(0, totalTarget - (${consumedCalories}));

            new Chart(ctxDonut, {
                type: 'doughnut',
                data: {
                    labels: ['Protein (kcal)', 'Carbs (kcal)', 'Fat (kcal)', 'Remaining (kcal)'],
                    datasets: [{
                        data: [consumedPro, consumedCarb, consumedFat, remaining],
                        backgroundColor: ['#60a5fa', '#C8FF45', '#f59e0b', '#252925'],
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '75%',
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(c) {
                                    return ' ' + c.label + ': ' + c.raw + ' kcal';
                                }
                            }
                        }
                    }
                }
            });
        }

        // 2. 7-Day History Chart
        const ctxTrends = document.getElementById('nutritionTrendsChart');
        if (ctxTrends) {
            const trendLabels = [];
            const trendCalories = [];
            const trendProtein = [];

            <c:forEach var="t" items="${nutritionTrends}">
                trendLabels.push('<fmt:formatDate value="${t.logDate}" pattern="MMM dd"/>');
                trendCalories.push(${t.calories});
                trendProtein.push(${t.protein});
            </c:forEach>

            if (trendLabels.length === 0) {
                trendLabels.push('Today');
                trendCalories.push(${consumedCalories});
                trendProtein.push(${consumedProtein});
            }

            new Chart(ctxTrends, {
                type: 'bar',
                data: {
                    labels: trendLabels,
                    datasets: [
                        {
                            label: 'Calories Consumed',
                            data: trendCalories,
                            backgroundColor: 'rgba(200, 255, 69, 0.7)',
                            borderColor: '#C8FF45',
                            borderWidth: 1,
                            borderRadius: 6,
                            yAxisID: 'y'
                        },
                        {
                            label: 'Protein (g)',
                            data: trendProtein,
                            type: 'line',
                            borderColor: '#60a5fa',
                            backgroundColor: 'transparent',
                            borderWidth: 2,
                            pointBackgroundColor: '#60a5fa',
                            tension: 0.3,
                            yAxisID: 'y1'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            grid: { color: 'rgba(255,255,255,0.05)' },
                            ticks: { color: '#929792' }
                        },
                        y: {
                            position: 'left',
                            grid: { color: 'rgba(255,255,255,0.05)' },
                            ticks: { color: '#929792' },
                            title: { display: true, text: 'Calories (kcal)', color: '#929792' }
                        },
                        y1: {
                            position: 'right',
                            grid: { drawOnChartArea: false },
                            ticks: { color: '#60a5fa' },
                            title: { display: true, text: 'Protein (g)', color: '#60a5fa' }
                        }
                    },
                    plugins: {
                        legend: {
                            labels: { color: '#ffffff' }
                        }
                    }
                }
            });
        }
    </c:if>
});
</script>

<jsp:include page="../includes/footer.jsp"/>
