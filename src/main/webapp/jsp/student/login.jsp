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
    <style>
        body {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 1fr 1fr;
            background: #0f172a;
        }

        /* ── Left panel ── */
        .login-left {
            display: flex; flex-direction: column;
            justify-content: space-between; padding: 44px 52px;
            background: linear-gradient(150deg, #0f172a 0%, #1e1b4b 60%, #0f172a 100%);
            position: relative; overflow: hidden;
        }
        .login-left::before {
            content: ''; position: absolute;
            width: 480px; height: 480px; border-radius: 50%;
            background: radial-gradient(circle, rgba(99,102,241,.18) 0%, transparent 70%);
            top: -120px; left: -120px;
            animation: glow 8s ease-in-out infinite;
        }
        .login-left::after {
            content: ''; position: absolute;
            width: 320px; height: 320px; border-radius: 50%;
            background: radial-gradient(circle, rgba(37,99,235,.12) 0%, transparent 70%);
            bottom: -60px; right: -60px;
            animation: glow 10s ease-in-out infinite reverse;
        }
        @keyframes glow { 0%,100%{transform:scale(1)} 50%{transform:scale(1.08)} }

        .dot-grid {
            position: absolute; inset: 0;
            background-image: radial-gradient(rgba(255,255,255,.05) 1px, transparent 1px);
            background-size: 26px 26px; pointer-events: none;
        }

        .left-brand {
            position: relative; z-index: 1;
            display: flex; align-items: center; gap: 12px;
        }
        .brand-icon {
            width: 40px; height: 40px; border-radius: 10px;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            display: flex; align-items: center; justify-content: center; color: #fff;
            box-shadow: 0 4px 14px rgba(99,102,241,.45);
        }
        .brand-icon svg { width: 20px; height: 20px; }
        .brand-name { font-size: 18px; font-weight: 800; color: #f1f5f9; }

        .left-hero { position: relative; z-index: 1; }
        .left-hero h1 {
            font-size: 36px; font-weight: 800; color: #f1f5f9;
            line-height: 1.2; margin-bottom: 12px; letter-spacing: -.5px;
        }
        .left-hero h1 span {
            background: linear-gradient(90deg, #818cf8, #34d399);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .left-hero p { font-size: 14px; color: #64748b; line-height: 1.75; max-width: 320px; }

        .left-features { position: relative; z-index: 1; display: flex; flex-direction: column; gap: 12px; }
        .feature-row { display: flex; align-items: center; gap: 12px; }
        .feature-dot {
            width: 30px; height: 30px; border-radius: 8px; flex-shrink: 0;
            background: rgba(99,102,241,.15); border: 1px solid rgba(99,102,241,.25);
            display: flex; align-items: center; justify-content: center; color: #818cf8;
        }
        .feature-dot svg { width: 14px; height: 14px; }
        .feature-text { font-size: 13.5px; color: #94a3b8; font-weight: 500; }

        /* ── Right panel ── */
        .login-right {
            background: #f8fafc;
            display: flex; align-items: center; justify-content: center;
            padding: 48px 52px;
        }
        .login-box { width: 100%; max-width: 380px; }

        .box-header { margin-bottom: 28px; }
        .box-header h2 { font-size: 26px; font-weight: 800; color: #0f172a; letter-spacing: -.4px; }
        .box-header p  { font-size: 13.5px; color: #64748b; margin-top: 5px; }

        .input-wrap { position: relative; }
        .input-icon {
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
            color: #9ca3af; pointer-events: none;
        }
        .input-icon svg { width: 16px; height: 16px; }
        .form-control { padding-left: 40px !important; }

        .pw-toggle {
            position: absolute; right: 10px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: #9ca3af; display: flex; align-items: center;
            transition: color .15s;
        }
        .pw-toggle:hover { color: #64748b; }
        .pw-toggle svg { width: 16px; height: 16px; }

        .btn-login {
            width: 100%; padding: 12px; margin-top: 6px;
            background: #2563eb; color: #fff;
            border: none; border-radius: 9px;
            font-family: inherit; font-size: 15px; font-weight: 700;
            cursor: pointer; transition: all .18s;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            box-shadow: 0 4px 14px rgba(37,99,235,.35);
        }
        .btn-login:hover { background: #1d4ed8; transform: translateY(-1px); }
        .btn-login svg { width: 17px; height: 17px; }

        .divider {
            display: flex; align-items: center; gap: 12px;
            margin: 20px 0; color: #94a3b8; font-size: 13px;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1; height: 1px; background: #e2e8f0;
        }

        .register-link {
            text-align: center; font-size: 13.5px; color: #64748b; margin-top: 6px;
        }
        .register-link a { color: #2563eb; font-weight: 700; }

        .admin-link {
            text-align: center; font-size: 12px; color: #94a3b8; margin-top: 20px;
        }
        .admin-link a { color: #64748b; font-weight: 600; }

        @media (max-width: 768px) {
            body { grid-template-columns: 1fr; }
            .login-left { display: none; }
            .login-right { padding: 36px 20px; }
        }
    </style>
</head>
<body>

<!-- Left panel -->
<div class="login-left">
    <div class="dot-grid"></div>

    <div class="left-brand">
        <div class="brand-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                <path d="M6 12v5c3 3 9 3 12 0v-5"/>
            </svg>
        </div>
        <span class="brand-name">InternAdmin</span>
    </div>

    <div class="left-hero">
        <h1>Your internship<br>journey <span>starts here</span></h1>
        <p>Apply for internships matched to your CGPA, track your application status, and take your placement exam — all in one place.</p>
    </div>

    <div class="left-features">
        <div class="feature-row">
            <div class="feature-dot">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="2" y="7" width="20" height="14" rx="2"/>
                    <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                </svg>
            </div>
            <span class="feature-text">Browse internships matching your CGPA</span>
        </div>
        <div class="feature-row">
            <div class="feature-dot">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                    <polyline points="14 2 14 8 20 8"/>
                </svg>
            </div>
            <span class="feature-text">Track application status in real-time</span>
        </div>
        <div class="feature-row">
            <div class="feature-dot">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 11l3 3L22 4"/>
                    <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
                </svg>
            </div>
            <span class="feature-text">Take timed online placement exam</span>
        </div>
    </div>
</div>

<!-- Right panel -->
<div class="login-right">
    <div class="login-box">

        <div class="box-header">
            <h2>Welcome back</h2>
            <p>Sign in to your student account</p>
        </div>

        <!-- Flash: logged out message -->
        <c:if test="${msg == 'loggedOut'}">
            <div class="alert alert-info" style="margin-bottom:16px;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="12" y1="16" x2="12" y2="12"/>
                    <line x1="12" y1="8" x2="12.01" y2="8"/>
                </svg>
                You have been logged out successfully.
            </div>
        </c:if>

        <!-- Error -->
        <c:if test="${not empty error}">
            <div class="alert alert-error" style="margin-bottom:16px;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="12" y1="8" x2="12" y2="12"/>
                    <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student/login" method="post"
              onsubmit="return validateForm()">

            <div class="form-group" style="margin-bottom:14px;">
                <label class="form-label">Email Address</label>
                <div class="input-wrap">
                    <span class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                    </span>
                    <input type="email" name="email" class="form-control"
                           placeholder="Enter your email"
                           value="${f_email}" autocomplete="email" required>
                </div>
            </div>

            <div class="form-group" style="margin-bottom:18px;">
                <label class="form-label">Password</label>
                <div class="input-wrap">
                    <span class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                    </span>
                    <input type="password" name="password" id="password" class="form-control"
                           placeholder="Enter your password"
                           autocomplete="current-password" required>
                    <button type="button" class="pw-toggle" onclick="togglePw()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
            </div>

            <button type="submit" class="btn-login">
                Sign In
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="5" y1="12" x2="19" y2="12"/>
                    <polyline points="12 5 19 12 12 19"/>
                </svg>
            </button>
        </form>

        <div class="divider">or</div>

        <div class="register-link">
            New student?
            <a href="${pageContext.request.contextPath}/student/register">Create an account</a>
        </div>

        <div class="admin-link">
            Admin?
            <a href="${pageContext.request.contextPath}/admin/login">Go to Admin Login</a>
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
