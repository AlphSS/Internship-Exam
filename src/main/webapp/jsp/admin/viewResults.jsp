<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Results — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <style>
        .pct-bar-wrap { display:flex; align-items:center; gap:10px; }
        .pct-bar-track { width:100px; height:6px; background:var(--border); border-radius:99px; overflow:hidden; }
        .pct-bar-fill  { height:100%; border-radius:99px; }
        .pct-high   { background:var(--green-dark); }
        .pct-mid    { background:var(--amber-dark); }
        .pct-low    { background:var(--red-dark); }
        .pct-label  { font-family:'JetBrains Mono',monospace; font-size:12.5px; font-weight:600; min-width:42px; }
    </style>
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Exam Results</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/manageExams">Exams</a>
                <span>/</span>
                <c:choose>
                    <c:when test="${filterMode == 'exam' && exam != null}">${exam.examTitle}</c:when>
                    <c:otherwise>All Results</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/manageExams" class="btn btn-ghost">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
                </svg>
                Back to Exams
            </a>
        </div>
    </header>

    <div class="page-content">

        <!-- Filter by exam -->
        <div style="display:flex;align-items:center;gap:12px;margin-bottom:20px;flex-wrap:wrap;">
            <label style="font-size:13px;font-weight:600;color:var(--text-secondary);">Filter by Exam:</label>
            <select class="filter-select" onchange="location.href='${pageContext.request.contextPath}/admin/viewResults?examId='+this.value">
                <option value="">All Exams</option>
                <c:forEach var="ex" items="${allExams}">
                    <option value="${ex.examId}" ${exam != null && exam.examId == ex.examId ? 'selected' : ''}>
                        ${ex.examTitle} — ${ex.internshipTitle}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="table-card">
            <div class="table-toolbar">
                <div class="toolbar-left">
                    <div class="search-box">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <input type="text" placeholder="Search student, exam..." oninput="filterTable(this.value)">
                    </div>
                </div>
                <div class="toolbar-right">
                    <span style="font-size:12.5px;color:var(--text-muted);">${fn:length(results)} results</span>
                </div>
            </div>

            <table id="resultsTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student</th>
                        <th>Roll No.</th>
                        <th>Exam</th>
                        <th>Internship</th>
                        <th>Score</th>
                        <th>Percentage</th>
                        <th>Submitted On</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty results}">
                            <tr>
                                <td colspan="8" class="no-data-cell">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
                                    </svg>
                                    <p>No results yet. Students haven't submitted this exam.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${results}" varStatus="s">
                                <c:set var="pct" value="${r.percentage}" />
                                <tr>
                                    <td class="td-mono td-dim">${s.count}</td>
                                    <td>
                                        <div class="td-primary">${r.studentName}</div>
                                        <div class="td-dim" style="font-size:12px;">${r.department}</div>
                                    </td>
                                    <td class="td-mono td-dim">${r.rollNumber}</td>
                                    <td class="td-dim">${r.examTitle}</td>
                                    <td class="td-dim">${r.internshipTitle}</td>
                                    <td>
                                        <span class="td-mono" style="font-weight:700;color:var(--text-primary);">${r.score}</span>
                                        <span class="td-dim"> / ${r.totalMarks}</span>
                                    </td>
                                    <td>
                                        <div class="pct-bar-wrap">
                                            <div class="pct-bar-track">
                                                <div class="pct-bar-fill ${pct >= 75 ? 'pct-high' : pct >= 50 ? 'pct-mid' : 'pct-low'}"
                                                     style="width:${pct}%;"></div>
                                            </div>
                                            <span class="pct-label">${r.percentage}%</span>
                                        </div>
                                    </td>
                                    <td class="td-mono td-dim" style="font-size:12px;">
                                        ${r.submittedAt != null ? r.submittedAt.substring(0,16) : '—'}
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
    document.querySelectorAll('#resultsTable tbody tr').forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
