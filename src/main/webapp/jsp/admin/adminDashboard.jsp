<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login"); return;
    }
    String adminUser = (String) session.getAttribute("adminUser");
    String initial   = adminUser.substring(0,1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Dashboard</div>
            <div class="topbar-breadcrumb">Welcome back, <a href="#"><%= adminUser %></a></div>
        </div>
        <div class="topbar-right">
            <div class="admin-badge">
                <div class="admin-badge-avatar"><%= initial %></div>
                <%= adminUser %>
            </div>
        </div>
    </header>

    <div class="page-content">

        <!-- Stat cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon blue">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>
                    </svg>
                </div>
                <div>
                    <div class="stat-value">${summary.totalCompanies != null ? summary.totalCompanies : 0}</div>
                    <div class="stat-label">Total Companies</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                    </svg>
                </div>
                <div>
                    <div class="stat-value">${summary.totalInternships != null ? summary.totalInternships : 0}</div>
                    <div class="stat-label">Internships Posted</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon amber">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
                        <line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>
                    </svg>
                </div>
                <div>
                    <div class="stat-value">${summary.totalApplications != null ? summary.totalApplications : 0}</div>
                    <div class="stat-label">Applications</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon violet">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                </div>
                <div>
                    <div class="stat-value">${summary.totalSelected != null ? summary.totalSelected : 0}</div>
                    <div class="stat-label">Students Selected</div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="section-heading">Quick Actions</div>
        <div class="tiles-grid">
            <a href="${pageContext.request.contextPath}/admin/addCompany" class="tile">
                <div class="tile-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/>
                    </svg>
                </div>
                <div class="tile-label">Add Company</div>
                <div class="tile-desc">Register a new hiring company</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/addInternship" class="tile">
                <div class="tile-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                    </svg>
                </div>
                <div class="tile-label">Add Internship</div>
                <div class="tile-desc">Post a new internship opening</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/viewApplications" class="tile">
                <div class="tile-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
                    </svg>
                </div>
                <div class="tile-label">Applications</div>
                <div class="tile-desc">Review and process student applications</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="tile">
                <div class="tile-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/>
                        <line x1="6" y1="20" x2="6" y2="14"/><line x1="2" y1="20" x2="22" y2="20"/>
                    </svg>
                </div>
                <div class="tile-label">Reports</div>
                <div class="tile-desc">Placement stats and analytics</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/viewCompanies" class="tile">
                <div class="tile-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>
                    </svg>
                </div>
                <div class="tile-label">Manage Companies</div>
                <div class="tile-desc">Edit or remove company records</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/viewInternships" class="tile">
                <div class="tile-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/>
                        <line x1="8" y1="18" x2="21" y2="18"/>
                        <line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/>
                    </svg>
                </div>
                <div class="tile-label">Manage Internships</div>
                <div class="tile-desc">Edit or remove internship postings</div>
            </a>
        </div>

    </div>
</div>
</div>
</body>
</html>
