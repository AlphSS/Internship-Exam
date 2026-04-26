<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    if (session.getAttribute("studentId") == null) {
        response.sendRedirect(request.getContextPath() + "/student/login"); return;
    }
    com.admin.model.Student student = (com.admin.model.Student) session.getAttribute("student");
    String initial = student != null && student.getFullName() != null
                   ? student.getFullName().substring(0,1).toUpperCase() : "S";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications — InternAdmin Student</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/student-style.css">
</head>
<body>
<div class="app-shell">

    <!-- ══ SIDEBAR ══ -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="sidebar-brand-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                    <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                </svg>
            </div>
            <div>
                <div class="sidebar-brand-name">InternAdmin</div>
                <div class="sidebar-brand-sub">Student Portal</div>
            </div>
        </div>

        <nav class="sidebar-nav">
            <div class="sidebar-section-label">Overview</div>
            <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                Dashboard
            </a>

            <div class="sidebar-section-label">Internships</div>
            <a href="${pageContext.request.contextPath}/student/internships" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
                Browse Internships
            </a>
            <a href="${pageContext.request.contextPath}/student/applications" class="nav-item active">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                My Applications
            </a>

            <div class="sidebar-section-label">Exam</div>
            <a href="${pageContext.request.contextPath}/student/startExam" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                My Exam
            </a>
        </nav>

        <div class="sidebar-footer">
            <div class="sidebar-user">
                <div class="sidebar-avatar"><%= initial %></div>
                <div class="sidebar-user-info">
                    <div class="sidebar-user-name">${student.fullName}</div>
                    <div class="sidebar-user-role">Student</div>
                </div>
                <a href="${pageContext.request.contextPath}/student/logout" class="sidebar-logout" title="Logout">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                </a>
            </div>
        </div>
    </aside>

    <!-- ══ MAIN ══ -->
    <div class="main-wrap">

        <!-- Top bar -->
        <div class="topbar">
            <div class="topbar-left">
                <div class="topbar-breadcrumb">
                    <span class="topbar-page">My Applications</span>
                </div>
            </div>
            <div class="topbar-right">
                <span class="topbar-count">${fn:length(applications)} application${fn:length(applications) != 1 ? 's' : ''}</span>
                <a href="${pageContext.request.contextPath}/student/internships" class="btn btn-primary btn-sm">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    Apply for More
                </a>
            </div>
        </div>

        <div class="page-body">

            <!-- Flash -->
            <c:if test="${msg == 'applied'}">
                <div class="alert alert-success">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                    Your application has been submitted successfully!
                </div>
            </c:if>

            <!-- Filter pills -->
            <div class="filter-pills" style="margin-bottom:20px;">
                <button class="filter-pill active" onclick="filterApps('all', this)">All</button>
                <button class="filter-pill" onclick="filterApps('pending', this)">Pending</button>
                <button class="filter-pill" onclick="filterApps('shortlisted', this)">Shortlisted</button>
                <button class="filter-pill" onclick="filterApps('selected', this)">Selected</button>
                <button class="filter-pill" onclick="filterApps('rejected', this)">Rejected</button>
            </div>

            <!-- Applications list -->
            <c:choose>
                <c:when test="${empty applications}">
                    <div class="empty-state">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                            <line x1="16" y1="13" x2="8" y2="13"/>
                            <line x1="16" y1="17" x2="8" y2="17"/>
                        </svg>
                        <h3>No applications yet</h3>
                        <p>You haven't applied to any internships.</p>
                        <a href="${pageContext.request.contextPath}/student/internships" class="btn btn-primary" style="margin-top:16px;">Browse Internships</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="app-list" id="appList">
                        <c:forEach var="app" items="${applications}">
                            <div class="app-row ${app.status}" data-status="${app.status}">

                                <div class="app-info">
                                    <div class="app-title">${app.internshipTitle}</div>
                                    <div class="app-company">
                                        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle;margin-right:3px;"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                                        ${app.companyName}
                                    </div>
                                    <div class="app-date">Applied on ${app.appliedAt != null ? app.appliedAt.substring(0,10) : '—'}</div>

                                    <!-- Status tracker timeline -->
                                    <div class="status-tracker" style="margin-top:12px; max-width:360px;">
                                        <div class="tracker-step done">
                                            <div class="tracker-dot">✓</div>
                                            <div class="tracker-label">Applied</div>
                                        </div>

                                        <c:set var="shortlistDone"    value="${app.status == 'shortlisted' || app.status == 'selected'}" />
                                        <c:set var="shortlistCurrent" value="${app.status == 'shortlisted'}" />
                                        <div class="tracker-step ${shortlistDone ? 'done' : shortlistCurrent ? 'current' : ''}">
                                            <div class="tracker-dot">${shortlistDone ? '✓' : '2'}</div>
                                            <div class="tracker-label">Shortlisted</div>
                                        </div>

                                        <c:choose>
                                            <c:when test="${app.status == 'selected'}">
                                                <div class="tracker-step done">
                                                    <div class="tracker-dot">✓</div>
                                                    <div class="tracker-label">Selected</div>
                                                </div>
                                            </c:when>
                                            <c:when test="${app.status == 'rejected'}">
                                                <div class="tracker-step rejected">
                                                    <div class="tracker-dot">✗</div>
                                                    <div class="tracker-label">Rejected</div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="tracker-step">
                                                    <div class="tracker-dot">3</div>
                                                    <div class="tracker-label">Decision</div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="app-right">
                                    <span class="badge badge-${app.status}">${app.status}</span>
                                    <c:if test="${not empty app.remarks}">
                                        <div class="app-remarks">
                                            <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle;margin-right:3px;"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                                            ${app.remarks}
                                        </div>
                                    </c:if>
                                    <c:if test="${app.status == 'selected'}">
                                        <a href="${pageContext.request.contextPath}/student/startExam" class="btn btn-success btn-sm">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                            Take Exam
                                        </a>
                                    </c:if>
                                </div>

                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </div><!-- /page-body -->
    </div><!-- /main-wrap -->
</div><!-- /app-shell -->

<script>
function filterApps(status, btn) {
    document.querySelectorAll('.filter-pill').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('#appList .app-row').forEach(card => {
        card.style.display = (status === 'all' || card.dataset.status === status) ? '' : 'none';
    });
}
</script>
</body>
</html>
