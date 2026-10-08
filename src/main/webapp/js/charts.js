/**
 * FitFlow Pro - Dynamic Theme-Aware Chart.js Engine
 * Derives colors, grid lines, tooltips, and fonts dynamically from CSS variables.
 */

// Helper to extract computed CSS theme variables
function getThemeColors() {
    const styles = getComputedStyle(document.documentElement);
    const isLight = document.documentElement.getAttribute('data-theme') === 'light' ||
                    (document.documentElement.getAttribute('data-theme') === 'system' && window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches);

    return {
        textPrimary: styles.getPropertyValue('--text-primary').trim() || (isLight ? '#101512' : '#F5F7F6'),
        textSecondary: styles.getPropertyValue('--text-secondary').trim() || (isLight ? '#4F5B54' : '#A4ADA7'),
        textMuted: styles.getPropertyValue('--text-muted').trim() || (isLight ? '#707B74' : '#737D77'),
        textOnAccent: styles.getPropertyValue('--text-on-accent').trim() || '#050709',
        accentPrimary: styles.getPropertyValue('--accent-primary').trim() || '#C8FF45',
        accentSecondary: styles.getPropertyValue('--accent-secondary').trim() || '#42F5C5',
        accentGlow: styles.getPropertyValue('--accent-glow').trim() || 'rgba(200, 255, 69, 0.18)',
        borderColor: styles.getPropertyValue('--border-color').trim() || (isLight ? 'rgba(15, 25, 20, 0.10)' : 'rgba(255, 255, 255, 0.10)'),
        surfaceSecondary: styles.getPropertyValue('--surface-secondary').trim() || (isLight ? 'rgba(0, 0, 0, 0.04)' : 'rgba(255, 255, 255, 0.04)'),
        gridColor: isLight ? 'rgba(15, 25, 20, 0.08)' : 'rgba(255, 255, 255, 0.06)',
        tooltipBg: isLight ? 'rgba(255, 255, 255, 0.95)' : 'rgba(8, 12, 11, 0.94)',
        tooltipTitle: styles.getPropertyValue('--text-primary').trim() || (isLight ? '#101512' : '#F5F7F6'),
        tooltipBody: styles.getPropertyValue('--accent-primary').trim() || '#C8FF45',
        tooltipBorder: styles.getPropertyValue('--border-color').trim() || (isLight ? 'rgba(15, 25, 20, 0.15)' : 'rgba(255, 255, 255, 0.15)'),
        isLight: isLight
    };
}

// Apply global Chart.js defaults
function applyChartDefaults() {
    if (typeof Chart === 'undefined') return;
    const tc = getThemeColors();
    Chart.defaults.color = tc.textSecondary;
    Chart.defaults.font.family = "'Plus Jakarta Sans', sans-serif";
    Chart.defaults.font.size = 12;
    Chart.defaults.plugins.tooltip.backgroundColor = tc.tooltipBg;
    Chart.defaults.plugins.tooltip.titleColor = tc.tooltipTitle;
    Chart.defaults.plugins.tooltip.bodyColor = tc.tooltipBody;
    Chart.defaults.plugins.tooltip.borderColor = tc.tooltipBorder;
    Chart.defaults.plugins.tooltip.borderWidth = 1;
    Chart.defaults.plugins.tooltip.padding = 12;
    Chart.defaults.plugins.tooltip.cornerRadius = 10;
    Chart.defaults.plugins.tooltip.boxPadding = 6;
    Chart.defaults.animation = {
        duration: 850,
        easing: 'easeOutQuart'
    };
}

// Initialize defaults immediately
applyChartDefaults();

// Registry of active charts for dynamic re-theming
const activeChartInstances = [];

let workoutActivityChartInstance = null;

/**
 * Initializes the Workout Activity Bar Chart with Weekly / Monthly switcher
 */
