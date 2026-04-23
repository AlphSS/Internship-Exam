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
    <title>Internships — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Internships</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                <span>/</span> All Internships
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/addInternship" class="btn btn-primary">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
                Add Internship
            </a>
        </div>
    </header>

    <div class="page-content">

        <c:if test="${msg == 'added'}">
            <div class="alert alert-success"><svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>Internship added successfully.</div>
        </c:if>
        <c:if test="${msg == 'updated'}">
            <div class="alert alert-success"><svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>Internship updated successfully.</div>
        </c:if>
        <c:if test="${msg == 'deleted'}">
            <div class="alert alert-info"><svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/></svg>Internship deleted.</div>
        </c:if>
        <c:if test="${msg == 'error'}">
            <div class="alert alert-error"><svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>An error occurred. Please try again.</div>
        </c:if>

        <div class="table-card">
            <div class="table-toolbar">
                <div class="toolbar-left">
                    <div class="search-box">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <input type="text" placeholder="Search internships..."
                               oninput="filterTable(this.value)">
                    </div>
                    <select class="filter-select" id="statusFilter" onchange="filterByStatus()">
                        <option value="">All Statuses</option>
                        <option value="open">Open</option>
                        <option value="closed">Closed</option>
                    </select>
                </div>
                <div class="toolbar-right">
                    <span style="font-size:12.5px;color:var(--text-muted);">${fn:length(internships)} internships</span>
                </div>
            </div>

            <table id="internshipTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Title</th>
                        <th>Company</th>
                        <th>Stipend</th>
                        <th>Duration</th>
                        <th>Min CGPA</th>
                        <th>Vacancies</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="internshipBody">
                    <c:choose>
                        <c:when test="${empty internships}">
                            <tr>
                                <td colspan="9" class="no-data-cell">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                                    </svg>
                                    <p>No internships yet. Create your first posting.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="i" items="${internships}" varStatus="s">
                                <tr>
                                    <td class="td-mono td-dim">${s.count}</td>
                                    <td class="td-primary">${i.title}</td>
                                    <td class="td-dim">${i.companyName}</td>
                                    <td class="td-mono">Rs.${i.stipend}</td>
                                    <td class="td-dim">${i.durationMonths} mo.</td>
                                    <td class="td-mono">${i.minCgpa}</td>
                                    <td class="td-mono">${i.vacancies}</td>
                                    <td><span class="badge badge-${i.status}">${i.status}</span></td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/admin/updateInternship?id=${i.internshipId}"
                                               class="btn btn-warning btn-sm">Edit</a>
                                            <a href="${pageContext.request.contextPath}/admin/deleteInternship?id=${i.internshipId}"
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Delete internship: ${i.title}?');">Delete</a>
                                        </div>
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
function filterTable(q) {
    q = q.toLowerCase();
    document.querySelectorAll('#internshipTable tbody tr').forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
    });
}
function filterByStatus() {
    const val = document.getElementById('statusFilter').value.toLowerCase();
    document.querySelectorAll('#internshipBody tr').forEach(row => {
        const badge = row.querySelector('.badge');
        if (!val || (badge && badge.innerText.toLowerCase() === val)) row.style.display = '';
        else row.style.display = 'none';
    });
}
</script>
</body>
</html>
