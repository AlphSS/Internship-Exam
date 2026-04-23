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
    <title>Companies — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Companies</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                <span>/</span> All Companies
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/addCompany" class="btn btn-primary">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
                Add Company
            </a>
        </div>
    </header>

    <div class="page-content">

        <c:if test="${msg == 'added'}">
            <div class="alert alert-success">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                Company added successfully.
            </div>
        </c:if>
        <c:if test="${msg == 'updated'}">
            <div class="alert alert-success">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                Company updated successfully.
            </div>
        </c:if>
        <c:if test="${msg == 'deleted'}">
            <div class="alert alert-info">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/></svg>
                Company deleted successfully.
            </div>
        </c:if>
        <c:if test="${msg == 'error'}">
            <div class="alert alert-error">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                An error occurred. Please try again.
            </div>
        </c:if>
        <c:if test="${msg == 'notfound'}">
            <div class="alert alert-warning">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                Company not found.
            </div>
        </c:if>

        <div class="table-card">
            <div class="table-toolbar">
                <div class="toolbar-left">
                    <div class="search-box">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <input type="text" id="searchInput" placeholder="Search companies..."
                               oninput="filterTable(this.value)">
                    </div>
                </div>
                <div class="toolbar-right">
                    <span style="font-size:12.5px; color:var(--text-muted);">
                        ${fn:length(companies)} companies
                    </span>
                </div>
            </div>

            <table id="companyTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Company Name</th>
                        <th>Industry</th>
                        <th>Location</th>
                        <th>Contact Email</th>
                        <th>Website</th>
                        <th>Added On</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty companies}">
                            <tr>
                                <td colspan="8" class="no-data-cell">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                                        <polyline points="9 22 9 12 15 12 15 22"/>
                                    </svg>
                                    <p>No companies yet. Add your first company to get started.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="co" items="${companies}" varStatus="s">
                                <tr>
                                    <td class="td-mono td-dim">${s.count}</td>
                                    <td class="td-primary">${co.companyName}</td>
                                    <td class="td-dim">${co.industry}</td>
                                    <td class="td-dim">${co.location}</td>
                                    <td class="td-mono td-dim" style="font-size:12px;">${co.contactEmail}</td>
                                    <td>
                                        <c:if test="${not empty co.website}">
                                            <a href="${co.website}" target="_blank"
                                               style="color:var(--blue);font-size:13px;font-weight:500;">
                                                Visit site
                                            </a>
                                        </c:if>
                                    </td>
                                    <td class="td-mono td-dim" style="font-size:12px;">
                                        ${co.createdAt != null ? co.createdAt.substring(0,10) : '—'}
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/admin/updateCompany?id=${co.companyId}"
                                               class="btn btn-warning btn-sm">Edit</a>
                                            <a href="${pageContext.request.contextPath}/admin/deleteCompany?id=${co.companyId}"
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Delete ${co.companyName}? This will also remove linked internships.');">
                                               Delete
                                            </a>
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
    document.querySelectorAll('#companyTable tbody tr').forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