function initWorkoutActivityChart(weeklyData, monthlyData) {
    const ctx = document.getElementById('workoutActivityChart');
    if (!ctx) return;

    const tc = getThemeColors();
    const weeklyLabels = Object.keys(weeklyData || {});
    const weeklyValues = Object.values(weeklyData || {});
    const monthlyLabels = Object.keys(monthlyData || {});
    const monthlyValues = Object.values(monthlyData || {});

    const chartConfig = {
        type: 'bar',
        data: {
            labels: weeklyLabels.length > 0 ? weeklyLabels : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Duration (Minutes)',
                data: weeklyValues.length > 0 ? weeklyValues : [0, 0, 0, 0, 0, 0, 0],
                backgroundColor: tc.accentPrimary,
                hoverBackgroundColor: tc.accentSecondary,
                borderRadius: 8,
                borderSkipped: false,
                barPercentage: 0.45,
                categoryPercentage: 0.8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            animation: {
                duration: 900,
                easing: 'easeOutQuart'
            },
            plugins: {
                legend: { display: false }
            },
            scales: {
                x: {
                    grid: { display: false, drawBorder: false },
                    ticks: { color: tc.textSecondary, font: { weight: '600' } }
                },
                y: {
                    grid: { color: tc.gridColor, drawBorder: false },
                    ticks: {
                        color: tc.textSecondary,
                        callback: function(value) { return value + 'm'; }
                    },
                    beginAtZero: true
                }
            }
        }
    };

    workoutActivityChartInstance = new Chart(ctx, chartConfig);
    activeChartInstances.push(workoutActivityChartInstance);

    // Switch buttons handler
    const btnWeekly = document.getElementById('btnChartWeekly');
    const btnMonthly = document.getElementById('btnChartMonthly');

    if (btnWeekly && btnMonthly) {
        btnWeekly.addEventListener('click', () => {
            btnWeekly.classList.add('active', 'btn-accent');
            btnWeekly.classList.remove('btn-outline-custom');
            btnMonthly.classList.remove('active', 'btn-accent');
            btnMonthly.classList.add('btn-outline-custom');

            workoutActivityChartInstance.data.labels = weeklyLabels;
            workoutActivityChartInstance.data.datasets[0].data = weeklyValues;
            workoutActivityChartInstance.update({
                duration: 750,
                easing: 'easeOutQuart'
            });
        });

        btnMonthly.addEventListener('click', () => {
            btnMonthly.classList.add('active', 'btn-accent');
            btnMonthly.classList.remove('btn-outline-custom');
            btnWeekly.classList.remove('active', 'btn-accent');
            btnWeekly.classList.add('btn-outline-custom');

            workoutActivityChartInstance.data.labels = monthlyLabels;
            workoutActivityChartInstance.data.datasets[0].data = monthlyValues;
            workoutActivityChartInstance.update({
                duration: 750,
                easing: 'easeOutQuart'
            });
        });
    }
}

/**
 * Initializes the Circular / Donut Fitness Overview Chart
 */
function initFitnessDonutChart(goalPct) {
    const ctx = document.getElementById('fitnessDonutChart');
    if (!ctx) return;

    const tc = getThemeColors();
    const completed = Math.min(100, Math.max(0, goalPct || 0));
    const remaining = 100 - completed;

    const donutChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            datasets: [{
                data: [completed, remaining],
                backgroundColor: [tc.accentPrimary, tc.surfaceSecondary],
                borderWidth: 0,
                hoverOffset: 3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '80%',
            animation: {
                animateRotate: true,
                duration: 1000,
                easing: 'easeOutQuart'
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return (context.dataIndex === 0 ? 'Completed: ' : 'Remaining: ') + context.raw + '%';
                        }
                    }
                }
            }
        }
    });
    activeChartInstances.push(donutChart);
}

/**
 * Initializes Progress Analytics Calories & Intensity Line Chart
 */
