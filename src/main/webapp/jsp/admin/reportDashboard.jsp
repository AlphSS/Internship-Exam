<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Reports</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                <span>/</span> Reports
            </div>
        </div>
    </header>

    <div class="page-content">

        <div class="alert alert-info">
            <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>
            </svg>
            Select a report below to view detailed placement and application data.
        </div>

        <div class="report-grid">

            <!-- Report 1 -->
            <a href="${pageContext.request.contextPath}/admin/studentsPerCompany" class="report-tile">
                <div class="report-tile-icon" style="background:var(--blue-light); color:var(--blue-dark);">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                    </svg>
                </div>
                <div class="report-tile-title">Students Selected per Company</div>
                <div class="report-tile-desc">
                    View the total number of students who were finally selected across
                    each company's internship programmes. Ranked from highest to lowest.
                </div>
                <div class="report-tile-cta">
                    View Report
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                    </svg>
                </div>
            </a>

            <!-- Report 2 -->
            <a href="${pageContext.request.contextPath}/admin/internshipCount" class="report-tile">
                <div class="report-tile-icon" style="background:var(--green-light); color:var(--green-dark);">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                </div>
                <div class="report-tile-title">Application Count per Internship</div>
                <div class="report-tile-desc">
                    See the total number of student applications received for each
                    internship posting, with a visual demand indicator.
                </div>
                <div class="report-tile-cta">
                    View Report
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                    </svg>
                </div>
            </a>

        </div>
    </div>
</div>
</div>
</body>
</html>
