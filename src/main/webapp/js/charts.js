/**
 * FitFlow Pro - Chart.js Engine
 * Renders modern dark-themed visualizations using real database datasets.
 */

// Global Chart.js Defaults for Dark SaaS Look
if (typeof Chart !== 'undefined') {
    Chart.defaults.color = '#929792';
    Chart.defaults.font.family = "'Plus Jakarta Sans', sans-serif";
    Chart.defaults.font.size = 12;
    Chart.defaults.plugins.tooltip.backgroundColor = '#151817';
    Chart.defaults.plugins.tooltip.titleColor = '#FFFFFF';
    Chart.defaults.plugins.tooltip.bodyColor = '#C8FF45';
    Chart.defaults.plugins.tooltip.borderColor = '#252925';
    Chart.defaults.plugins.tooltip.borderWidth = 1;
    Chart.defaults.plugins.tooltip.padding = 10;
    Chart.defaults.plugins.tooltip.cornerRadius = 8;
}

let workoutActivityChartInstance = null;

/**
 * Initializes the Workout Activity Bar Chart with Weekly / Monthly switcher
 */
function initWorkoutActivityChart(weeklyData, monthlyData) {
    const ctx = document.getElementById('workoutActivityChart');
    if (!ctx) return;

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
                backgroundColor: '#C8FF45',
                borderRadius: 8,
                borderSkipped: false,
                barPercentage: 0.45,
                categoryPercentage: 0.8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                x: {
                    grid: { display: false, drawBorder: false },
                    ticks: { color: '#929792', font: { weight: '600' } }
                },
                y: {
                    grid: { color: 'rgba(37, 41, 37, 0.5)', drawBorder: false },
                    ticks: {
                        color: '#929792',
                        callback: function(value) { return value + 'm'; }
                    },
                    beginAtZero: true
                }
            }
        }
    };

    workoutActivityChartInstance = new Chart(ctx, chartConfig);

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
            workoutActivityChartInstance.update();
        });

        btnMonthly.addEventListener('click', () => {
            btnMonthly.classList.add('active', 'btn-accent');
            btnMonthly.classList.remove('btn-outline-custom');
            btnWeekly.classList.remove('active', 'btn-accent');
            btnWeekly.classList.add('btn-outline-custom');

            workoutActivityChartInstance.data.labels = monthlyLabels;
            workoutActivityChartInstance.data.datasets[0].data = monthlyValues;
            workoutActivityChartInstance.update();
        });
    }
}

/**
 * Initializes the Circular / Donut Fitness Overview Chart
 */
function initFitnessDonutChart(goalPct) {
    const ctx = document.getElementById('fitnessDonutChart');
    if (!ctx) return;

    const completed = Math.min(100, Math.max(0, goalPct || 0));
    const remaining = 100 - completed;

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            datasets: [{
                data: [completed, remaining],
                backgroundColor: ['#C8FF45', '#1e2321'],
                borderWidth: 0,
                hoverOffset: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '80%',
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
}

/**
 * Initializes Progress Analytics Calories & Intensity Line Chart
 */
function initProgressAnalyticsChart(weeklyCaloriesData) {
    const ctx = document.getElementById('progressAnalyticsChart');
    if (!ctx) return;

    const labels = Object.keys(weeklyCaloriesData || {});
    const values = Object.values(weeklyCaloriesData || {});

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Calories Burned (kcal)',
                data: values,
                borderColor: '#C8FF45',
                backgroundColor: 'rgba(200, 255, 69, 0.08)',
                fill: true,
                tension: 0.4,
                pointBackgroundColor: '#C8FF45',
                pointBorderColor: '#080909',
                pointBorderWidth: 2,
                pointRadius: 5,
                pointHoverRadius: 7
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { color: '#929792' }
                },
                y: {
                    grid: { color: 'rgba(37, 41, 37, 0.5)' },
                    ticks: {
                        color: '#929792',
                        callback: function(val) { return val + ' kcal'; }
                    },
                    beginAtZero: true
                }
            }
        }
    });
}

/**
 * Initializes Workout Type Distribution Pie / Polar Chart
 */
function initWorkoutTypeChart(typeMap) {
    const ctx = document.getElementById('workoutTypeChart');
    if (!ctx) return;

    const labels = Object.keys(typeMap || {});
    const values = Object.values(typeMap || {});

    const colors = ['#C8FF45', '#00D2FF', '#FFB800', '#FF5C5C', '#9D4EDD', '#06D6A0', '#F72585'];

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels.length > 0 ? labels : ['No Workouts Logged'],
            datasets: [{
                data: values.length > 0 ? values : [1],
                backgroundColor: values.length > 0 ? colors.slice(0, labels.length) : ['#252925'],
                borderWidth: 2,
                borderColor: '#151817'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { color: '#FFFFFF', padding: 12, boxWidth: 12 }
                }
            }
        }
    });
}

/**
 * Admin Registrations Monthly Bar Chart
 */
function initAdminRegistrationChart(registrationMap) {
    const ctx = document.getElementById('adminRegistrationChart');
    if (!ctx) return;

    const labels = Object.keys(registrationMap || {});
    const values = Object.values(registrationMap || {});

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'New Users',
                data: values,
                backgroundColor: '#00D2FF',
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false }, ticks: { color: '#929792' } },
                y: { grid: { color: 'rgba(37, 41, 37, 0.5)' }, ticks: { color: '#929792', precision: 0 }, beginAtZero: true }
            }
        }
    });
}
