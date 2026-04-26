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
 * StudentLoginServlet
 * GET  → shows login.jsp (or redirects to dashboard if already logged in)
 * POST → validates credentials via StudentDAO.login(), creates session,
 *         and redirects to student dashboard.
 *
 * Role enforcement: only users with role='student' can log in here.
 * Admin accounts are rejected even if credentials are correct.
 */
@WebServlet("/student/login")
public class StudentLoginServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Already logged in → skip login page
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("studentId") != null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("msg", msg);

        request.getRequestDispatcher("/jsp/student/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email")    != null ? request.getParameter("email").trim()    : "";
        String password = request.getParameter("password") != null ? request.getParameter("password").trim() : "";

        // Basic field check
        if (email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.setAttribute("f_email", email);
            request.getRequestDispatcher("/jsp/student/login.jsp").forward(request, response);
            return;
        }

        // Validate credentials — StudentDAO enforces role='student'
        Student student = studentDAO.login(email, password);

        if (student != null) {
            // ── Create session ──────────────────────────────────────────
            HttpSession session = request.getSession();
            session.setAttribute("studentId",   student.getStudentId());
            session.setAttribute("studentName", student.getFullName());
            session.setAttribute("student",     student);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        } else {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.setAttribute("f_email", email);
            request.getRequestDispatcher("/jsp/student/login.jsp").forward(request, response);
        }
    }
}
