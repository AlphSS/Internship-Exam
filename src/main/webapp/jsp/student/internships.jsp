<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="com.admin.model.Student" %>

<%
// Session check
Student student = (Student) session.getAttribute("student");

if (student == null) {
    response.sendRedirect(request.getContextPath() + "/student/login");
    return;
}

// Make available for EL
request.setAttribute("student", student);

String initial = (student.getFullName() != null && !student.getFullName().isEmpty())
        ? student.getFullName().substring(0,1).toUpperCase()
        : "S";

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Internships — InternAdmin Student</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/student-style.css">
</head>
<body>

<!-- ── Top Nav ── -->
<nav class="topnav">
    <div class="nav-brand">
        <div class="nav-brand-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                <path d="M6 12v5c3 3 9 3 12 0v-5"/>
            </svg>
        </div>
        InternAdmin
    </div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/student/internships" class="nav-link active">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
            Internships
        </a>
        <a href="${pageContext.request.contextPath}/student/applications" class="nav-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            My Applications
        </a>
        <a href="${pageContext.request.contextPath}/student/startExam" class="nav-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
            My Exam
        </a>
    </div>
    <div class="nav-right">
        <div class="student-chip">
            <div class="student-avatar"><%= initial %></div>
            ${student.fullName}
        </div>
        <a href="${pageContext.request.contextPath}/student/logout" class="btn btn-ghost btn-sm">Logout</a>
    </div>
</nav>

<div class="page page-lg">

    <!-- Flash messages -->
    <c:if test="${msg == 'applied'}">
        <div class="alert alert-success">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
            Application submitted successfully! Check My Applications for status updates.
        </div>
    </c:if>
    <c:if test="${msg == 'alreadyApplied'}">
        <div class="alert alert-warning">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
            You have already applied for this internship.
        </div>
    </c:if>
    <c:if test="${msg == 'internshipClosed'}">
        <div class="alert alert-error">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            This internship is no longer accepting applications.
        </div>
    </c:if>
    <c:if test="${msg == 'cgpaNotMet'}">
        <div class="alert alert-error">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            Your CGPA does not meet the minimum requirement for this internship.
        </div>
    </c:if>
    <c:if test="${msg == 'applyError'}">
        <div class="alert alert-error">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            An error occurred while submitting your application. Please try again.
        </div>
    </c:if>

    <!-- Page header -->
    <div class="page-header">
        <div>
            <h1>Browse Internships</h1>
            <p>Your CGPA: <strong>${studentCgpa}</strong> — showing internships you are eligible for</p>
        </div>
    </div>

    <!-- Filter bar -->
    <div class="filter-bar">
        <div class="search-box">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input type="text" id="searchInput" placeholder="Search by title, company, location..."
                   oninput="filterCards()">
        </div>

        <!-- Toggle: eligible only vs all -->
        <a href="${pageContext.request.contextPath}/student/internships?filter=eligible"
           class="toggle-btn ${filter == 'eligible' ? 'active' : ''}">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
            Eligible for Me
        </a>
        <a href="${pageContext.request.contextPath}/student/internships?filter=all"
           class="toggle-btn ${filter == 'all' ? 'active' : ''}">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
            All Open
        </a>

        <span style="font-size:13px; color:var(--slate-400); margin-left:auto;">
            ${fn:length(internships)} internship${fn:length(internships) != 1 ? 's' : ''} found
        </span>
    </div>

    <!-- Internship grid -->
    <c:choose>
        <c:when test="${empty internships}">
            <div class="empty-state">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="2" y="7" width="20" height="14" rx="2"/>
                    <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                </svg>
                <h3>No internships available</h3>
                <p>
                    <c:choose>
                        <c:when test="${filter == 'eligible'}">
                            No open internships match your CGPA of ${studentCgpa}.
                            <a href="${pageContext.request.contextPath}/student/internships?filter=all"
                               style="color:var(--blue);font-weight:600;">View all open internships</a>
                        </c:when>
                        <c:otherwise>No open internships are available right now. Check back later.</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="internship-grid" id="internshipGrid">
                <c:forEach var="i" items="${internships}">
                    <div class="internship-card ${i.status == 'applied' ? 'applied' : ''} ${studentCgpa < i.minCgpa ? 'ineligible' : ''}"
                         data-search="${i.title} ${i.companyName} ${i.description}">

                        <div class="card-top">
                            <div>
                                <div class="card-company">${i.companyName}</div>
                                <div class="card-title">${i.title}</div>
                            </div>
                            <c:if test="${i.status == 'applied'}">
                                <div class="applied-badge">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                                    Applied
                                </div>
                            </c:if>
                        </div>

                        <!-- Tags -->
                        <div class="card-tags">
                            <span class="tag green">
                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                                Rs.${i.stipend}/mo
                            </span>
                            <span class="tag blue">
                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                ${i.durationMonths} months
                            </span>
                            <span class="tag">
                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                ${i.companyName}
                            </span>
                            <span class="tag amber">
                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                                ${i.vacancies} seats
                            </span>
                        </div>

                        <!-- Description -->
                        <c:if test="${not empty i.description}">
                            <div class="card-desc">
                                ${fn:length(i.description) > 120 ? fn:substring(i.description, 0, 120).concat('...') : i.description}
                            </div>
                        </c:if>

                        <!-- Footer: CGPA + Apply button -->
                        <div class="card-meta">
                            <div class="cgpa-badge">
                                Min CGPA: <strong>${i.minCgpa}</strong>
                                <c:if test="${studentCgpa >= i.minCgpa}">
                                    <span style="color:var(--green);margin-left:4px;">✓ Eligible</span>
                                </c:if>
                                <c:if test="${studentCgpa < i.minCgpa}">
                                    <span style="color:var(--red);margin-left:4px;">✗ Ineligible</span>
                                </c:if>
                            </div>

                            <c:choose>
                                <c:when test="${i.status == 'applied'}">
                                    <div class="applied-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                                        Applied
                                    </div>
                                </c:when>
                                <c:when test="${studentCgpa < i.minCgpa}">
                                    <div class="ineligible-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                        Ineligible
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/student/apply"
                                          method="post"
                                          onsubmit="return confirm('Apply for ${i.title} at ${i.companyName}?');">
                                        <input type="hidden" name="internshipId" value="${i.internshipId}">
                                        <button type="submit" class="btn btn-primary btn-sm">
                                            Apply Now
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Dates if available -->
                        <c:if test="${not empty i.startDate}">
                            <div style="font-size:11.5px; color:var(--slate-400); margin-top:-4px;">
                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                ${i.startDate} to ${not empty i.endDate ? i.endDate : 'TBD'}
                            </div>
                        </c:if>

                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<script>
function filterCards() {
    const q = document.getElementById('searchInput').value.toLowerCase();
    document.querySelectorAll('.internship-card').forEach(card => {
        const text = (card.dataset.search || '').toLowerCase();
        card.style.display = text.includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
