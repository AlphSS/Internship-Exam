<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login"); return;
    }
    List<String[]> report = (List<String[]>) request.getAttribute("report");
    int maxCount = 1;
    if (report != null) {
        for (String[] r : report) {
            try { int v = Integer.parseInt(r[2]); if (v > maxCount) maxCount = v; } catch (Exception e) {}
        }
    }
    request.setAttribute("maxCount", maxCount);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Counts — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Application Counts</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/reports">Reports</a>
                <span>/</span> Applications per Internship
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-ghost">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
                </svg>
                Reports
            </a>
        </div>
    </header>

    <div class="page-content">

        <div class="table-card">
            <div class="table-toolbar">
                <div class="toolbar-left">
                    <div class="search-box">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <input type="text" placeholder="Search internship or company..."
                               oninput="filterTable(this.value)">
                    </div>
                </div>
                <div class="toolbar-right">
                    <span style="font-size:12.5px;color:var(--text-muted);">${fn:length(report)} internships</span>
                </div>
            </div>

            <table id="countTable">
                <thead>
                    <tr>
                        <th style="width:48px;">#</th>
                        <th>Internship Title</th>
                        <th>Company</th>
                        <th>Applications</th>
                        <th style="width:200px;">Demand</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty report}">
                            <tr>
                                <td colspan="5" class="no-data-cell">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                                    </svg>
                                    <p>No internship data available yet.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="row" items="${report}" varStatus="s">
                                <c:set var="cnt" value="${Integer.parseInt(row[2])}" />
                                <tr>
                                    <td class="td-mono td-dim">${s.count}</td>
                                    <td class="td-primary">${row[0]}</td>
                                    <td class="td-dim">${row[1]}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cnt == 0}">
                                                <span class="count-pill count-pill-none">0</span>
                                                <span class="td-dim" style="margin-left:6px;">no applications</span>
                                            </c:when>
                                            <c:when test="${cnt >= 10}">
                                                <span class="count-pill count-pill-green">${row[2]}</span>
                                                <span style="margin-left:6px;font-size:11.5px;color:var(--green-dark);font-weight:600;">High demand</span>
                                            </c:when>
                                            <c:when test="${cnt >= 5}">
                                                <span class="count-pill count-pill-blue">${row[2]}</span>
                                                <span class="td-dim" style="margin-left:6px;">applications</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="count-pill count-pill-amber">${row[2]}</span>
                                                <span class="td-dim" style="margin-left:6px;">applications</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:set var="barPct" value="${cnt > 0 ? (cnt * 100) / maxCount : 0}" />
                                        <div class="bar-wrap">
                                            <div class="bar-track">
                                                <div class="bar-fill" style="width:${barPct}%;"></div>
                                            </div>
                                            <span class="bar-label">${barPct}%</span>
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
    document.querySelectorAll('#countTable tbody tr').forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
