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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Exams — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Exams</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                <span>/</span> Manage Exams
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/addExam" class="btn btn-primary">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
                Create Exam
            </a>
        </div>
    </header>

    <div class="page-content">

        <c:if test="${msg == 'examAdded'}">
            <div class="alert alert-success">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                Exam created successfully. Now add questions to it.
            </div>
        </c:if>
        <c:if test="${msg == 'questionAdded'}">
            <div class="alert alert-success">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                Question added successfully.
            </div>
        </c:if>
        <c:if test="${msg == 'error'}">
            <div class="alert alert-error">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                An error occurred.
            </div>
        </c:if>

        <div class="table-card">
            <div class="table-toolbar">
                <div class="toolbar-left">
                    <div class="search-box">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <input type="text" placeholder="Search exams..." oninput="filterTable(this.value)">
                    </div>
                </div>
                <div class="toolbar-right">
                    <span style="font-size:12.5px;color:var(--text-muted);">${fn:length(exams)} exams</span>
                </div>
            </div>

            <table id="examTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Exam Title</th>
                        <th>Internship</th>
                        <th>Company</th>
                        <th>Duration</th>
                        <th>Questions</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty exams}">
                            <tr>
                                <td colspan="8" class="no-data-cell">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
                                    </svg>
                                    <p>No exams created yet. Create your first exam.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="exam" items="${exams}" varStatus="s">
                                <tr>
                                    <td class="td-mono td-dim">${s.count}</td>
                                    <td class="td-primary">${exam.examTitle}</td>
                                    <td class="td-dim">${exam.internshipTitle}</td>
                                    <td class="td-dim">${exam.companyName}</td>
                                    <td class="td-mono">${exam.duration} min</td>
                                    <td>
                                        <span class="count-pill ${exam.questionCount > 0 ? 'count-pill-blue' : 'count-pill-none'}">
                                            ${exam.questionCount}
                                        </span>
                                    </td>
                                    <td class="td-mono td-dim" style="font-size:12px;">
                                        ${exam.createdAt != null ? exam.createdAt.substring(0,10) : '—'}
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/admin/addQuestion?examId=${exam.examId}"
                                               class="btn btn-primary btn-sm">Add Questions</a>
                                            <a href="${pageContext.request.contextPath}/admin/viewResults?examId=${exam.examId}"
                                               class="btn btn-ghost btn-sm">Results</a>
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
    document.querySelectorAll('#examTable tbody tr').forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
