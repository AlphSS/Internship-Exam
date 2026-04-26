package com.admin.controller.student;

import com.admin.dao.StudentApplicationDAO;
import com.admin.model.Application;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * StudentViewApplicationsServlet
 * GET → loads all applications by the logged-in student with full status info.
 * URL: /student/applications
 */
@WebServlet("/student/applications")
public class StudentViewApplicationsServlet extends HttpServlet {

    private final StudentApplicationDAO appDAO = new StudentApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/student/login");
            return;
        }

        int studentId = (int) session.getAttribute("studentId");

        List<Application> applications = appDAO.getApplicationsByStudent(studentId);
        request.setAttribute("applications", applications);

        // Flash messages
        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("msg", msg);

        request.getRequestDispatcher("/jsp/student/applications.jsp").forward(request, response);
    }
}
