<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Fitness Community & Articles - FitFlow Pro" scope="request"/>
<c:set var="activePage" value="content" scope="request"/>
<c:set var="greetingTitle" value="Fitness Community" scope="request"/>

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
                    <h3 class="mb-1 text-white fw-bold">Fitness Community & Training Guides</h3>
                    <p class="mb-0 text-secondary" style="font-size: 0.9rem;">
                        Explore evidence-based workout routines, nutritional strategies, recovery flows, and athletic motivation.
                    </p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn-accent" data-bs-toggle="modal" data-bs-target="#submitContentModal">
                        <i class="fa-solid fa-pen-nib"></i> Submit Article
                    </button>
                </div>
            </div>

            <!-- Search & Filters Toolbar -->
            <div class="fitness-card fitness-card-sm mb-4">
                <div class="row g-3 align-items-center">
                    <div class="col-lg-5 col-md-12">
                        <form action="${pageContext.request.contextPath}/user/content" method="GET" class="d-flex gap-2">
                            <c:if test="${not empty selectedCategory}">
                                <input type="hidden" name="category" value="${selectedCategory}">
                            </c:if>
                            <div class="search-input-wrapper w-100">
                                <i class="fa-solid fa-magnifying-glass"></i>
                                <input type="text" name="search" class="form-control-custom" 
                                       placeholder="Search articles, workouts, topics..." 
                                       value="${searchQuery}">
                            </div>
                            <button type="submit" class="btn btn-outline-custom px-3">Search</button>
                            <c:if test="${not empty searchQuery}">
                                <a href="${pageContext.request.contextPath}/user/content${not empty selectedCategory ? '?category='.concat(selectedCategory) : ''}" 
                                   class="btn btn-outline-custom px-2" title="Clear search">
                                    <i class="fa-solid fa-xmark"></i>
                                </a>
                            </c:if>
                        </form>
                    </div>
                    <div class="col-lg-7 col-md-12">
                        <!-- Category Filter Pills -->
                        <div class="d-flex flex-wrap gap-2 justify-content-lg-end">
                            <a href="${pageContext.request.contextPath}/user/content${not empty searchQuery ? '?search='.concat(searchQuery) : ''}" 
                               class="btn btn-sm ${empty selectedCategory || selectedCategory == 'ALL' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                                All Categories
                            </a>
                            <a href="${pageContext.request.contextPath}/user/content?category=Workout+Routines${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="btn btn-sm ${selectedCategory == 'Workout Routines' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                                <i class="fa-solid fa-dumbbell me-1"></i> Workout Routines
                            </a>
                            <a href="${pageContext.request.contextPath}/user/content?category=Nutrition+%26+Diet${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="btn btn-sm ${selectedCategory == 'Nutrition & Diet' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                                <i class="fa-solid fa-apple-whole me-1"></i> Nutrition & Diet
                            </a>
                            <a href="${pageContext.request.contextPath}/user/content?category=Cardio+%26+Endurance${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="btn btn-sm ${selectedCategory == 'Cardio & Endurance' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                                <i class="fa-solid fa-person-running me-1"></i> Cardio & Endurance
                            </a>
                            <a href="${pageContext.request.contextPath}/user/content?category=Recovery+%26+Wellness${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="btn btn-sm ${selectedCategory == 'Recovery & Wellness' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                                <i class="fa-solid fa-spa me-1"></i> Recovery & Wellness
                            </a>
                            <a href="${pageContext.request.contextPath}/user/content?category=Motivation${not empty searchQuery ? '&search='.concat(searchQuery) : ''}" 
                               class="btn btn-sm ${selectedCategory == 'Motivation' ? 'btn-accent' : 'btn-outline-custom'} rounded-pill px-3">
                                <i class="fa-solid fa-fire me-1"></i> Motivation
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Published Image-Rich Articles Grid -->
            <div class="row g-4 mb-5">
                <c:choose>
                    <c:when test="${not empty articles}">
                        <c:forEach var="art" items="${articles}">
                            <div class="col-lg-4 col-md-6 col-12">
                                <a href="${pageContext.request.contextPath}/user/content/view?id=${art.id}" class="content-card-link" role="article" tabindex="0">
                                    <div class="content-card-rich">
                                        <!-- Top Cover Image -->
                                        <div class="content-card-image-wrap">
                                            <img src="${pageContext.request.contextPath}/${art.imageUrl}" 
                                                 alt="${art.title}"
                                                 loading="lazy"
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/content/strength-training.webp';">
                                            <div class="content-card-image-overlay"></div>
                                        </div>

                                        <!-- Card Content -->
                                        <div class="content-card-body">
                                            <div>
                                                <!-- Category & Date Header -->
                                                <div class="content-card-meta">
                                                    <span class="badge-custom badge-accent">${art.category}</span>
                                                    <small class="text-muted"><fmt:formatDate value="${art.createdAt}" pattern="MMM d, yyyy"/></small>
                                                </div>

                                                <!-- Content Title -->
                                                <h5 class="content-card-title">${art.title}</h5>

                                                <!-- Short Description -->
                                                <p class="content-card-desc">${art.description}</p>
                                            </div>

                                            <!-- Author & Verified Status Footer -->
                                            <div class="content-card-footer">
                                                <div class="content-author-pill">
                                                    <div class="content-author-dot">
                                                        ${empty art.authorName ? 'A' : art.authorName.substring(0, 1)}
                                                    </div>
                                                    <small class="text-secondary fw-semibold">${empty art.authorName ? 'FitFlow Specialist' : art.authorName}</small>
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
                                <h4 class="text-white fw-bold">No articles match your criteria</h4>
                                <p class="text-secondary mb-3">Try adjusting your category filters or search keywords.</p>
                                <a href="${pageContext.request.contextPath}/user/content" class="btn btn-outline-custom">
                                    <i class="fa-solid fa-rotate-left me-1"></i> Reset Filters
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- User's Personal Submissions Section -->
            <c:if test="${not empty userSubmissions}">
                <div class="fitness-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="text-white fw-bold mb-0">
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
                                            <div class="text-white fw-bold">${sub.title}</div>
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
                <h5 class="modal-title text-white"><i class="fa-solid fa-pen-nib text-accent me-2"></i> Submit Fitness Article</h5>
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
                            <label class="form-label-custom">Cover Image</label>
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
                            <textarea name="description" class="form-control-custom" rows="2" placeholder="Brief 2-line summary to hook readers on the community cards..." required></textarea>
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Full Article Content (Markdown / Sections)</label>
                            <textarea name="contentBody" class="form-control-custom" rows="8" placeholder="Write your full guide here. Use ## for section headings and - for bullet points..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-custom">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-accent"><i class="fa-solid fa-paper-plane"></i> Submit for Review</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
