<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    <title>Add Questions — InternAdmin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <style>
        .option-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }
        .option-label-row {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .option-tag {
            width: 26px; height: 26px;
            border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 12px; font-weight: 700;
            flex-shrink: 0;
        }
        .opt-a { background: var(--blue-light);   color: var(--blue-dark); }
        .opt-b { background: var(--green-light);  color: var(--green-dark); }
        .opt-c { background: var(--amber-light);  color: var(--amber-dark); }
        .opt-d { background: var(--violet-light); color: var(--violet); }

        .correct-selector {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }
        .correct-opt {
            border: 2px solid var(--border);
            border-radius: var(--r-md);
            padding: 10px 8px;
            text-align: center;
            cursor: pointer;
            transition: all .15s;
            font-size: 13px;
            font-weight: 600;
        }
        .correct-opt:hover { border-color: var(--blue); }
        .correct-opt.active { border-color: var(--green-dark); background: var(--green-light); color: var(--green-dark); }

        .q-card {
            background: var(--bg);
            border: 1px solid var(--border-light);
            border-radius: var(--r-md);
            padding: 16px;
            margin-bottom: 10px;
        }
        .q-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 8px;
        }
        .q-text { font-size: 14px; font-weight: 600; color: var(--text-primary); flex: 1; }
        .q-meta { font-size: 12px; color: var(--text-muted); }
        .q-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px;
            margin-top: 8px;
        }
        .q-option {
            font-size: 13px;
            color: var(--text-secondary);
            padding: 4px 0;
            display: flex;
            gap: 6px;
            align-items: flex-start;
        }
        .q-option.correct { color: var(--green-dark); font-weight: 600; }
        .q-option-key { font-weight: 700; width: 16px; flex-shrink: 0; }
    </style>
