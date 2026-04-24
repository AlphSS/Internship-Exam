package com.admin.controller;

import com.admin.dao.ExamDAO;
import com.admin.dao.ResultDAO;
import com.admin.model.Exam;
import com.admin.model.Result;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * ViewResultsServlet
 * GET  -> if examId param present, shows results for that exam;
 *          otherwise shows all results across all exams.
 */
@WebServlet("/admin/viewResults")
public class ViewResultsServlet extends HttpServlet {

    private final ResultDAO resultDAO = new ResultDAO();
    private final ExamDAO   examDAO   = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String examIdStr = request.getParameter("examId");

        if (examIdStr != null && !examIdStr.trim().isEmpty()) {
            // Results for a specific exam
            int examId    = Integer.parseInt(examIdStr.trim());
            Exam exam     = examDAO.getExamById(examId);
            List results  = resultDAO.getResultsByExam(examId);
            request.setAttribute("exam", exam);
            request.setAttribute("results", results);
            request.setAttribute("filterMode", "exam");
        } else {
            // All results across all exams
            List results = resultDAO.getAllResults();
            request.setAttribute("results", results);
            request.setAttribute("filterMode", "all");
        }

        List<Exam> allExams = examDAO.getAllExams();
        request.setAttribute("allExams", allExams);

        request.getRequestDispatcher("/jsp/admin/viewResults.jsp").forward(request, response);
    }
}
