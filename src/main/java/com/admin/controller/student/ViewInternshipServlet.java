package com.admin.controller.student;

import com.admin.dao.StudentApplicationDAO;
import com.admin.dao.StudentInternshipDAO;
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
 * ViewInternshipServlet
 * GET → lists all open internships with CGPA-based eligibility filter.
 *       Supports filter toggle: eligible-only or all open.
 */
@WebServlet("/student/internships")
public class ViewInternshipServlet extends HttpServlet {

    private final StudentInternshipDAO internDAO = new StudentInternshipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/student/login");
            return;
        }

        int     studentId   = (int)    session.getAttribute("studentId");
        Student student     = (Student) session.getAttribute("student");
        double  studentCgpa = student != null ? student.getCgpa() : 0.0;

        // Filter param: "eligible" (default) or "all"
        String filter = request.getParameter("filter");
        boolean showAll = "all".equals(filter);

        List<Internship> internships;
        if (showAll) {
            internships = internDAO.getAllOpenInternships(studentId);
        } else {
            internships = internDAO.getEligibleInternships(studentCgpa, studentId);
        }

        // Flash messages from apply action
        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("msg", msg);

        request.setAttribute("internships",  internships);
        request.setAttribute("studentCgpa",  studentCgpa);
        request.setAttribute("filter",       showAll ? "all" : "eligible");

        request.getRequestDispatcher("/jsp/student/internships.jsp").forward(request, response);
    }
}