</head>
<body>
<div class="layout">
<%@ include file="sidebar.jspf" %>
<div class="main-wrap">

    <header class="topbar">
        <div>
            <div class="topbar-title">Add Questions</div>
            <div class="topbar-breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/manageExams">Exams</a>
                <span>/</span> ${exam.examTitle}
            </div>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/manageExams" class="btn btn-ghost">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
                </svg>
                Back to Exams
            </a>
        </div>
    </header>

    <div class="page-content">

        <!-- Exam summary bar -->
        <div class="card" style="margin-bottom:20px;">
            <div class="card-body" style="display:flex;gap:32px;align-items:center;flex-wrap:wrap;padding:16px 22px;">
                <div>
                    <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:var(--text-muted);">Exam</div>
                    <div style="font-size:15px;font-weight:700;color:var(--text-primary);margin-top:2px;">${exam.examTitle}</div>
                </div>
                <div>
                    <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:var(--text-muted);">Internship</div>
                    <div style="font-size:14px;color:var(--text-secondary);margin-top:2px;">${exam.internshipTitle}</div>
                </div>
                <div>
                    <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:var(--text-muted);">Duration</div>
                    <div style="font-size:14px;color:var(--text-secondary);margin-top:2px;">${exam.duration} minutes</div>
                </div>
                <div>
                    <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:var(--text-muted);">Questions</div>
                    <div style="font-size:20px;font-weight:800;color:var(--blue-dark);font-family:'JetBrains Mono',monospace;margin-top:2px;">${fn:length(questions)}</div>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                ${error}
            </div>
        </c:if>
        <c:if test="${msg == 'questionAdded'}">
            <div class="alert alert-success">
                <svg class="alert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                Question added successfully.
            </div>
        </c:if>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:22px;align-items:start;">

            <!-- Add question form -->
            <div class="form-card">
                <div class="form-card-head">
                    <h3>New MCQ Question</h3>
                    <p>Add one question at a time. All fields are required.</p>
                </div>
                <form action="${pageContext.request.contextPath}/admin/addQuestion" method="post"
                      onsubmit="return validateQuestion()">
                    <input type="hidden" name="examId" value="${exam.examId}">
                    <div class="form-body">

                        <div class="form-group">
                            <label class="form-label">Question Text <span class="req">*</span></label>
                            <textarea name="questionText" id="questionText" class="form-control"
                                      rows="3" placeholder="Enter the question..."></textarea>
                        </div>

                        <div class="section-heading" style="margin-top:16px;">Options</div>
                        <div class="option-grid">
                            <div class="form-group">
                                <label class="form-label">
                                    <span class="option-label-row">
                                        <span class="option-tag opt-a">A</span> Option A
                                    </span>
                                </label>
                                <input type="text" name="optionA" id="optA" class="form-control" placeholder="Option A" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">
                                    <span class="option-label-row">
                                        <span class="option-tag opt-b">B</span> Option B
                                    </span>
                                </label>
                                <input type="text" name="optionB" id="optB" class="form-control" placeholder="Option B" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">
                                    <span class="option-label-row">
                                        <span class="option-tag opt-c">C</span> Option C
                                    </span>
                                </label>
                                <input type="text" name="optionC" id="optC" class="form-control" placeholder="Option C" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">
                                    <span class="option-label-row">
                                        <span class="option-tag opt-d">D</span> Option D
                                    </span>
                                </label>
                                <input type="text" name="optionD" id="optD" class="form-control" placeholder="Option D" required>
                            </div>
                        </div>

                        <div class="form-group" style="margin-top:4px;">
                            <label class="form-label">Correct Answer <span class="req">*</span></label>
                            <input type="hidden" name="correctOption" id="correctOption" value="">
                            <div class="correct-selector">
                                <div class="correct-opt" id="ca-A" onclick="selectCorrect('A')">A</div>
                                <div class="correct-opt" id="ca-B" onclick="selectCorrect('B')">B</div>
                                <div class="correct-opt" id="ca-C" onclick="selectCorrect('C')">C</div>
                                <div class="correct-opt" id="ca-D" onclick="selectCorrect('D')">D</div>
                            </div>
                        </div>

                        <div class="form-group" style="max-width:130px;margin-top:4px;">
                            <label class="form-label">Marks</label>
                            <input type="number" name="marks" class="form-control" value="1" min="1" max="10">
                        </div>

                    </div>
                    <div class="form-footer">
                        <button type="submit" class="btn btn-primary">Add Question</button>
                        <button type="reset" class="btn btn-ghost" onclick="resetForm()">Clear</button>
                    </div>
                </form>
            </div>

            <!-- Existing questions list -->
            <div>
                <div class="section-heading">Added Questions (${fn:length(questions)})</div>
                <c:choose>
                    <c:when test="${empty questions}">
                        <div style="text-align:center;padding:40px;color:var(--text-muted);background:var(--surface);border:1px solid var(--border);border-radius:var(--r-lg);">
                            <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" opacity=".3" style="display:block;margin:0 auto 10px;">
                                <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                            </svg>
                            <p style="font-size:14px;font-weight:500;">No questions yet. Add your first question.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="q" items="${questions}" varStatus="s">
                            <div class="q-card">
                                <div class="q-card-header">
                                    <div class="q-text">Q${s.count}. ${q.questionText}</div>
                                    <div class="q-meta">${q.marks} mark${q.marks != 1 ? 's' : ''}</div>
                                </div>
                                <div class="q-options">
                                    <div class="q-option ${q.correctOption == 'A' ? 'correct' : ''}">
                                        <span class="q-option-key">A.</span> ${q.optionA}
                                    </div>
                                    <div class="q-option ${q.correctOption == 'B' ? 'correct' : ''}">
                                        <span class="q-option-key">B.</span> ${q.optionB}
                                    </div>
                                    <div class="q-option ${q.correctOption == 'C' ? 'correct' : ''}">
                                        <span class="q-option-key">C.</span> ${q.optionC}
                                    </div>
                                    <div class="q-option ${q.correctOption == 'D' ? 'correct' : ''}">
                                        <span class="q-option-key">D.</span> ${q.optionD}
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</div>
</div>
<script>
function selectCorrect(opt) {
    ['A','B','C','D'].forEach(o => document.getElementById('ca-'+o).classList.remove('active'));
    document.getElementById('ca-'+opt).classList.add('active');
    document.getElementById('correctOption').value = opt;
}
function resetForm() {
    ['A','B','C','D'].forEach(o => document.getElementById('ca-'+o).classList.remove('active'));
    document.getElementById('correctOption').value = '';
}
function validateQuestion() {
    const q   = document.getElementById('questionText').value.trim();
    const a   = document.getElementById('optA').value.trim();
    const b   = document.getElementById('optB').value.trim();
    const c   = document.getElementById('optC').value.trim();
    const d   = document.getElementById('optD').value.trim();
    const cor = document.getElementById('correctOption').value;
    if (!q) { alert('Question text is required.'); return false; }
    if (!a || !b || !c || !d) { alert('All four options are required.'); return false; }
    if (!cor) { alert('Please select the correct answer (A, B, C or D).'); return false; }
    return true;
}
</script>
</body>
</html>
