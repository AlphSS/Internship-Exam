package com.admin.controller;

import com.admin.dao.ExamDAO;
import com.admin.dao.InternshipDAO;
import com.admin.model.Exam;
import com.admin.model.Internship;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * AddExamServlet
 * GET  -> shows addExam.jsp with available internships (no exam yet)
 * POST -> validates and saves new exam linked to an internship
 */
@WebServlet("/admin/addExam")
public class AddExamServlet extends HttpServlet {

    private final ExamDAO        examDAO        = new ExamDAO();
    private final InternshipDAO  internshipDAO  = new InternshipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        loadAvailableInternships(request);
        request.getRequestDispatcher("/jsp/admin/addExam.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String internshipIdStr = request.getParameter("internshipId");
        String examTitle       = request.getParameter("examTitle");
        String durationStr     = request.getParameter("duration");

        // Server-side validation
        if (internshipIdStr == null || internshipIdStr.trim().isEmpty()) {
            loadAvailableInternships(request);
            request.setAttribute("error", "Please select an internship.");
            request.getRequestDispatcher("/jsp/admin/addExam.jsp").forward(request, response);
            return;
        }
        if (examTitle == null || examTitle.trim().isEmpty()) {
            loadAvailableInternships(request);
            request.setAttribute("error", "Exam title is required.");
            request.getRequestDispatcher("/jsp/admin/addExam.jsp").forward(request, response);
            return;
        }

        try {
            int duration = Integer.parseInt(durationStr != null ? durationStr.trim() : "30");
            if (duration < 1 || duration > 300) {
                loadAvailableInternships(request);
                request.setAttribute("error", "Duration must be between 1 and 300 minutes.");
                request.getRequestDispatcher("/jsp/admin/addExam.jsp").forward(request, response);
                return;
            }

            Exam exam = new Exam();
            exam.setInternshipId(Integer.parseInt(internshipIdStr.trim()));
            exam.setExamTitle(examTitle.trim());
            exam.setDuration(duration);

            boolean success = examDAO.addExam(exam);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/manageExams?msg=examAdded");
            } else {
                loadAvailableInternships(request);
                request.setAttribute("error", "Failed to create exam. This internship may already have an exam.");
                request.getRequestDispatcher("/jsp/admin/addExam.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            loadAvailableInternships(request);
            request.setAttribute("error", "Invalid duration value. Please enter a number.");
            request.getRequestDispatcher("/jsp/admin/addExam.jsp").forward(request, response);
        }
    }

    // Load internships that do NOT already have an exam
    private void loadAvailableInternships(HttpServletRequest request) {
        List<Integer> usedIds   = examDAO.getInternshipIdsWithExam();
        List<Internship> all    = internshipDAO.getAllInternships();
        List<Internship> avail  = new ArrayList<>();
        for (Internship i : all) {
            if (!usedIds.contains(i.getInternshipId())) {
                avail.add(i);
            }
        }
        request.setAttribute("availableInternships", avail);
    }
}
