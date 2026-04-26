package com.admin.controller.student;

import com.admin.dao.StudentApplicationDAO;
import com.admin.dao.StudentInternshipDAO;
import com.admin.model.Application;
import com.admin.model.Internship;
import com.admin.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * StudentDashboardServlet
 * GET → loads the student dashboard with:
 *   - Profile summary
 *   - Application statistics (total, pending, selected)
 *   - Recent applications (last 3)
 *   - Eligible internships count
 */
@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private final StudentApplicationDAO appDAO       = new StudentApplicationDAO();
    private final StudentInternshipDAO  internDAO    = new StudentInternshipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Session guard ──────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/student/login");
            return;
        }

        int     studentId   = (int)    session.getAttribute("studentId");
        Student student     = (Student) session.getAttribute("student");
        double  studentCgpa = student != null ? student.getCgpa() : 0.0;

        // ── Load dashboard data ────────────────────────────────────────────
        List<Application> allApps       = appDAO.getApplicationsByStudent(studentId);
        int               totalApps     = allApps.size();
        int               selectedCount = appDAO.countSelectedByStudent(studentId);
        int               pendingCount  = (int) allApps.stream()
                                            .filter(a -> "pending".equals(a.getStatus()))
                                            .count();

        // Recent 3 applications for dashboard preview
        List<Application> recentApps = allApps.size() > 3
                ? allApps.subList(0, 3) : allApps;

        // Eligible internships count
        List<Internship> eligible = internDAO.getEligibleInternships(studentCgpa, studentId);
        long eligibleCount = eligible.stream()
                .filter(i -> !"applied".equals(i.getStatus()))
                .count();

        // ── Set attributes ─────────────────────────────────────────────────
        request.setAttribute("student",        student);
        request.setAttribute("totalApps",      totalApps);
        request.setAttribute("selectedCount",  selectedCount);
        request.setAttribute("pendingCount",   pendingCount);
        request.setAttribute("recentApps",     recentApps);
        request.setAttribute("eligibleCount",  eligibleCount);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("msg", msg);

        request.getRequestDispatcher("/jsp/student/student_dashboard.jsp")
               .forward(request, response);
    }
}
