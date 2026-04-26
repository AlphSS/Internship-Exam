<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.admin.model.Student" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
// Session check
Student student = (Student) session.getAttribute("student");

if (student == null) {
    response.sendRedirect(request.getContextPath() + "/student/login");
    return;
}

request.setAttribute("student", student);

String initial = (student.getFullName() != null && !student.getFullName().isEmpty())
        ? student.getFullName().substring(0,1).toUpperCase()
        : "S";

%>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>My Applications</title>

<!-- IMPORTANT CSS LINK -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/student-style.css">


</head>

<body>

<!-- ================= NAVBAR ================= -->

<nav class="topnav">
    <div class="nav-brand">
        <div class="nav-brand-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                <path d="M6 12v5c3 3 9 3 12 0v-5"/>
            </svg>
        </div>
        InternAdmin
    </div>

<div class="nav-links">
    <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link">
        Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/student/internships" class="nav-link">
        Internships
    </a>

    <a href="${pageContext.request.contextPath}/student/applications" class="nav-link active">
        My Applications
    </a>

    <a href="${pageContext.request.contextPath}/student/startExam" class="nav-link">
        My Exam
    </a>
</div>

<div class="nav-right">
    <div class="student-chip">
        <div class="student-avatar"><%= initial %></div>
        ${student.fullName}
    </div>

    <a href="${pageContext.request.contextPath}/student/logout" class="btn btn-ghost btn-sm">
        Logout
    </a>
</div>


</nav>

<!-- ================= PAGE ================= -->

<div class="page">

<!-- HEADER -->
<div class="page-header">
    <h1>My Applications</h1>
    <p>Track your internship applications and status</p>
</div>

<!-- SUCCESS MESSAGE -->
<c:if test="${param.msg == 'applied'}">
    <div class="alert alert-success">
        Application submitted successfully!
    </div>
</c:if>

<!-- EMPTY STATE -->
<c:if test="${empty applications}">
    <div class="empty-state">
        <h3>No applications yet</h3>
        <p>Browse internships and apply to get started</p>
    </div>
</c:if>

<!-- APPLICATION LIST -->
<div class="app-list">

    <c:forEach var="app" items="${applications}">

        <div class="app-card ${app.status}">

            <!-- LEFT SIDE -->
            <div class="app-info">
                <div class="app-title">${app.internshipTitle}</div>
                <div class="app-company">${app.companyName}</div>
                <div class="app-date">
                    ${app.appliedAt != null ? app.appliedAt : '—'}
                </div>
            </div>

            <!-- RIGHT SIDE -->
            <div class="app-right">

                <span class="status-badge status-${app.status}">
                    ${app.status}
                </span>

                <!-- EXAM BUTTON -->
                <c:if test="${app.status == 'selected'}">
                    <a href="${pageContext.request.contextPath}/student/startExam"
                       class="btn btn-success btn-sm">
                        Take Exam
                    </a>
                </c:if>

            </div>

        </div>

    </c:forEach>

</div>


</div>

</body>
</html>
