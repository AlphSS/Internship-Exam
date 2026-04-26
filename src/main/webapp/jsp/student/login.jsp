<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("studentId") != null) {
        response.sendRedirect(request.getContextPath() + "/student/dashboard"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/student-style.css">
</head>
<body>
<div class="auth-page">

    <!-- Left panel -->
    <div class="auth-left">
        <div class="dot-grid"></div>

        <div class="left-brand">
            <div class="left-brand-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                    <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                </svg>
            </div>
            <span class="left-brand-name">InternAdmin</span>
        </div>

        <div class="left-hero">
            <h1>Your internship<br>journey <span>starts here</span></h1>
            <p>Apply for internships matched to your CGPA, track your application status, and take your placement exam — all in one place.</p>
        </div>

        <div class="left-features">
            <div class="feature-row">
                <div class="feature-dot">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
                </div>
                <span class="feature-text">Browse internships matching your CGPA</span>
            </div>
            <div class="feature-row">
                <div class="feature-dot">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                </div>
                <span class="feature-text">Track application status in real-time</span>
            </div>
            <div class="feature-row">
                <div class="feature-dot">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                </div>
                <span class="feature-text">Take timed online placement exam</span>
            </div>
        </div>
    </div>

    <!-- Right panel -->
    <div class="auth-right">
        <div class="auth-box">

            <div class="auth-box-header">
                <h2>Welcome back</h2>
                <p>Sign in to your student account</p>
            </div>

            <c:if test="${msg == 'loggedOut'}">
                <div class="alert alert-info" style="margin-bottom:16px;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                    You have been logged out successfully.
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error" style="margin-bottom:16px;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/student/login" method="post" onsubmit="return validateForm()">

                <div class="form-group" style="margin-bottom:14px;">
                    <label class="form-label">Email Address</label>
                    <div class="input-wrap">
                        <span class="input-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        </span>
                        <input type="email" name="email" class="form-control input-padded"
                               placeholder="Enter your email"
                               value="${f_email}" autocomplete="email" required>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom:20px;">
                    <label class="form-label">Password</label>
                    <div class="input-wrap">
                        <span class="input-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                        </span>
                        <input type="password" name="password" id="password" class="form-control input-padded"
                               placeholder="Enter your password" autocomplete="current-password" required>
                        <button type="button" class="pw-toggle" onclick="togglePw()">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn-auth">
                    Sign In
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                </button>
            </form>

            <div class="auth-divider">or</div>

            <div class="auth-link">
                New student? <a href="${pageContext.request.contextPath}/student/register">Create an account</a>
            </div>
            <div class="auth-link-sm">
                Admin? <a href="${pageContext.request.contextPath}/admin/login">Go to Admin Login</a>
            </div>

        </div>
    </div>
</div>

<script>
function togglePw() {
    const el = document.getElementById('password');
    el.type = el.type === 'password' ? 'text' : 'password';
}
function validateForm() {
    const email = document.querySelector('[name="email"]').value.trim();
    const pw    = document.getElementById('password').value;
    if (!email) { alert('Email is required.'); return false; }
    if (!pw)    { alert('Password is required.'); return false; }
    return true;
}
</script>
</body>
</html>
