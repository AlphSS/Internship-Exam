<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@ page import="com.admin.model.Student" %>

<%
// Get student from session
Student student = (Student) session.getAttribute("student");

// If not logged in → redirect
if (student == null) {
    response.sendRedirect(request.getContextPath() + "/student/login");
    return;
}

// Make available to JSTL (EL)
request.setAttribute("student", student);

// Avatar initial
String initial = (student.getFullName() != null && !student.getFullName().isEmpty())
        ? student.getFullName().substring(0,1).toUpperCase()
        : "S";

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — InternAdmin Student</title>
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
        <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link active">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/student/internships" class="nav-link">
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

<div class="page">

    <!-- Flash message -->
    <c:if test="${msg == 'registered'}">
        <div class="alert alert-success">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
            Welcome! Your account has been created successfully. Start browsing internships below.
        </div>
    </c:if>

    <!-- Page header -->
    <div class="page-header">
        <div>
            <h1>Hello, ${student.fullName} 👋</h1>
            <p>Here's your internship activity at a glance</p>
        </div>
        <a href="${pageContext.request.contextPath}/student/internships" class="btn btn-primary">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
            Browse Internships
        </a>
    </div>

    <!-- Stat cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon blue">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            </div>
            <div>
                <div class="stat-value">${totalApps}</div>
                <div class="stat-label">Applications Sent</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            </div>
            <div>
                <div class="stat-value">${pendingCount}</div>
                <div class="stat-label">Pending Review</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
            </div>
            <div>
                <div class="stat-value">${selectedCount}</div>
                <div class="stat-label">Selected</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon violet">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
            </div>
            <div>
                <div class="stat-value">${eligibleCount}</div>
                <div class="stat-label">Open for You</div>
            </div>
        </div>
    </div>

    <div style="display:grid; grid-template-columns:1fr 320px; gap:22px; align-items:start;">

        <!-- Recent applications -->
        <div class="card">
            <div class="card-body">
                <div class="section-title">Recent Applications</div>

                <c:choose>
                    <c:when test="${empty recentApps}">
                        <div class="empty-state" style="padding:32px 0;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                                <polyline points="14 2 14 8 20 8"/>
                            </svg>
                            <h3>No applications yet</h3>
                            <p>Browse internships and apply to get started</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="app-list">
                            <c:forEach var="app" items="${recentApps}">
                                <div class="app-card ${app.status}">
                                    <div class="app-info">
                                        <div class="app-title">${app.internshipTitle}</div>
                                        <div class="app-company">${app.companyName}</div>
                                        <div class="app-date">${app.appliedAt != null ? app.appliedAt.substring(0,10) : '—'}</div>
                                    </div>
                                    <span class="status-badge status-${app.status}">${app.status}</span>
                                </div>
                            </c:forEach>
                        </div>
                        <div style="margin-top:14px;">
                            <a href="${pageContext.request.contextPath}/student/applications"
                               class="btn btn-ghost btn-sm">View all applications →</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Profile card -->
        <div class="card">
            <div class="card-body">
                <div class="section-title">My Profile</div>
                <div class="profile-grid">
                    <div class="profile-avatar"><%= initial %></div>
                    <div>
                        <div class="profile-name">${student.fullName}</div>
                        <div class="profile-roll">${student.rollNumber}</div>
                        <div class="profile-tags">
                            <span class="tag blue">${student.department}</span>
                            <span class="tag green">CGPA ${student.cgpa}</span>
                        </div>
                    </div>
                </div>

                <div style="margin-top:18px; display:flex; flex-direction:column; gap:10px;">
                    <div style="display:flex; justify-content:space-between; font-size:13px; padding:8px 0; border-bottom:1px solid var(--slate-100);">
                        <span style="color:var(--slate-500); font-weight:600;">Email</span>
                        <span style="color:var(--slate-800); font-size:12.5px;">${student.email}</span>
                    </div>
                    <div style="display:flex; justify-content:space-between; font-size:13px; padding:8px 0; border-bottom:1px solid var(--slate-100);">
                        <span style="color:var(--slate-500); font-weight:600;">Mobile</span>
                        <span style="color:var(--slate-800);">${student.mobile}</span>
                    </div>
                    <div style="display:flex; justify-content:space-between; font-size:13px; padding:8px 0;">
                        <span style="color:var(--slate-500); font-weight:600;">Member since</span>
                        <span style="color:var(--slate-800); font-size:12.5px;">
                            ${student.createdAt != null ? student.createdAt.substring(0,10) : '—'}
                        </span>
                    </div>
                </div>

                <div style="margin-top:16px;">
                    <a href="${pageContext.request.contextPath}/student/startExam"
                       class="btn btn-primary" style="width:100%; justify-content:center;">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        Go to My Exam
                    </a>
                </div>
            </div>
        </div>

    </div>
</div>
</body>
</html>
