<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Customize Appearance - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="customize" scope="request"/>
<c:set var="greetingTitle" value="Theme Settings" scope="request"/>

<jsp:include page="../includes/header.jsp"/>

<div class="app-wrapper">
    <jsp:include page="../includes/user-sidebar.jsp"/>

    <div class="app-main">
        <jsp:include page="../includes/navbar.jsp"/>

        <div class="page-container">
            <jsp:include page="../includes/alerts.jsp"/>

            <!-- Page Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="text-theme-primary fw-bold mb-1" style="font-size: 1.75rem; letter-spacing: -0.02em;">
                        Customize Your Experience
                    </h2>
                    <p class="text-secondary mb-0" style="font-size: 0.95rem;">
                        Personalize how FitFlow looks and feels across all your devices.
                    </p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <form action="${pageContext.request.contextPath}/user/customize" method="POST" class="d-inline" onsubmit="return confirm('Restore all theme settings to factory default?');">
                        <input type="hidden" name="action" value="reset">
                        <button type="submit" class="btn-outline-custom text-secondary" style="font-size: 0.85rem; padding: 0.6rem 1rem;">
                            <i class="fa-solid fa-arrow-rotate-left me-1"></i> Reset to Default
                        </button>
                    </form>
                </div>
            </div>

            <!-- Customization Grid -->
            <form id="customizeForm" action="${pageContext.request.contextPath}/user/customize" method="POST">
                <input type="hidden" id="inputThemeMode" name="themeMode" value="${preferences.themeMode != null ? preferences.themeMode : 'DARK'}">
                <input type="hidden" id="inputAccentColor" name="accentColor" value="${preferences.accentColor != null ? preferences.accentColor : 'LIME'}">
                <input type="hidden" id="inputGlassIntensity" name="glassIntensity" value="${preferences.glassIntensity != null ? preferences.glassIntensity : 'MEDIUM'}">

                <div class="row g-4">
                    <!-- Left Column: Controls -->
                    <div class="col-lg-7">

                        <!-- Theme Mode Card -->
                        <div class="fitness-card mb-4">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <div class="stat-icon-wrapper" style="width: 38px; height: 38px; font-size: 1rem;">
                                    <i class="fa-solid fa-circle-half-stroke text-accent"></i>
                                </div>
                                <div>
                                    <h5 class="text-theme-primary fw-bold mb-0" style="font-size: 1.1rem;">Theme Mode</h5>
                                    <span class="text-secondary" style="font-size: 0.8rem;">Select your preferred background and contrast balance</span>
                                </div>
                            </div>

                            <div class="row g-3" id="themeModeOptions">
                                <!-- Dark Mode -->
                                <div class="col-sm-4">
                                    <div class="theme-option-card ${preferences.themeMode == 'DARK' || preferences.themeMode == null ? 'active' : ''}" 
                                         data-value="DARK" 
                                         onclick="selectThemeMode('DARK')">
                                        <div class="theme-option-preview bg-dark-preview">
                                            <i class="fa-solid fa-moon"></i>
                                        </div>
                                        <div class="theme-option-info">
                                            <div class="theme-option-title">Dark Mode</div>
                                            <div class="theme-option-subtitle">Aurora Glass aesthetic</div>
                                        </div>
                                        <i class="fa-solid fa-circle-check check-indicator"></i>
                                    </div>
                                </div>

                                <!-- Light Mode -->
                                <div class="col-sm-4">
                                    <div class="theme-option-card ${preferences.themeMode == 'LIGHT' ? 'active' : ''}" 
                                         data-value="LIGHT" 
                                         onclick="selectThemeMode('LIGHT')">
                                        <div class="theme-option-preview bg-light-preview">
                                            <i class="fa-solid fa-sun"></i>
                                        </div>
                                        <div class="theme-option-info">
                                            <div class="theme-option-title">Light Mode</div>
                                            <div class="theme-option-subtitle">Crisp and high clarity</div>
                                        </div>
                                        <i class="fa-solid fa-circle-check check-indicator"></i>
                                    </div>
                                </div>

                                <!-- System Mode -->
                                <div class="col-sm-4">
                                    <div class="theme-option-card ${preferences.themeMode == 'SYSTEM' ? 'active' : ''}" 
                                         data-value="SYSTEM" 
                                         onclick="selectThemeMode('SYSTEM')">
                                        <div class="theme-option-preview bg-system-preview">
                                            <i class="fa-solid fa-desktop"></i>
                                        </div>
                                        <div class="theme-option-info">
                                            <div class="theme-option-title">System</div>
                                            <div class="theme-option-subtitle">Syncs with OS theme</div>
                                        </div>
                                        <i class="fa-solid fa-circle-check check-indicator"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Accent Color Card -->
                        <div class="fitness-card mb-4">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <div class="stat-icon-wrapper" style="width: 38px; height: 38px; font-size: 1rem;">
                                    <i class="fa-solid fa-palette text-accent"></i>
                                </div>
                                <div>
                                    <h5 class="text-theme-primary fw-bold mb-0" style="font-size: 1.1rem;">Accent Color</h5>
                                    <span class="text-secondary" style="font-size: 0.8rem;">Choose the highlight tone for buttons, graphs, and badges</span>
                                </div>
                            </div>

                            <div class="accent-swatch-grid" id="accentOptions">
                                <!-- Lime -->
                                <div class="accent-swatch-item ${preferences.accentColor == 'LIME' || preferences.accentColor == null ? 'active' : ''}" 
                                     data-value="LIME" 
                                     onclick="selectAccentColor('LIME')">
                                    <div class="accent-dot" style="background: #C8FF45; box-shadow: 0 0 12px rgba(200, 255, 69, 0.45);"></div>
                                    <div class="accent-label">
                                        <span class="accent-name">Volt Lime</span>
                                        <span class="accent-hex">#C8FF45</span>
                                    </div>
                                    <i class="fa-solid fa-check swatch-check"></i>
                                </div>

                                <!-- Emerald -->
                                <div class="accent-swatch-item ${preferences.accentColor == 'EMERALD' ? 'active' : ''}" 
                                     data-value="EMERALD" 
                                     onclick="selectAccentColor('EMERALD')">
                                    <div class="accent-dot" style="background: #34D399; box-shadow: 0 0 12px rgba(52, 211, 153, 0.45);"></div>
                                    <div class="accent-label">
                                        <span class="accent-name">Emerald</span>
                                        <span class="accent-hex">#34D399</span>
                                    </div>
                                    <i class="fa-solid fa-check swatch-check"></i>
                                </div>

                                <!-- Cyan -->
                                <div class="accent-swatch-item ${preferences.accentColor == 'CYAN' ? 'active' : ''}" 
                                     data-value="CYAN" 
                                     onclick="selectAccentColor('CYAN')">
                                    <div class="accent-dot" style="background: #45D9FF; box-shadow: 0 0 12px rgba(69, 217, 255, 0.45);"></div>
                                    <div class="accent-label">
                                        <span class="accent-name">Neon Cyan</span>
                                        <span class="accent-hex">#45D9FF</span>
                                    </div>
                                    <i class="fa-solid fa-check swatch-check"></i>
                                </div>

                                <!-- Purple -->
                                <div class="accent-swatch-item ${preferences.accentColor == 'PURPLE' ? 'active' : ''}" 
                                     data-value="PURPLE" 
                                     onclick="selectAccentColor('PURPLE')">
                                    <div class="accent-dot" style="background: #A78BFA; box-shadow: 0 0 12px rgba(167, 139, 250, 0.45);"></div>
                                    <div class="accent-label">
                                        <span class="accent-name">Cyber Purple</span>
                                        <span class="accent-hex">#A78BFA</span>
                                    </div>
                                    <i class="fa-solid fa-check swatch-check"></i>
                                </div>

                                <!-- Blue -->
                                <div class="accent-swatch-item ${preferences.accentColor == 'BLUE' ? 'active' : ''}" 
                                     data-value="BLUE" 
                                     onclick="selectAccentColor('BLUE')">
                                    <div class="accent-dot" style="background: #60A5FA; box-shadow: 0 0 12px rgba(96, 165, 250, 0.45);"></div>
                                    <div class="accent-label">
                                        <span class="accent-name">Sky Blue</span>
                                        <span class="accent-hex">#60A5FA</span>
                                    </div>
                                    <i class="fa-solid fa-check swatch-check"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Glass Effect Intensity Card -->
                        <div class="fitness-card mb-4">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <div class="stat-icon-wrapper" style="width: 38px; height: 38px; font-size: 1rem;">
                                    <i class="fa-solid fa-wand-magic-sparkles text-accent"></i>
                                </div>
                                <div>
                                    <h5 class="text-theme-primary fw-bold mb-0" style="font-size: 1.1rem;">Glass Effect Intensity</h5>
                                    <span class="text-secondary" style="font-size: 0.8rem;">Adjust backdrop blur density and translucent surface depth</span>
                                </div>
                            </div>

                            <div class="glass-tier-group" id="glassOptions">
                                <div class="glass-tier-btn ${preferences.glassIntensity == 'SUBTLE' ? 'active' : ''}" 
                                     data-value="SUBTLE" 
                                     onclick="selectGlassIntensity('SUBTLE')">
                                    <div class="glass-tier-title">Subtle</div>
                                    <div class="glass-tier-desc">10px Blur &bull; Lightweight</div>
                                </div>
                                <div class="glass-tier-btn ${preferences.glassIntensity == 'MEDIUM' || preferences.glassIntensity == null ? 'active' : ''}" 
                                     data-value="MEDIUM" 
                                     onclick="selectGlassIntensity('MEDIUM')">
                                    <div class="glass-tier-title">Medium</div>
                                    <div class="glass-tier-desc">20px Blur &bull; Balanced (Recommended)</div>
                                </div>
                                <div class="glass-tier-btn ${preferences.glassIntensity == 'STRONG' ? 'active' : ''}" 
                                     data-value="STRONG" 
                                     onclick="selectGlassIntensity('STRONG')">
                                    <div class="glass-tier-title">Strong</div>
                                    <div class="glass-tier-desc">30px Blur &bull; Deep Frosted Glass</div>
                                </div>
                            </div>
                        </div>

                        <!-- Interface Preferences Card -->
                        <div class="fitness-card mb-4">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <div class="stat-icon-wrapper" style="width: 38px; height: 38px; font-size: 1rem;">
                                    <i class="fa-solid fa-sliders text-accent"></i>
                                </div>
                                <div>
                                    <h5 class="text-theme-primary fw-bold mb-0" style="font-size: 1.1rem;">Interface &amp; Layout</h5>
                                    <span class="text-secondary" style="font-size: 0.8rem;">Toggle visual dynamics and layout density</span>
                                </div>
                            </div>

                            <div class="d-flex flex-column gap-3">
                                <!-- Animations Toggle -->
                                <div class="d-flex justify-content-between align-items-center p-3 rounded-3" style="background-color: var(--bg-secondary); border: 1px solid var(--border-color);">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="stat-icon-wrapper" style="width: 34px; height: 34px; font-size: 0.9rem;">
                                            <i class="fa-solid fa-film text-accent"></i>
                                        </div>
                                        <div>
                                            <div class="text-theme-primary fw-semibold" style="font-size: 0.95rem;">Interface Animations</div>
                                            <div class="text-secondary" style="font-size: 0.8rem;">Smooth card hovers, glowing light shifts, and chart transitions</div>
                                        </div>
                                    </div>
                                    <div class="form-check form-switch m-0">
                                        <input class="form-check-input custom-switch" type="checkbox" role="switch" id="animationsToggle" 
                                               name="animationsEnabled" value="true" 
                                               ${preferences.animationsEnabled || preferences == null ? 'checked' : ''} 
                                               onchange="toggleAnimations(this.checked)">
                                    </div>
                                </div>

                                <!-- Compact Mode Toggle -->
                                <div class="d-flex justify-content-between align-items-center p-3 rounded-3" style="background-color: var(--bg-secondary); border: 1px solid var(--border-color);">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="stat-icon-wrapper" style="width: 34px; height: 34px; font-size: 0.9rem;">
                                            <i class="fa-solid fa-compress text-accent"></i>
                                        </div>
                                        <div>
                                            <div class="text-theme-primary fw-semibold" style="font-size: 0.95rem;">Compact Mode</div>
                                            <div class="text-secondary" style="font-size: 0.8rem;">Denser table layouts, tighter padding, and optimized data density</div>
                                        </div>
                                    </div>
                                    <div class="form-check form-switch m-0">
                                        <input class="form-check-input custom-switch" type="checkbox" role="switch" id="compactToggle" 
                                               name="compactMode" value="true" 
                                               ${preferences.compactMode ? 'checked' : ''} 
                                               onchange="toggleCompact(this.checked)">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Button Container -->
                        <div class="d-flex align-items-center gap-3 pt-2">
                            <button type="submit" class="btn-custom flex-grow-1 py-3" style="font-size: 1rem; font-weight: 700; letter-spacing: 0.02em;">
                                <i class="fa-solid fa-floppy-disk me-2"></i> Save Changes
                            </button>
                        </div>

                    </div>

                    <!-- Right Column: Live Interactive Preview -->
                    <div class="col-lg-5">
                        <div class="sticky-top" style="top: 96px; z-index: 10;">
                            <div class="fitness-card preview-container-card">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="live-pill-indicator"></span>
                                        <h5 class="text-theme-primary fw-bold mb-0" style="font-size: 1.05rem;">Live Theme Preview</h5>
                                    </div>
                                    <span class="badge-custom badge-accent" id="previewBadge">
                                        <i class="fa-solid fa-wand-magic me-1"></i> Real-time
                                    </span>
                                </div>
                                <p class="text-secondary mb-4" style="font-size: 0.82rem;">
                                    This mock dashboard preview updates dynamically as you select different options.
                                </p>

                                <!-- Mock Dashboard Mini Container -->
                                <div class="mock-preview-viewport p-3 rounded-4" id="mockPreviewViewport">
                                    
                                    <!-- Mini Header -->
                                    <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom" style="border-color: var(--border-color) !important;">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="brand-logo-icon" style="width: 28px; height: 28px; font-size: 0.8rem;">
                                                <i class="fa-solid fa-bolt"></i>
                                            </div>
                                            <span class="fw-bold text-theme-primary" style="font-size: 0.85rem;">FIT<span class="text-accent">FLOW</span></span>
                                        </div>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="badge-custom badge-active" style="font-size: 0.7rem; padding: 0.2rem 0.55rem;" id="mockThemeTag">DARK</span>
                                            <div class="avatar-circle" style="width: 26px; height: 26px; font-size: 0.75rem;">
                                                ${sessionScope.currentUser.name.substring(0, 1)}
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Mock Metric Cards Row -->
                                    <div class="row g-2 mb-3">
                                        <div class="col-6">
                                            <div class="p-2 rounded-3 mock-mini-card">
                                                <div class="d-flex align-items-center gap-2 mb-1">
                                                    <div class="stat-icon-wrapper" style="width: 24px; height: 24px; font-size: 0.7rem;">
                                                        <i class="fa-solid fa-fire text-accent"></i>
                                                    </div>
                                                    <span class="text-secondary" style="font-size: 0.7rem;">Burned</span>
                                                </div>
                                                <div class="text-theme-primary fw-bold" style="font-size: 1rem;">640 <span class="text-secondary" style="font-size: 0.65rem;">kcal</span></div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="p-2 rounded-3 mock-mini-card">
                                                <div class="d-flex align-items-center gap-2 mb-1">
                                                    <div class="stat-icon-wrapper" style="width: 24px; height: 24px; font-size: 0.7rem;">
                                                        <i class="fa-solid fa-stopwatch text-accent"></i>
                                                    </div>
                                                    <span class="text-secondary" style="font-size: 0.7rem;">Active</span>
                                                </div>
                                                <div class="text-theme-primary fw-bold" style="font-size: 1rem;">48 <span class="text-secondary" style="font-size: 0.65rem;">mins</span></div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Mock Progress Bar Card -->
                                    <div class="p-3 rounded-3 mock-mini-card mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="text-theme-primary fw-semibold" style="font-size: 0.8rem;">Weekly Calorie Goal</span>
                                            <span class="text-accent fw-bold" style="font-size: 0.8rem;" id="mockGoalPercent">82%</span>
                                        </div>
                                        <div class="progress-bar-container" style="height: 6px;">
                                            <div class="progress-bar-fill" style="width: 82%;"></div>
                                        </div>
                                    </div>

                                    <!-- Mock Action Button -->
                                    <div class="d-grid gap-2">
                                        <button type="button" class="btn-custom py-2" style="font-size: 0.85rem; font-weight: 600;">
                                            <i class="fa-solid fa-plus me-1"></i> Log Quick Workout
                                        </button>
                                    </div>

                                </div>

                                <!-- Current Settings Summary List -->
                                <div class="mt-4 pt-3 border-top" style="border-color: var(--border-color) !important;">
                                    <div class="stat-pill-row">
                                        <span class="stat-pill-label" style="font-size: 0.8rem;"><i class="fa-solid fa-sun text-accent"></i> Theme Mode</span>
                                        <span class="badge-custom badge-accent" id="summaryTheme" style="font-size: 0.75rem;">${preferences.themeMode != null ? preferences.themeMode : 'DARK'}</span>
                                    </div>
                                    <div class="stat-pill-row">
                                        <span class="stat-pill-label" style="font-size: 0.8rem;"><i class="fa-solid fa-droplet text-accent"></i> Accent</span>
                                        <span class="text-theme-primary fw-semibold" id="summaryAccent" style="font-size: 0.8rem;">${preferences.accentColor != null ? preferences.accentColor : 'LIME'}</span>
                                    </div>
                                    <div class="stat-pill-row">
                                        <span class="stat-pill-label" style="font-size: 0.8rem;"><i class="fa-solid fa-wand-magic-sparkles text-accent"></i> Glass Intensity</span>
                                        <span class="text-theme-primary fw-semibold" id="summaryGlass" style="font-size: 0.8rem;">${preferences.glassIntensity != null ? preferences.glassIntensity : 'MEDIUM'}</span>
                                    </div>
                                    <div class="stat-pill-row">
                                        <span class="stat-pill-label" style="font-size: 0.8rem;"><i class="fa-solid fa-film text-accent"></i> Animations</span>
                                        <span class="text-theme-primary fw-semibold" id="summaryAnimations" style="font-size: 0.8rem;">${preferences.animationsEnabled || preferences == null ? 'Enabled' : 'Disabled'}</span>
                                    </div>
                                    <div class="stat-pill-row">
                                        <span class="stat-pill-label" style="font-size: 0.8rem;"><i class="fa-solid fa-compress text-accent"></i> Compact Mode</span>
                                        <span class="text-theme-primary fw-semibold" id="summaryCompact" style="font-size: 0.8rem;">${preferences.compactMode ? 'Active' : 'Standard'}</span>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </form>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

