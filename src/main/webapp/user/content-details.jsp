<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="${content.title} - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="content" scope="request"/>
<c:set var="greetingTitle" value="Article Details" scope="request"/>

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
                        <a href="${pageContext.request.contextPath}/user/content" class="text-secondary">
                            <i class="fa-solid fa-arrow-left me-1"></i> Fitness Community
                        </a>
                    </li>
                    <li class="breadcrumb-item text-muted" aria-current="page">${content.category}</li>
                </ol>
            </nav>

            <article class="content-article-container">
                <!-- Large Hero Image -->
                <div class="content-hero-wrapper">
                    <img src="${pageContext.request.contextPath}/${content.imageUrl}" 
                         alt="${content.title}" 
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/strength-training.webp';">
                    <div class="content-hero-gradient"></div>
                </div>

                <!-- Article Header & Meta -->
                <div class="mb-4">
                    <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
                        <span class="badge-custom badge-accent fs-6 px-3 py-1">
                            ${content.category}
                        </span>
                        <span class="text-secondary small">
                            <i class="fa-regular fa-clock me-1 text-muted"></i> 4 min read
                        </span>
                        <span class="text-secondary small">
                            <i class="fa-regular fa-calendar me-1 text-muted"></i> 
                            <fmt:formatDate value="${content.createdAt}" pattern="MMMM d, yyyy"/>
                        </span>
                    </div>

                    <h1 class="display-6 fw-bold text-white mb-3" style="letter-spacing: -0.02em; line-height: 1.25;">
                        ${content.title}
                    </h1>

                    <!-- Author Bar -->
                    <div class="fitness-card fitness-card-sm d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
                        <div class="d-flex align-items-center gap-3">
                            <div class="avatar-circle" style="width: 44px; height: 44px; font-size: 1.1rem;">
                                ${empty content.authorName ? 'A' : content.authorName.substring(0, 1)}
                            </div>
                            <div>
                                <div class="text-white fw-bold d-flex align-items-center gap-2">
                                    <span>${empty content.authorName ? 'FitFlow Specialist' : content.authorName}</span>
                                    <span class="badge-custom badge-completed" style="font-size: 0.7rem;">
                                        <i class="fa-solid fa-circle-check text-accent"></i> Verified
                                    </span>
                                </div>
                                <small class="text-muted">${empty content.authorEmail ? 'Community Contributor' : content.authorEmail}</small>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-2">
                            <button type="button" class="btn-outline-custom btn-sm" onclick="navigator.clipboard.writeText(window.location.href); alert('Article link copied to clipboard!');">
                                <i class="fa-solid fa-share-nodes"></i> Share
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Short Summary Box -->
                <div class="article-takeaway-box mb-4">
                    <div class="d-flex align-items-center gap-2 mb-2 text-accent fw-bold" style="font-size: 0.9rem;">
                        <i class="fa-solid fa-bolt"></i> Key Overview
                    </div>
                    <p class="mb-0 text-white" style="font-size: 1.05rem; line-height: 1.6;">
                        ${content.description}
                    </p>
                </div>

                <!-- Full Article Body -->
                <div class="article-content-body fitness-card p-4 p-md-5 mb-5">
                    <c:choose>
                        <c:when test="${not empty content.contentBody}">
                            <%-- Render paragraphs cleanly by splitting double newlines or using paragraph blocks --%>
                            <c:forEach var="paragraph" items="${fn:split(content.contentBody, '
')}">
                                <c:if test="${not empty fn:trim(paragraph)}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(fn:trim(paragraph), '## ')}">
                                            <h3 class="text-white fw-bold mt-4 mb-3">${fn:substring(fn:trim(paragraph), 3, -1)}</h3>
                                        </c:when>
                                        <c:when test="${fn:startsWith(fn:trim(paragraph), '# ')}">
                                            <h2 class="text-white fw-bold mt-4 mb-3">${fn:substring(fn:trim(paragraph), 2, -1)}</h2>
                                        </c:when>
                                        <c:when test="${fn:startsWith(fn:trim(paragraph), '- ') || fn:startsWith(fn:trim(paragraph), '* ')}">
                                            <div class="d-flex align-items-start gap-2 mb-2 text-light">
                                                <i class="fa-solid fa-circle-check text-accent mt-1" style="font-size: 0.85rem;"></i>
                                                <span>${fn:substring(fn:trim(paragraph), 2, -1)}</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p>${fn:trim(paragraph)}</p>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p>${content.description}</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Bottom Navigation / Actions -->
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 pt-3 pb-5 border-bottom mb-5" style="border-color: var(--border-color) !important;">
                    <a href="${pageContext.request.contextPath}/user/content" class="btn btn-outline-custom">
                        <i class="fa-solid fa-arrow-left me-2"></i> Back to Fitness Community
                    </a>
                    <a href="#top" class="btn btn-outline-custom btn-sm">
                        <i class="fa-solid fa-arrow-up me-1"></i> Back to Top
                    </a>
                </div>

                <!-- Related Content Section -->
                <c:if test="${not empty relatedArticles}">
                    <div class="mb-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h4 class="text-white fw-bold mb-1">Related Articles in ${content.category}</h4>
                                <p class="text-secondary mb-0 small">Keep learning with more community-approved routines and nutrition guides.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/user/content?category=${content.category}" class="text-accent small fw-bold">
                                View all <i class="fa-solid fa-arrow-right ms-1"></i>
                            </a>
                        </div>

                        <div class="row g-4">
                            <c:forEach var="rel" items="${relatedArticles}">
                                <div class="col-lg-4 col-md-6">
                                    <a href="${pageContext.request.contextPath}/user/content/view?id=${rel.id}" class="content-card-link" role="article" tabindex="0">
                                        <div class="content-card-rich">
                                            <div class="content-card-image-wrap">
                                                <img src="${pageContext.request.contextPath}/${rel.imageUrl}" 
                                                     alt="${rel.title}"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/strength-training.webp';">
                                                <div class="content-card-image-overlay"></div>
                                            </div>

                                            <div class="content-card-body">
                                                <div>
                                                    <div class="content-card-meta">
                                                        <span class="badge-custom badge-accent">${rel.category}</span>
                                                        <small class="text-muted"><fmt:formatDate value="${rel.createdAt}" pattern="MMM d, yyyy"/></small>
                                                    </div>
                                                    <h5 class="content-card-title">${rel.title}</h5>
                                                    <p class="content-card-desc">${rel.description}</p>
                                                </div>

                                                <div class="content-card-footer">
                                                    <div class="content-author-pill">
                                                        <div class="content-author-dot">
                                                            ${empty rel.authorName ? 'A' : rel.authorName.substring(0, 1)}
                                                        </div>
                                                        <small class="text-secondary">${empty rel.authorName ? 'Community' : rel.authorName}</small>
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
                        </div>
                    </div>
                </c:if>

            </article>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
