package com.admin.controller.student;

import com.admin.dao.StudentApplicationDAO;
import com.admin.dao.StudentInternshipDAO;
import com.admin.model.Internship;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * ApplyInternshipServlet
 * POST → validates and submits a new internship application.
 *
 * Uses StudentApplicationDAO.applyForInternship() which runs a full
 * JDBC transaction (commit/rollback) and handles:
 *   - Duplicate prevention
 *   - Internship status check (must be 'open')
 *   - CGPA eligibility validation (server-side)
 */
@WebServlet("/student/apply")
public class ApplyInternshipServlet extends HttpServlet {

    private final StudentApplicationDAO appDAO    = new StudentApplicationDAO();
    private final StudentInternshipDAO  internDAO = new StudentInternshipDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/student/login");
            return;
        }

        int    studentId   = (int) session.getAttribute("studentId");
        double studentCgpa = 0.0;
        if (session.getAttribute("student") != null) {
            com.admin.model.Student s = (com.admin.model.Student) session.getAttribute("student");
            studentCgpa = s.getCgpa();
        }

        String internshipIdStr = request.getParameter("internshipId");
        if (internshipIdStr == null || internshipIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/student/internships?msg=invalidRequest");
            return;
        }

        int internshipId;
        try {
            internshipId = Integer.parseInt(internshipIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/student/internships?msg=invalidRequest");
            return;
        }

        // ── Server-side CGPA eligibility check ────────────────────────────
        Internship internship = internDAO.getInternshipById(internshipId);
        if (internship == null) {
            response.sendRedirect(request.getContextPath()
                    + "/student/internships?msg=notFound");
            return;
        }
        if (studentCgpa < internship.getMinCgpa()) {
            response.sendRedirect(request.getContextPath()
                    + "/student/internships?msg=cgpaNotMet");
            return;
        }

        // ── Submit application (transaction inside DAO) ────────────────────
        String result = appDAO.applyForInternship(studentId, internshipId);

        switch (result) {
            case "success":
                response.sendRedirect(request.getContextPath()
                        + "/student/applications?msg=applied");
                break;
            case "duplicate":
                response.sendRedirect(request.getContextPath()
                        + "/student/internships?msg=alreadyApplied");
                break;
            case "closed":
                response.sendRedirect(request.getContextPath()
                        + "/student/internships?msg=internshipClosed");
                break;
            default:
                response.sendRedirect(request.getContextPath()
                        + "/student/internships?msg=applyError");
                break;
        }
    }

    // GET is not supported — direct URL access redirects to internship list
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/student/internships");
    }
}
