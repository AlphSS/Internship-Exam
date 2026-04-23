<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login"); return;
    }
    List<String[]> report = (List<String[]>) request.getAttribute("report");
    int maxVal = 1;
    if (report != null) {
        for (String[] row : report) {
            try { int v = Integer.parseInt(row[1]); if (v > maxVal) maxVal = v; } catch (Exception e) {}
        }
    }
    request.setAttribute("maxVal", maxVal);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Students per Company — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <style>
        .rank-badge {
            width:28px; height:28px; border-radius:50%;
            display:inline-flex; align-items:center; justify-content:center;
            font-size:11.5px; font-weight:700; font-family:'JetBrains Mono',monospace;
        }
        .rank-1 { background:#fef3c7; color:#92400e; border:1.5px solid #fde68a; }
        .rank-2 { background:#f1f5f9; color:#475569; border:1.5px solid #e2e8f0; }
        .rank-3 { background:#fff7ed; color:#9a3412; border:1.5px solid #fed7aa; }
        .rank-n { background:transparent; color:#94a3b8; font-size:12px; border:none; width:auto; }
    </style>
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Students per Company</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/reports">Reports</a>
                <span>/</span> Students Selected per Company
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
                    <strong style="font-size:14px;color:var(--text-primary);">Placement Rankings</strong>
                    <span style="font-size:12.5px;color:var(--text-muted);">Students with status = selected</span>
                </div>
                <div class="toolbar-right">
                    <span style="font-size:12.5px;color:var(--text-muted);">${fn:length(report)} companies</span>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th style="width:60px;">Rank</th>
                        <th>Company Name</th>
                        <th>Students Selected</th>
                        <th style="width:220px;">Visual</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty report}">
                            <tr>
                                <td colspan="4" class="no-data-cell">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/>
                                        <line x1="6" y1="20" x2="6" y2="14"/><line x1="2" y1="20" x2="22" y2="20"/>
                                    </svg>
                                    <p>No selections recorded yet. Process applications to see data here.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="row" items="${report}" varStatus="s">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.count == 1}"><span class="rank-badge rank-1">1</span></c:when>
                                            <c:when test="${s.count == 2}"><span class="rank-badge rank-2">2</span></c:when>
                                            <c:when test="${s.count == 3}"><span class="rank-badge rank-3">3</span></c:when>
                                            <c:otherwise><span class="rank-badge rank-n">#${s.count}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="td-primary">${row[0]}</td>
                                    <td>
                                        <span class="count-pill count-pill-blue">${row[1]}</span>
                                        <span class="td-dim" style="margin-left:6px;">
                                            student${row[1] != '1' ? 's' : ''}
                                        </span>
                                    </td>
                                    <td>
											<c:set var="pct" value="${(row[1] * 100) / maxVal}" />                                        <div class="bar-wrap">
                                            <div class="bar-track">
                                                <div class="bar-fill" style="width:${pct}%;"></div>
                                            </div>
                                            <span class="bar-label">${pct}%</span>
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
</body>
</html>