<!-- Theme Customization Interactive JavaScript -->
<script>
    function selectThemeMode(mode) {
        document.getElementById('inputThemeMode').value = mode;
        
        // Update selection UI
        document.querySelectorAll('#themeModeOptions .theme-option-card').forEach(card => {
            if (card.dataset.value === mode) {
                card.classList.add('active');
            } else {
                card.classList.remove('active');
            }
        });

        // Apply immediately to HTML element for live preview
        document.documentElement.setAttribute('data-theme', mode.toLowerCase());
        
        // Update summary text
        document.getElementById('summaryTheme').textContent = mode;
        document.getElementById('mockThemeTag').textContent = mode;
        
        // Cache to localStorage for immediate hydration
        localStorage.setItem('fitflow_theme', mode.toLowerCase());
    }

    function selectAccentColor(color) {
        document.getElementById('inputAccentColor').value = color;

        // Update selection UI
        document.querySelectorAll('#accentOptions .accent-swatch-item').forEach(item => {
            if (item.dataset.value === color) {
                item.classList.add('active');
            } else {
                item.classList.remove('active');
            }
        });

        // Apply immediately to HTML element for live preview
        document.documentElement.setAttribute('data-accent', color.toLowerCase());

        // Update summary text
        document.getElementById('summaryAccent').textContent = color;
        
        // Cache to localStorage
        localStorage.setItem('fitflow_accent', color.toLowerCase());
    }

    function selectGlassIntensity(intensity) {
        document.getElementById('inputGlassIntensity').value = intensity;

        // Update selection UI
        document.querySelectorAll('#glassOptions .glass-tier-btn').forEach(btn => {
            if (btn.dataset.value === intensity) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        // Apply immediately to HTML element for live preview
        document.documentElement.setAttribute('data-glass', intensity.toLowerCase());

        // Update summary text
        document.getElementById('summaryGlass').textContent = intensity;

        // Cache to localStorage
        localStorage.setItem('fitflow_glass', intensity.toLowerCase());
    }

    function toggleAnimations(enabled) {
        document.documentElement.setAttribute('data-animations', enabled ? 'true' : 'false');
        document.getElementById('summaryAnimations').textContent = enabled ? 'Enabled' : 'Disabled';
        localStorage.setItem('fitflow_animations', enabled ? 'true' : 'false');
    }

    function toggleCompact(enabled) {
        document.documentElement.setAttribute('data-compact', enabled ? 'true' : 'false');
        document.getElementById('summaryCompact').textContent = enabled ? 'Active' : 'Standard';
        localStorage.setItem('fitflow_compact', enabled ? 'true' : 'false');
    }

    // Initialize state on page load
    document.addEventListener('DOMContentLoaded', () => {
        const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
        const currentAccent = document.documentElement.getAttribute('data-accent') || 'lime';
        const currentGlass = document.documentElement.getAttribute('data-glass') || 'medium';
        const currentCompact = document.documentElement.getAttribute('data-compact') || 'false';
        const currentAnimations = document.documentElement.getAttribute('data-animations') || 'true';

        localStorage.setItem('fitflow_theme', currentTheme);
        localStorage.setItem('fitflow_accent', currentAccent);
        localStorage.setItem('fitflow_glass', currentGlass);
        localStorage.setItem('fitflow_compact', currentCompact);
        localStorage.setItem('fitflow_animations', currentAnimations);
    });
</script>