function initProgressAnalyticsChart(weeklyCaloriesData) {
    const ctx = document.getElementById('progressAnalyticsChart');
    if (!ctx) return;

    const tc = getThemeColors();
    const labels = Object.keys(weeklyCaloriesData || {});
    const values = Object.values(weeklyCaloriesData || {});

    const progressChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Calories Burned (kcal)',
                data: values,
                borderColor: tc.accentPrimary,
                backgroundColor: tc.accentGlow,
                fill: true,
                tension: 0.4,
                borderWidth: 3,
                pointBackgroundColor: tc.accentPrimary,
                pointBorderColor: tc.isLight ? '#FFFFFF' : '#050709',
                pointBorderWidth: 2,
                pointRadius: 5,
                pointHoverRadius: 7
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            animation: {
                duration: 950,
                easing: 'easeOutQuart'
            },
            plugins: {
                legend: { display: false }
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { color: tc.textSecondary }
                },
                y: {
                    grid: { color: tc.gridColor },
                    ticks: {
                        color: tc.textSecondary,
                        callback: function(val) { return val + ' kcal'; }
                    },
                    beginAtZero: true
                }
            }
        }
    });
    activeChartInstances.push(progressChart);
}

/**
 * Initializes Workout Type Distribution Pie / Donut Chart
 */
function initWorkoutTypeChart(typeMap) {
    const ctx = document.getElementById('workoutTypeChart');
    if (!ctx) return;

    const tc = getThemeColors();
    const labels = Object.keys(typeMap || {});
    const values = Object.values(typeMap || {});

    const colors = [tc.accentPrimary, tc.accentSecondary, '#45D9FF', '#FFB800', '#FF5C5C', '#A78BFA', '#06D6A0'];

    const typeChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels.length > 0 ? labels : ['No Workouts Logged'],
            datasets: [{
                data: values.length > 0 ? values : [1],
                backgroundColor: values.length > 0 ? colors.slice(0, labels.length) : [tc.surfaceSecondary],
                borderWidth: 2,
                borderColor: tc.isLight ? 'rgba(255, 255, 255, 0.8)' : 'rgba(8, 12, 11, 0.9)'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%',
            animation: {
                animateRotate: true,
                duration: 900,
                easing: 'easeOutQuart'
            },
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { color: tc.textPrimary, padding: 14, boxWidth: 12 }
                }
            }
        }
    });
    activeChartInstances.push(typeChart);
}

/**
 * Admin Registrations Monthly Bar Chart
 */
function initAdminRegistrationChart(registrationMap) {
    const ctx = document.getElementById('adminRegistrationChart');
    if (!ctx) return;

    const tc = getThemeColors();
    const labels = Object.keys(registrationMap || {});
    const values = Object.values(registrationMap || {});

    const adminChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'New Users',
                data: values,
                backgroundColor: tc.accentSecondary,
                hoverBackgroundColor: tc.accentPrimary,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            animation: {
                duration: 850,
                easing: 'easeOutQuart'
            },
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false }, ticks: { color: tc.textSecondary } },
                y: { grid: { color: tc.gridColor }, ticks: { color: tc.textSecondary, precision: 0 }, beginAtZero: true }
            }
        }
    });
    activeChartInstances.push(adminChart);
}

// Listen for Theme Attribute Changes and Update Charts Live
if (typeof MutationObserver !== 'undefined') {
    const themeObserver = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.type === 'attributes' && (mutation.attributeName === 'data-theme' || mutation.attributeName === 'data-accent')) {
                applyChartDefaults();
                const tc = getThemeColors();
                activeChartInstances.forEach((chart) => {
                    if (chart && chart.options) {
                        if (chart.options.scales && chart.options.scales.x) {
                            if (chart.options.scales.x.ticks) chart.options.scales.x.ticks.color = tc.textSecondary;
                        }
                        if (chart.options.scales && chart.options.scales.y) {
                            if (chart.options.scales.y.ticks) chart.options.scales.y.ticks.color = tc.textSecondary;
                            if (chart.options.scales.y.grid) chart.options.scales.y.grid.color = tc.gridColor;
                        }
                        if (chart.options.plugins && chart.options.plugins.legend && chart.options.plugins.legend.labels) {
                            chart.options.plugins.legend.labels.color = tc.textPrimary;
                        }
                        chart.update();
                    }
                });
            }
        });
    });

    themeObserver.observe(document.documentElement, {
        attributes: true,
        attributeFilter: ['data-theme', 'data-accent', 'data-glass']
    });
}
