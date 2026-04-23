<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminUser") != null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login-style.css">
</head>
<body>

<!-- ── Left Panel ── -->
<div class="login-left">
    <div class="dot-grid"></div>

    <div class="left-brand">
        <div class="left-brand-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/>
            </svg>
        </div>
        <span class="left-brand-name">InternAdmin</span>
    </div>

    <div class="left-hero">
        <h1>Manage internships <em>smarter</em></h1>
        <p>A complete admin portal for companies, internship listings, student applications and placement reports.</p>
    </div>

    <div class="left-features">
        <div class="feature-row">
            <div class="feature-dot">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>
                </svg>
            </div>
            <span class="feature-text">Manage companies and internship listings</span>
        </div>
        <div class="feature-row">
            <div class="feature-dot">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
                </svg>
            </div>
            <span class="feature-text">Process student applications instantly</span>
        </div>
        <div class="feature-row">
            <div class="feature-dot">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/>
                    <line x1="6" y1="20" x2="6" y2="14"/><line x1="2" y1="20" x2="22" y2="20"/>
                </svg>
            </div>
            <span class="feature-text">View placement reports and statistics</span>
        </div>
        <div class="feature-row">
            <div class="feature-dot">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
            </div>
            <span class="feature-text">Full audit log on every admin action</span>
        </div>
    </div>
</div>

<!-- ── Right Panel ── -->
<div class="login-right">
    <div class="login-box">

        <div class="login-box-header">
            <h2>Welcome back</h2>
            <p>Sign in to your admin account to continue</p>
        </div>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
        <div class="alert-error">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
            <%= error %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/admin/login" method="post"
              onsubmit="return validateLogin()">

            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <div class="input-wrap">
                    <span class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                        </svg>
                    </span>
                    <input type="text" id="username" name="username" class="form-control"
                           placeholder="Enter your username" autocomplete="username" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <div class="input-wrap">
                    <span class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                    </span>
                    <input type="password" id="password" name="password" class="form-control"
                           placeholder="Enter your password" autocomplete="current-password" required>
                    <button type="button" class="pw-toggle" onclick="togglePw()" title="Show password">
                        <svg id="eyeIcon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
            </div>

            <button type="submit" class="btn-login">
                Sign In
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                </svg>
            </button>
        </form>

        <div class="demo-hint">
            <strong>Demo credentials</strong><br>
            Username: <strong>admin</strong> &nbsp;|&nbsp; Password: <strong>admin123</strong>
        </div>

        <div class="login-footer">
            Internship &amp; Online Exam Management System &copy; 2024
        </div>
    </div>
</div>

<script>
function togglePw() {
    const pw = document.getElementById('password');
    pw.type = pw.type === 'password' ? 'text' : 'password';
}
function validateLogin() {
    const u = document.getElementById('username').value.trim();
    const p = document.getElementById('password').value.trim();
    if (!u || !p) { alert('Please enter both username and password.'); return false; }
    return true;
}
</script>
</body>
</html>
