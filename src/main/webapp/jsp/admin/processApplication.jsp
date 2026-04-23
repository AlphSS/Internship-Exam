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
    <title>Process Application — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Process Application</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/viewApplications">Applications</a>
                <span>/</span> Application #${application.applicationId}
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/viewApplications" class="btn btn-ghost">
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

        <div style="display:grid; grid-template-columns:1fr 380px; gap:22px; align-items:start;">

            <!-- LEFT: Details -->
            <div style="display:flex; flex-direction:column; gap:18px;">

                <!-- Student info -->
                <div class="form-card">
                    <div class="form-card-head">
                        <h3>Student Information</h3>
                    </div>
                    <div class="form-body" style="padding:0;">
                        <table class="info-table">
                            <tr><td class="info-key">Full Name</td>     <td class="info-val td-primary">${application.studentName}</td></tr>
                            <tr><td class="info-key">Email</td>          <td class="info-val td-mono" style="font-size:13px;">${application.studentEmail}</td></tr>
                            <tr><td class="info-key">Roll Number</td>    <td class="info-val td-mono">${application.rollNumber}</td></tr>
                            <tr><td class="info-key">Department</td>     <td class="info-val">${application.department}</td></tr>
                            <tr>
                                <td class="info-key">CGPA</td>
                                <td class="info-val">
                                    <strong style="font-size:17px; color:var(--blue-dark);">${application.cgpa}</strong>
                                    <span class="td-dim"> / 10.0</span>
                                </td>
                            </tr>
                            <tr><td class="info-key">Mobile</td>         <td class="info-val td-mono">${application.mobile}</td></tr>
                        </table>
                    </div>
                </div>

                <!-- Internship info -->
                <div class="form-card">
                    <div class="form-card-head">
                        <h3>Internship Information</h3>
                    </div>
                    <div class="form-body" style="padding:0;">
                        <table class="info-table">
                            <tr><td class="info-key">Internship</td>     <td class="info-val td-primary">${application.internshipTitle}</td></tr>
                            <tr><td class="info-key">Company</td>        <td class="info-val">${application.companyName}</td></tr>
                            <tr><td class="info-key">Applied On</td>     <td class="info-val td-mono" style="font-size:13px;">${application.appliedAt}</td></tr>
                            <tr>
                                <td class="info-key">Current Status</td>
                                <td class="info-val"><span class="badge badge-${application.status}">${application.status}</span></td>
                            </tr>
                            <tr>
                                <td class="info-key">Remarks</td>
                                <td class="info-val">
                                    <c:choose>
                                        <c:when test="${not empty application.remarks}">${application.remarks}</c:when>
                                        <c:otherwise><span class="td-dim">None</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>

            <!-- RIGHT: Action panel -->
            <div class="form-card">
                <div class="form-card-head">
                    <h3>Update Decision</h3>
                    <p>Action will be recorded in the audit log</p>
                </div>
                <form action="${pageContext.request.contextPath}/admin/processApplication"
                      method="post" onsubmit="return confirmAction()">
                    <input type="hidden" name="applicationId" value="${application.applicationId}">
                    <input type="hidden" name="status" id="selectedStatus" value="">

                    <div class="form-body">

                        <div class="section-heading" style="margin-top:0;">Select Action</div>

                        <!-- Status selector cards -->
                        <div class="status-selector">
                            <div class="status-opt" id="opt-shortlisted"
                                 onclick="selectStatus('shortlisted')">
                                <svg class="status-opt-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"/>
                                </svg>
                                <div class="status-opt-label">Shortlist</div>
                                <div class="status-opt-desc">Move to review</div>
                            </div>
                            <div class="status-opt" id="opt-selected"
                                 onclick="selectStatus('selected')">
                                <svg class="status-opt-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="20 6 9 17 4 12"/>
                                </svg>
                                <div class="status-opt-label">Select</div>
                                <div class="status-opt-desc">Final selection</div>
                            </div>
                            <div class="status-opt" id="opt-rejected"
                                 onclick="selectStatus('rejected')">
                                <svg class="status-opt-icon" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                                </svg>
                                <div class="status-opt-label">Reject</div>
                                <div class="status-opt-desc">Not selected</div>
                            </div>
                        </div>

                        <div class="form-group" style="margin-top:4px;">
                            <label class="form-label">Remarks / Notes</label>
                            <textarea name="remarks" class="form-control" rows="4"
                                      placeholder="Add a reason or note for this decision...">${application.remarks}</textarea>
                        </div>
                    </div>

                    <div class="form-footer">
                        <button type="submit" class="btn btn-primary">Save Decision</button>
                        <a href="${pageContext.request.contextPath}/admin/viewApplications" class="btn btn-ghost">Cancel</a>
                    </div>
                </form>
            </div>

        </div><!-- /grid -->
    </div><!-- /page-content -->
</div><!-- /main-wrap -->
</div><!-- /layout -->

<script>
function selectStatus(status) {
    // Clear all
    ['shortlisted','selected','rejected'].forEach(s => {
        const el = document.getElementById('opt-' + s);
        el.classList.remove('active-shortlist','active-selected','active-rejected');
    });
    // Set active
    const map = { shortlisted:'active-shortlist', selected:'active-selected', rejected:'active-rejected' };
    document.getElementById('opt-' + status).classList.add(map[status]);
    document.getElementById('selectedStatus').value = status;
}

function confirmAction() {
    const status = document.getElementById('selectedStatus').value;
    if (!status) {
        alert('Please select an action — Shortlist, Select, or Reject.');
        return false;
    }
    if (status === 'selected') {
        return confirm('Confirm final selection for this student? This will be recorded in the audit log.');
    }
    if (status === 'rejected') {
        return confirm('Confirm rejection of this application?');
    }
    return true;
}
</script>
</body>
</html>
