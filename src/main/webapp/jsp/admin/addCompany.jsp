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
    <title>Add Company — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Add Company</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/viewCompanies">Companies</a>
                <span>/</span> Add New
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/viewCompanies" class="btn btn-ghost">
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

        <div class="form-card" style="max-width:700px;">
            <div class="form-card-head">
                <h3>Company Information</h3>
                <p>Fields marked with * are required</p>
            </div>
            <form action="${pageContext.request.contextPath}/admin/addCompany" method="post"
                  onsubmit="return validateForm()">
                <div class="form-body">
                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label">Company Name <span class="req">*</span></label>
                            <input type="text" name="companyName" class="form-control"
                                   placeholder="e.g. TechCorp India" maxlength="150" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Industry</label>
                            <input type="text" name="industry" class="form-control"
                                   placeholder="e.g. Software, Finance" maxlength="100">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Location</label>
                            <input type="text" name="location" class="form-control"
                                   placeholder="e.g. Pune, Mumbai" maxlength="150">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Contact Email</label>
                            <input type="email" name="contactEmail" class="form-control"
                                   placeholder="hr@company.com" maxlength="150">
                        </div>
                        <div class="form-group form-full">
                            <label class="form-label">Website URL</label>
                            <input type="url" name="website" class="form-control"
                                   placeholder="https://www.company.com" maxlength="255">
                            <span class="form-hint">Include https://</span>
                        </div>
                    </div>
                </div>
                <div class="form-footer">
                    <button type="submit" class="btn btn-primary">Save Company</button>
                    <a href="${pageContext.request.contextPath}/admin/viewCompanies" class="btn btn-ghost">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</div>
<script>
function validateForm() {
    const name = document.querySelector('[name="companyName"]').value.trim();
    if (!name) { alert('Company name is required.'); return false; }
    return true;
}
</script>
</body>
</html>
