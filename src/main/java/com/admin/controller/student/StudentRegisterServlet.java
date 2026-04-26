package com.admin.controller.student;

import com.admin.dao.StudentDAO;
import com.admin.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * StudentRegisterServlet
 * GET  → shows register.jsp
 * POST → validates input, calls StudentDAO.registerStudent() (JDBC transaction),
 *         then auto-logs the student in and redirects to dashboard
 */
@WebServlet("/student/register")
public class StudentRegisterServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Already logged in → go to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("studentId") != null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }
        request.getRequestDispatcher("/jsp/student/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Read & trim parameters ─────────────────────────────────────────
        String fullName    = trim(request.getParameter("fullName"));
        String email       = trim(request.getParameter("email"));
        String password    = trim(request.getParameter("password"));
        String confirmPass = trim(request.getParameter("confirmPassword"));
        String rollNumber  = trim(request.getParameter("rollNumber"));
        String department  = trim(request.getParameter("department"));
        String cgpaStr     = trim(request.getParameter("cgpa"));
        String mobile      = trim(request.getParameter("mobile"));

        // ── Validation ────────────────────────────────────────────────────
        String error = validate(fullName, email, password, confirmPass,
                                rollNumber, department, cgpaStr, mobile);
        if (error != null) {
            request.setAttribute("error", error);
            // Re-populate form fields so user doesn't lose their input
            repopulate(request, fullName, email, rollNumber, department, cgpaStr, mobile);
            request.getRequestDispatcher("/jsp/student/register.jsp").forward(request, response);
            return;
        }

        // ── Check duplicates before hitting the DB transaction ─────────────
        if (studentDAO.emailExists(email)) {
            request.setAttribute("error", "This email is already registered. Please login.");
            repopulate(request, fullName, email, rollNumber, department, cgpaStr, mobile);
            request.getRequestDispatcher("/jsp/student/register.jsp").forward(request, response);
            return;
        }
        if (studentDAO.rollNumberExists(rollNumber)) {
            request.setAttribute("error", "This roll number is already registered.");
            repopulate(request, fullName, email, rollNumber, department, cgpaStr, mobile);
            request.getRequestDispatcher("/jsp/student/register.jsp").forward(request, response);
            return;
        }

        // ── Build model ───────────────────────────────────────────────────
        double cgpa = Double.parseDouble(cgpaStr);
        Student student = new Student();
        student.setFullName(fullName);
        student.setEmail(email);
        student.setPassword(password); // hash in production (BCrypt)
        student.setRollNumber(rollNumber);
        student.setDepartment(department);
        student.setCgpa(cgpa);
        student.setMobile(mobile);

        // ── Register (transaction: students + users tables) ───────────────
        boolean success = studentDAO.registerStudent(student);

        if (success) {
            // Auto-login: fetch the student back and create session
            Student registered = studentDAO.login(email, password);
            if (registered != null) {
                HttpSession session = request.getSession();
                session.setAttribute("studentId",   registered.getStudentId());
                session.setAttribute("studentName", registered.getFullName());
                session.setAttribute("student",     registered);
                session.setMaxInactiveInterval(30 * 60);
            }
            response.sendRedirect(request.getContextPath()
                    + "/student/dashboard?msg=registered");
        } else {
            request.setAttribute("error",
                "Registration failed. Email or roll number may already be taken.");
            repopulate(request, fullName, email, rollNumber, department, cgpaStr, mobile);
            request.getRequestDispatcher("/jsp/student/register.jsp").forward(request, response);
        }
    }

    // ── Validation ────────────────────────────────────────────────────────
    private String validate(String fullName, String email, String password,
                            String confirmPass, String rollNumber, String department,
                            String cgpaStr, String mobile) {
        if (fullName.isEmpty())    return "Full name is required.";
        if (email.isEmpty())       return "Email is required.";
        if (!email.contains("@")) return "Please enter a valid email address.";
        if (password.isEmpty())    return "Password is required.";
        if (password.length() < 6) return "Password must be at least 6 characters.";
        if (!password.equals(confirmPass)) return "Passwords do not match.";
        if (rollNumber.isEmpty())  return "Roll number is required.";
        if (department.isEmpty())  return "Department is required.";
        if (cgpaStr.isEmpty())     return "CGPA is required.";
        try {
            double cgpa = Double.parseDouble(cgpaStr);
            if (cgpa < 0 || cgpa > 10) return "CGPA must be between 0.00 and 10.00.";
        } catch (NumberFormatException e) {
            return "CGPA must be a valid decimal number (e.g. 8.5).";
        }
        if (mobile.isEmpty())      return "Mobile number is required.";
        if (!mobile.matches("\\d{10}")) return "Mobile must be exactly 10 digits.";
        return null; // no error
    }

    private void repopulate(HttpServletRequest req, String fullName, String email,
                            String rollNumber, String department, String cgpa, String mobile) {
        req.setAttribute("f_fullName",   fullName);
        req.setAttribute("f_email",      email);
        req.setAttribute("f_rollNumber", rollNumber);
        req.setAttribute("f_department", department);
        req.setAttribute("f_cgpa",       cgpa);
        req.setAttribute("f_mobile",     mobile);
    }

    private String trim(String s) { return s != null ? s.trim() : ""; }
}
