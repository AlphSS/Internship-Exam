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
    <title>Edit Internship — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Edit Internship</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/viewInternships">Internships</a>
                <span>/</span> Edit — ${internship.title}
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/viewInternships" class="btn btn-ghost">
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

        <div class="form-card" style="max-width:820px;">
            <div class="form-card-head">
                <h3>Edit Internship Details</h3>
                <p>Updating: <strong>${internship.title}</strong></p>
            </div>
            <form action="${pageContext.request.contextPath}/admin/updateInternship" method="post"
                  onsubmit="return validateForm()">
                <input type="hidden" name="internshipId" value="${internship.internshipId}">
                <div class="form-body">

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label">Company <span class="req">*</span></label>
                            <select name="companyId" class="form-control" required>
                                <option value="">-- Select Company --</option>
                                <c:forEach var="company" items="${companies}">
                                    <option value="${company.companyId}"
                                        <c:if test="${company.companyId == internship.companyId}">selected</c:if>>
                                        ${company.companyName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Internship Title <span class="req">*</span></label>
                            <input type="text" name="title" class="form-control"
                                   value="${internship.title}" maxlength="200" required>
                        </div>
                    </div>

                    <div class="form-group" style="margin-top:2px;">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="3">${internship.description}</textarea>
                    </div>

                    <hr class="divider">

                    <div class="form-grid-3">
                        <div class="form-group">
                            <label class="form-label">Stipend (Rs/month)</label>
                            <input type="number" name="stipend" class="form-control"
                                   value="${internship.stipend}" min="0" step="500">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Duration (months)</label>
                            <input type="number" name="durationMonths" class="form-control"
                                   value="${internship.durationMonths}" min="1" max="24">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Vacancies</label>
                            <input type="number" name="vacancies" class="form-control"
                                   value="${internship.vacancies}" min="1">
                        </div>
                    </div>

                    <div class="form-grid-3" style="margin-top:2px;">
                        <div class="form-group">
                            <label class="form-label">Minimum CGPA</label>
                            <input type="number" name="minCgpa" id="minCgpa" class="form-control"
                                   value="${internship.minCgpa}" min="0" max="10" step="0.01">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Start Date</label>
                            <input type="date" name="startDate" id="startDate" class="form-control"
                                   value="${internship.startDate}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">End Date</label>
                            <input type="date" name="endDate" id="endDate" class="form-control"
                                   value="${internship.endDate}">
                        </div>
                    </div>

                    <div class="form-group" style="max-width:220px; margin-top:2px;">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-control">
                            <option value="open"   <c:if test="${internship.status == 'open'}">selected</c:if>>Open</option>
                            <option value="closed" <c:if test="${internship.status == 'closed'}">selected</c:if>>Closed</option>
                        </select>
                    </div>

                </div>
                <div class="form-footer">
                    <button type="submit" class="btn btn-success">Update Internship</button>
                    <a href="${pageContext.request.contextPath}/admin/viewInternships" class="btn btn-ghost">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</div>
<script>
function validateForm() {
    const title = document.querySelector('[name="title"]').value.trim();
    const cgpa  = parseFloat(document.getElementById('minCgpa').value);
    const start = document.getElementById('startDate').value;
    const end   = document.getElementById('endDate').value;
    if (!title) { alert('Title is required.'); return false; }
    if (isNaN(cgpa) || cgpa < 0 || cgpa > 10) { alert('CGPA must be between 0 and 10.'); return false; }
    if (start && end && end < start) { alert('End date cannot be before start date.'); return false; }
    return true;
}
</script>
</body>
</html>
