<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" 
      data-theme="${sessionScope.userPreferences != null ? sessionScope.userPreferences.themeModeLower : 'dark'}"
      data-accent="${sessionScope.userPreferences != null ? sessionScope.userPreferences.accentColorLower : 'lime'}"
      data-glass="${sessionScope.userPreferences != null ? sessionScope.userPreferences.glassIntensityLower : 'medium'}"
      data-compact="${sessionScope.userPreferences != null ? sessionScope.userPreferences.compactMode : 'false'}"
      data-animations="${sessionScope.userPreferences != null ? sessionScope.userPreferences.animationsEnabled : 'true'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>${pageTitle != null ? pageTitle : "FitFlow Pro - Online Fitness Tracking & Progress Management"}</title>
    
    <!-- Anti-FOUC Theme Script (Instant Local & System Theme Hydration) -->
    <script>
        (function() {
            try {
                const localTheme = localStorage.getItem('fitflow_theme');
                const localAccent = localStorage.getItem('fitflow_accent');
                const localGlass = localStorage.getItem('fitflow_glass');
                const localCompact = localStorage.getItem('fitflow_compact');
                const localAnimations = localStorage.getItem('fitflow_animations');

                const root = document.documentElement;
                if (localTheme) root.setAttribute('data-theme', localTheme);
                if (localAccent) root.setAttribute('data-accent', localAccent);
                if (localGlass) root.setAttribute('data-glass', localGlass);
                if (localCompact !== null) root.setAttribute('data-compact', localCompact);
                if (localAnimations !== null) root.setAttribute('data-animations', localAnimations);
            } catch(e) {}
        })();
    </script>

    <!-- Google Fonts: Plus Jakarta Sans -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome 6 Pro / Free Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Custom Application CSS (Aurora Glass Theme - Cache Busted) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=aurora_6.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css?v=aurora_6.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css?v=aurora_6.0">
</head>
<body>
