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
    <title>Add Internship — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Add Internship</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/viewInternships">Internships</a>
                <span>/</span> Add New
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
                <h3>Internship Details</h3>
                <p>Fill in all required fields marked with an asterisk (*)</p>
            </div>

            <form action="${pageContext.request.contextPath}/admin/addInternship" method="post"
                  onsubmit="return validateForm()">
                <div class="form-body">

                    <!-- Row 1: Company + Title -->
                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label">Company <span class="req">*</span></label>
                            <select name="companyId" class="form-control" id="companyId" required>
                                <option value="">-- Select a company --</option>
                                <c:forEach var="company" items="${companies}">
                                    <option value="${company.companyId}">${company.companyName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Internship Title <span class="req">*</span></label>
                            <input type="text" name="title" class="form-control"
                                   placeholder="e.g. Java Backend Developer Intern"
                                   maxlength="200" required>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="form-group" style="margin-top:2px;">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="3"
                                  placeholder="Describe the role, responsibilities, tech stack..."></textarea>
                    </div>

                    <hr class="divider">

                    <!-- Row 2: Stipend + Duration + Vacancies -->
                    <div class="form-grid-3">
                        <div class="form-group">
                            <label class="form-label">Stipend (Rs/month) <span class="req">*</span></label>
                            <input type="number" name="stipend" class="form-control"
                                   placeholder="e.g. 10000" min="0" step="500" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Duration (months) <span class="req">*</span></label>
                            <input type="number" name="durationMonths" class="form-control"
                                   placeholder="e.g. 3" min="1" max="24" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Vacancies <span class="req">*</span></label>
                            <input type="number" name="vacancies" class="form-control"
                                   placeholder="e.g. 5" min="1" required>
                        </div>
                    </div>

                    <!-- Row 3: CGPA + Start Date + End Date -->
                    <div class="form-grid-3" style="margin-top:2px;">
                        <div class="form-group">
                            <label class="form-label">Minimum CGPA <span class="req">*</span></label>
                            <input type="number" name="minCgpa" id="minCgpa" class="form-control"
                                   placeholder="e.g. 7.5" min="0" max="10" step="0.01" required>
                            <span class="form-hint">Eligibility threshold out of 10</span>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Start Date</label>
                            <input type="date" name="startDate" id="startDate" class="form-control">
                        </div>
                        <div class="form-group">
                            <label class="form-label">End Date</label>
                            <input type="date" name="endDate" id="endDate" class="form-control">
                        </div>
                    </div>

                    <!-- Status -->
                    <div class="form-group" style="max-width:220px; margin-top:2px;">
                        <label class="form-label">Posting Status</label>
                        <select name="status" class="form-control">
                            <option value="open">Open — accepting applications</option>
                            <option value="closed">Closed</option>
                        </select>
                    </div>

                </div><!-- /form-body -->

                <div class="form-footer">
                    <button type="submit" class="btn btn-primary">Save Internship</button>
                    <a href="${pageContext.request.contextPath}/admin/viewInternships" class="btn btn-ghost">Cancel</a>
                </div>
            </form>
        </div><!-- /form-card -->

    </div><!-- /page-content -->
</div><!-- /main-wrap -->
</div><!-- /layout -->

<script>
function validateForm() {
    const company   = document.getElementById('companyId').value;
    const title     = document.querySelector('[name="title"]').value.trim();
    const stipend   = parseFloat(document.querySelector('[name="stipend"]').value);
    const duration  = parseInt(document.querySelector('[name="durationMonths"]').value);
    const vacancies = parseInt(document.querySelector('[name="vacancies"]').value);
    const cgpa      = parseFloat(document.getElementById('minCgpa').value);
    const startDate = document.getElementById('startDate').value;
    const endDate   = document.getElementById('endDate').value;

    if (!company)                              { alert('Please select a company.');              return false; }
    if (!title)                                { alert('Internship title is required.');          return false; }
    if (isNaN(stipend)  || stipend < 0)        { alert('Enter a valid stipend amount.');         return false; }
    if (isNaN(duration) || duration < 1)       { alert('Duration must be at least 1 month.');   return false; }
    if (isNaN(vacancies)|| vacancies < 1)      { alert('Vacancies must be at least 1.');        return false; }
    if (isNaN(cgpa) || cgpa < 0 || cgpa > 10) { alert('CGPA must be between 0.00 and 10.00.'); return false; }
    if (startDate && endDate && endDate < startDate) {
        alert('End date cannot be before start date.'); return false;
    }
    return true;
}
</script>
</body>
</html>
