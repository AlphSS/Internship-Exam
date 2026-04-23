<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applications — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Applications</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                <span>/</span> All Applications
            </div>
        </div>
    </header>

    <div class="page-content">

        <c:if test="${msg == 'shortlisted'}">
            <div class="alert alert-info"><svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>Application shortlisted successfully.</div>
        </c:if>
        <c:if test="${msg == 'selected'}">
            <div class="alert alert-success"><svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>Student selected successfully.</div>
        </c:if>
        <c:if test="${msg == 'rejected'}">
            <div class="alert alert-error"><svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>Application rejected.</div>
        </c:if>
        <c:if test="${msg == 'error'}">
            <div class="alert alert-error"><svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>An error occurred while processing the application.</div>
        </c:if>
        <c:if test="${msg == 'notfound'}">
            <div class="alert alert-warning"><svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>Application not found.</div>
        </c:if>

        <div class="table-card">
            <div class="table-toolbar">
                <div class="toolbar-left">
                    <div class="search-box">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <input type="text" id="searchInput"
                               placeholder="Search student, company, internship..."
                               oninput="filterApplications()">
                    </div>
                    <select class="filter-select" id="statusFilter" onchange="filterApplications()">
                        <option value="">All Statuses</option>
                        <option value="pending">Pending</option>
                        <option value="shortlisted">Shortlisted</option>
                        <option value="selected">Selected</option>
                        <option value="rejected">Rejected</option>
                    </select>
                </div>
                <div class="toolbar-right">
                    <span style="font-size:12.5px;color:var(--text-muted);">${fn:length(applications)} applications</span>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student</th>
                        <th>Roll No.</th>
                        <th>Dept / CGPA</th>
                        <th>Internship</th>
                        <th>Company</th>
                        <th>Applied On</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="appBody">
                    <c:choose>
                        <c:when test="${empty applications}">
                            <tr>
                                <td colspan="9" class="no-data-cell">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                                        <polyline points="14 2 14 8 20 8"/>
                                    </svg>
                                    <p>No applications received yet.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="app" items="${applications}" varStatus="s">
                                <tr>
                                    <td class="td-mono td-dim">${s.count}</td>
                                    <td>
                                        <div class="td-primary">${app.studentName}</div>
                                        <div class="td-dim" style="font-size:12px;">${app.studentEmail}</div>
                                    </td>
                                    <td class="td-mono td-dim">${app.rollNumber}</td>
                                    <td>
                                        <div class="td-dim">${app.department}</div>
                                        <div class="td-mono" style="font-size:12px;">CGPA: <strong>${app.cgpa}</strong></div>
                                    </td>
                                    <td class="td-primary">${app.internshipTitle}</td>
                                    <td class="td-dim">${app.companyName}</td>
                                    <td class="td-mono td-dim" style="font-size:12px;">
                                        ${app.appliedAt != null ? app.appliedAt.substring(0,10) : '—'}
                                    </td>
                                    <td><span class="badge badge-${app.status}">${app.status}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/processApplication?id=${app.applicationId}"
                                           class="btn btn-primary btn-sm">Process</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
</div>
<script>
function filterApplications() {
    const q      = document.getElementById('searchInput').value.toLowerCase();
    const status = document.getElementById('statusFilter').value.toLowerCase();
    document.querySelectorAll('#appBody tr').forEach(row => {
        const text  = row.innerText.toLowerCase();
        const badge = row.querySelector('.badge');
        const rs    = badge ? badge.innerText.toLowerCase() : '';
        row.style.display = (text.includes(q) && (!status || rs === status)) ? '' : 'none';
    });
}
</script>
</body>
</html>
