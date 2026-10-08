/**
 * FitFlow Pro - Aurora Glass Dashboard & UI Controller
 * Handles glassmorphism micro-interactions, counters, and scroll reveals.
 */
document.addEventListener('DOMContentLoaded', () => {
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    // 1. Sidebar Edge Reveal & Drawer Controller
    const sidebar = document.querySelector('.app-sidebar');
    const overlay = document.querySelector('.sidebar-overlay');
    const edgeTrigger = document.getElementById('sidebarEdgeTrigger');
    const mobileToggle = document.getElementById('mobileNavToggle');
    const appWrapper = document.querySelector('.app-wrapper') || document.body;

    if (sidebar) {
        let hideTimer = null;
        let isManuallyOpened = false; // true if opened explicitly via click button
        const HIDE_DELAY_MS = 380;
        const TRIGGER_ZONE_WIDTH = 20; // px from viewport left edge

        function openSidebar(manual = false) {
            if (hideTimer) {
                clearTimeout(hideTimer);
                hideTimer = null;
            }
            if (manual) {
                isManuallyOpened = true;
                if (overlay) overlay.classList.add('show');
            }
            appWrapper.classList.add('sidebar-open');
            appWrapper.classList.remove('sidebar-closed');
            sidebar.classList.add('sidebar-visible', 'show');
        }

        function closeSidebar(immediate = false) {
            if (hideTimer) {
                clearTimeout(hideTimer);
                hideTimer = null;
            }
            const doClose = () => {
                appWrapper.classList.remove('sidebar-open');
                appWrapper.classList.add('sidebar-closed');
                sidebar.classList.remove('sidebar-visible', 'show');
                if (overlay) overlay.classList.remove('show');
                isManuallyOpened = false;
            };

            if (immediate) {
                doClose();
            } else {
                hideTimer = setTimeout(doClose, HIDE_DELAY_MS);
            }
        }

        if (edgeTrigger) {
            edgeTrigger.addEventListener('mouseenter', () => openSidebar(false));
            edgeTrigger.addEventListener('mouseleave', (e) => {
                if (e.clientX > TRIGGER_ZONE_WIDTH && !isManuallyOpened) {
                    closeSidebar(false);
                }
            });
        }

        // Global mouse movement tracker: detects entering left edge and leaving sidebar area
        document.addEventListener('mousemove', (e) => {
            const sidebarWidth = sidebar.offsetWidth || 270;
            const isInsideSidebar = e.clientX <= sidebarWidth;
            const isNearLeftEdge = e.clientX <= TRIGGER_ZONE_WIDTH;

            if (isNearLeftEdge) {
                openSidebar(false);
            } else if (isInsideSidebar && (sidebar.classList.contains('sidebar-visible') || sidebar.classList.contains('show'))) {
                if (hideTimer) {
                    clearTimeout(hideTimer);
                    hideTimer = null;
                }
            } else if (!isInsideSidebar && (sidebar.classList.contains('sidebar-visible') || sidebar.classList.contains('show'))) {
                if (!isManuallyOpened && !hideTimer) {
                    closeSidebar(false);
                }
            }
        });

        // Sidebar container mouse events
        sidebar.addEventListener('mouseenter', () => {
            if (hideTimer) {
                clearTimeout(hideTimer);
                hideTimer = null;
            }
        });

        sidebar.addEventListener('mouseleave', () => {
            if (!isManuallyOpened) {
                closeSidebar(false);
            }
        });

        // Clicking outside the open sidebar immediately closes it
        document.addEventListener('click', (e) => {
            if (sidebar.classList.contains('sidebar-visible') || sidebar.classList.contains('show')) {
                if (!sidebar.contains(e.target) && !mobileToggle?.contains(e.target) && !edgeTrigger?.contains(e.target)) {
                    closeSidebar(true);
                }
            }
        });

        // Click / Touch Toggle Button
        if (mobileToggle) {
            mobileToggle.addEventListener('click', (e) => {
                e.stopPropagation();
                const isOpen = sidebar.classList.contains('show') || sidebar.classList.contains('sidebar-visible');
                if (isOpen) {
                    closeSidebar(true);
                } else {
                    openSidebar(true);
                }
            });
        }

        if (overlay) {
            overlay.addEventListener('click', () => closeSidebar(true));
        }

        // Close on Escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                closeSidebar(true);
            }
        });
    }

    // 2. Auto Dismiss Flash Alerts with Smooth Fade-Out
    const alerts = document.querySelectorAll('.alert-custom');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.4s cubic-bezier(0.16, 1, 0.3, 1), transform 0.4s cubic-bezier(0.16, 1, 0.3, 1)';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-8px)';
            setTimeout(() => alert.remove(), 400);
        }, 5000);
    });

    // 3. Number Counter & Progress Bar Animations
    if (!prefersReducedMotion) {
        animateNumericalCounters();
        animateProgressBars();
        initScrollReveals();
    }

    // 4. Initialize Bootstrap Tooltips if present
    if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
    }
});

