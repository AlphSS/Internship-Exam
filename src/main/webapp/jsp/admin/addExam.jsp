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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Exam — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Create Exam</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/manageExams">Exams</a>
                <span>/</span> Create New
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/manageExams" class="btn btn-ghost">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
                </svg>
                Back
            </a>
        </div>
    </header>

    <div class="page-content">

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                ${error}
            </div>
        </c:if>

        <c:if test="${empty availableInternships}">
            <div class="alert alert-warning">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                All internships already have an exam assigned, or no internships exist.
                <a href="${pageContext.request.contextPath}/admin/addInternship" style="color:var(--blue);font-weight:600;margin-left:6px;">Add an internship first.</a>
            </div>
        </c:if>

        <div class="form-card" style="max-width:600px;">
            <div class="form-card-head">
                <h3>Exam Details</h3>
                <p>Each internship can have only one exam. Fields marked * are required.</p>
            </div>
            <form action="${pageContext.request.contextPath}/admin/addExam" method="post"
                  onsubmit="return validateForm()">
                <div class="form-body">

                    <div class="form-group">
                        <label class="form-label">Internship <span class="req">*</span></label>
                        <select name="internshipId" class="form-control" required>
                            <option value="">-- Select Internship --</option>
                            <c:forEach var="i" items="${availableInternships}">
                                <option value="${i.internshipId}">
                                    ${i.title} — ${i.companyName}
                                </option>
                            </c:forEach>
                        </select>
                        <span class="form-hint">Only internships without an existing exam are shown.</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Exam Title <span class="req">*</span></label>
                        <input type="text" name="examTitle" class="form-control"
                               placeholder="e.g. Java Programming Assessment"
                               maxlength="255" required>
                    </div>

                    <div class="form-group" style="max-width:200px;">
                        <label class="form-label">Duration (minutes) <span class="req">*</span></label>
                        <input type="number" name="duration" class="form-control"
                               value="30" min="1" max="300" required>
                        <span class="form-hint">Between 1 and 300 minutes</span>
                    </div>

                </div>
                <div class="form-footer">
                    <button type="submit" class="btn btn-primary"
                            ${empty availableInternships ? 'disabled' : ''}>
                        Create Exam
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/manageExams" class="btn btn-ghost">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</div>
<script>
function validateForm() {
    const internship = document.querySelector('[name="internshipId"]').value;
    const title      = document.querySelector('[name="examTitle"]').value.trim();
    const duration   = parseInt(document.querySelector('[name="duration"]').value);
    if (!internship) { alert('Please select an internship.'); return false; }
    if (!title)      { alert('Exam title is required.');      return false; }
    if (isNaN(duration) || duration < 1 || duration > 300) {
        alert('Duration must be between 1 and 300 minutes.'); return false;
    }
    return true;
}
</script>
</body>
</html>
