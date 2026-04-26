<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="com.admin.model.Student" %>

<%
// Already logged in → go to dashboard
Student student = (Student) session.getAttribute("student");

if (student != null) {
    response.sendRedirect(request.getContextPath() + "/student/dashboard");
    return;
}

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — InternAdmin Student</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/student-style.css">
    <style>
        body { min-height:100vh; display:flex; flex-direction:column; background:var(--slate-50); }
        .reg-wrap {
            flex:1; display:flex; align-items:center; justify-content:center;
            padding: 36px 16px;
        }
        .reg-card {
            width:100%; max-width:600px;
            background:#fff; border:1px solid var(--slate-200);
            border-radius: var(--r-xl); overflow:hidden;
            box-shadow: var(--shadow-md);
        }
        .reg-head {
            padding: 28px 32px; border-bottom: 1px solid var(--slate-100);
            background: linear-gradient(135deg, #1e3a8a 0%, #1d4ed8 100%);
            text-align: center;
        }
        .reg-head .brand {
            display:inline-flex; align-items:center; gap:10px;
            margin-bottom:16px;
        }
        .reg-head .brand-icon {
            width:38px; height:38px; border-radius:10px;
            background:rgba(255,255,255,.2);
            display:flex; align-items:center; justify-content:center; color:#fff;
        }
        .reg-head .brand-icon svg { width:20px; height:20px; }
        .reg-head .brand-name { font-size:18px; font-weight:800; color:#fff; }
        .reg-head h2 { font-size:20px; font-weight:700; color:#fff; }
        .reg-head p  { font-size:13px; color:rgba(255,255,255,.7); margin-top:5px; }
        .reg-body { padding:28px 32px; }
        .reg-footer {
            padding:18px 32px; border-top:1px solid var(--slate-100);
            background:var(--slate-50); text-align:center;
            font-size:13.5px; color:var(--slate-600);
        }
        .reg-footer a { color:var(--blue); font-weight:600; }
        .login-link {
            display:block; text-align:center;
            margin-top:14px; font-size:13.5px; color:var(--slate-500);
        }
        .login-link a { color:var(--blue); font-weight:600; }
    </style>
</head>
<body>

<div class="reg-wrap">
    <div class="reg-card">

        <!-- Header -->
        <div class="reg-head">
            <div class="brand">
                <div class="brand-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                    </svg>
                </div>
                <span class="brand-name">InternAdmin</span>
            </div>
            <h2>Create Student Account</h2>
            <p>Register to apply for internships</p>
        </div>

        <div class="reg-body">

            <!-- Error alert -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/student/register"
                  method="post" onsubmit="return validateForm()">

                <div class="form-grid-2" style="gap:14px;">

                    <!-- Full Name -->
                    <div class="form-group form-full">
                        <label class="form-label">Full Name <span class="req">*</span></label>
                        <input type="text" name="fullName" class="form-control"
                               placeholder="e.g. Rahul Sharma"
                               value="${f_fullName}" maxlength="150" required>
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label class="form-label">Email Address <span class="req">*</span></label>
                        <input type="email" name="email" class="form-control"
                               placeholder="you@email.com"
                               value="${f_email}" maxlength="150" required>
                    </div>

                    <!-- Roll Number -->
                    <div class="form-group">
                        <label class="form-label">Roll Number <span class="req">*</span></label>
                        <input type="text" name="rollNumber" class="form-control"
                               placeholder="e.g. CS2024001"
                               value="${f_rollNumber}" maxlength="50" required>
                    </div>

                    <!-- Department -->
                    <div class="form-group">
                        <label class="form-label">Department <span class="req">*</span></label>
                        <select name="department" class="form-control" required>
                            <option value="">-- Select Department --</option>
                            <option value="Computer Science">Computer Science</option>
 						    <option value="Information Technology">Information Technology</option>
    						<option value="Electronics">Electronics</option>
    						<option value="Mechanical">Mechanical</option>
						    <option value="Civil">Civil</option>
    						<option value="Electrical">Electrical</option>
    						<option value="Chemical">Chemical</option>
    						<option value="MBA">MBA</option>
    						<option value="MCA">MCA</option>
    						<option value="Other">Other</option>
                            <option value="${dept}" ${f_department == dept ? 'selected' : ''}>${dept}</option>
                        </select>
                    </div>

                    <!-- CGPA -->
                    <div class="form-group">
                        <label class="form-label">CGPA <span class="req">*</span></label>
                        <input type="number" name="cgpa" class="form-control"
                               placeholder="e.g. 8.5" min="0" max="10" step="0.01"
                               value="${f_cgpa}" required>
                        <span class="form-hint">Scale of 0.00 to 10.00</span>
                    </div>

                    <!-- Mobile -->
                    <div class="form-group">
                        <label class="form-label">Mobile Number <span class="req">*</span></label>
                        <input type="text" name="mobile" class="form-control"
                               placeholder="10-digit number"
                               value="${f_mobile}" maxlength="10" required>
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <label class="form-label">Password <span class="req">*</span></label>
                        <div style="position:relative;">
                            <input type="password" name="password" id="password"
                                   class="form-control"
                                   placeholder="Min. 6 characters"
                                   minlength="6" required style="padding-right:40px;">
                            <button type="button" onclick="togglePw('password')"
                                    style="position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:var(--slate-400);">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <label class="form-label">Confirm Password <span class="req">*</span></label>
                        <div style="position:relative;">
                            <input type="password" name="confirmPassword" id="confirmPassword"
                                   class="form-control"
                                   placeholder="Re-enter password"
                                   required style="padding-right:40px;">
                            <button type="button" onclick="togglePw('confirmPassword')"
                                    style="position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:var(--slate-400);">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                            </button>
                        </div>
                    </div>

                </div><!-- /grid -->

                <div style="margin-top:20px;">
                    <button type="submit" class="btn btn-primary"
                            style="width:100%;justify-content:center;padding:12px;font-size:15px;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="8.5" cy="7" r="4"/>
                            <line x1="20" y1="8" x2="20" y2="14"/>
                            <line x1="23" y1="11" x2="17" y2="11"/>
                        </svg>
                        Create Account
                    </button>
                </div>

                <div class="login-link">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/student/login">Sign in here</a>
                </div>

            </form>
        </div>

    </div>
</div>

<script>
function togglePw(id) {
    const el = document.getElementById(id);
    el.type = el.type === 'password' ? 'text' : 'password';
}

function validateForm() {
    const name  = document.querySelector('[name="fullName"]').value.trim();
    const email = document.querySelector('[name="email"]').value.trim();
    const roll  = document.querySelector('[name="rollNumber"]').value.trim();
    const dept  = document.querySelector('[name="department"]').value;
    const cgpa  = parseFloat(document.querySelector('[name="cgpa"]').value);
    const mob   = document.querySelector('[name="mobile"]').value.trim();
    const pw    = document.getElementById('password').value;
    const cpw   = document.getElementById('confirmPassword').value;

    if (!name)              { alert('Full name is required.');             return false; }
    if (!email)             { alert('Email is required.');                 return false; }
    if (!email.includes('@')){ alert('Enter a valid email address.');      return false; }
    if (!roll)              { alert('Roll number is required.');           return false; }
    if (!dept)              { alert('Please select your department.');     return false; }
    if (isNaN(cgpa) || cgpa < 0 || cgpa > 10) { alert('CGPA must be between 0 and 10.'); return false; }
    if (!/^\d{10}$/.test(mob)) { alert('Mobile must be exactly 10 digits.'); return false; }
    if (pw.length < 6)     { alert('Password must be at least 6 characters.'); return false; }
    if (pw !== cpw)        { alert('Passwords do not match.');             return false; }
    return true;
}
</script>
</body>
</html>