/**
 * Animates numerical metric elements from 0 to their target value
 */
function animateNumericalCounters() {
    const counterElements = document.querySelectorAll('.counter-value, .donut-pct-large, .stat-pill-value');
    
    counterElements.forEach(el => {
        const originalText = el.innerText.trim();
        const match = originalText.match(/^([^\d]*)(\d[\d,]*(?:\.\d+)?)(.*)$/);
        
        if (match) {
            const prefix = match[1] || '';
            const rawNumberStr = match[2].replace(/,/g, '');
            const suffix = match[3] || '';
            const targetVal = parseFloat(rawNumberStr);
            const isFloat = rawNumberStr.includes('.');
            const hasComma = match[2].includes(',');
            
            if (!isNaN(targetVal) && targetVal > 0) {
                const duration = 850;
                const startTime = performance.now();
                
                function updateCounter(currentTime) {
                    const elapsed = currentTime - startTime;
                    const progress = Math.min(elapsed / duration, 1);
                    const easeOut = 1 - Math.pow(1 - progress, 3);
                    const currentVal = targetVal * easeOut;
                    
                    let formattedNum;
                    if (isFloat) {
                        formattedNum = currentVal.toFixed(2);
                    } else {
                        formattedNum = Math.round(currentVal).toString();
                        if (hasComma) {
                            formattedNum = formattedNum.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                        }
                    }
                    
                    el.innerText = prefix + formattedNum + suffix;
                    
                    if (progress < 1) {
                        requestAnimationFrame(updateCounter);
                    } else {
                        el.innerText = originalText;
                    }
                }
                
                requestAnimationFrame(updateCounter);
            }
        }
    });
}

/**
 * Smoothly animates progress bars on initial page load
 */
function animateProgressBars() {
    const progressBars = document.querySelectorAll('.progress-bar-custom, .progress-animate');
    progressBars.forEach(bar => {
        const targetWidth = bar.style.width || (bar.getAttribute('aria-valuenow') ? bar.getAttribute('aria-valuenow') + '%' : '');
        if (targetWidth && targetWidth !== '0%') {
            bar.style.width = '0%';
            requestAnimationFrame(() => {
                setTimeout(() => {
                    bar.style.width = targetWidth;
                }, 100);
            });
        }
    });
}

/**
 * Single-pass Scroll Reveal for elements entering viewport
 */
function initScrollReveals() {
    if ('IntersectionObserver' in window) {
        const observer = new IntersectionObserver((entries, obs) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('is-revealed');
                    obs.unobserve(entry.target);
                }
            });
        }, {
            rootMargin: '0px 0px -40px 0px',
            threshold: 0.1
        });

        document.querySelectorAll('.reveal-on-scroll').forEach(el => {
            observer.observe(el);
        });
    }
}
