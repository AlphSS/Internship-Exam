package com.admin.controller;

import com.admin.dao.ExamDAO;
import com.admin.dao.QuestionDAO;
import com.admin.model.Exam;
import com.admin.model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * AddQuestionServlet
 * GET  -> shows addQuestions.jsp for a specific exam
 * POST -> validates and saves a new MCQ question to the exam
 */
@WebServlet("/admin/addQuestion")
public class AddQuestionServlet extends HttpServlet {

    private final QuestionDAO questionDAO = new QuestionDAO();
    private final ExamDAO     examDAO     = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String examIdStr = request.getParameter("examId");
        if (examIdStr == null || examIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manageExams");
            return;
        }

        int  examId = Integer.parseInt(examIdStr.trim());
        Exam exam   = examDAO.getExamById(examId);
        if (exam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/manageExams?msg=notFound");
            return;
        }

        List<Question> questions = questionDAO.getQuestionsByExam(examId);
        request.setAttribute("exam", exam);
        request.setAttribute("questions", questions);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("msg", msg);

        request.getRequestDispatcher("/jsp/admin/addQuestions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String examIdStr      = request.getParameter("examId");
        String questionText   = request.getParameter("questionText");
        String optionA        = request.getParameter("optionA");
        String optionB        = request.getParameter("optionB");
        String optionC        = request.getParameter("optionC");
        String optionD        = request.getParameter("optionD");
        String correctOption  = request.getParameter("correctOption");
        String marksStr       = request.getParameter("marks");

        int examId = Integer.parseInt(examIdStr != null ? examIdStr.trim() : "0");

        // Validate
        if (questionText == null || questionText.trim().isEmpty()
                || optionA == null || optionA.trim().isEmpty()
                || optionB == null || optionB.trim().isEmpty()
                || optionC == null || optionC.trim().isEmpty()
                || optionD == null || optionD.trim().isEmpty()
                || correctOption == null || correctOption.trim().isEmpty()) {

            Exam exam = examDAO.getExamById(examId);
            List<Question> questions = questionDAO.getQuestionsByExam(examId);
            request.setAttribute("exam", exam);
            request.setAttribute("questions", questions);
            request.setAttribute("error", "All fields are required. Please fill in every option and select the correct answer.");
            request.getRequestDispatcher("/jsp/admin/addQuestions.jsp").forward(request, response);
            return;
        }

        try {
            int marks = Integer.parseInt(marksStr != null ? marksStr.trim() : "1");

            Question q = new Question();
            q.setExamId(examId);
            q.setQuestionText(questionText.trim());
            q.setOptionA(optionA.trim());
            q.setOptionB(optionB.trim());
            q.setOptionC(optionC.trim());
            q.setOptionD(optionD.trim());
            q.setCorrectOption(correctOption.toUpperCase().charAt(0));
            q.setMarks(marks);

            boolean success = questionDAO.addQuestion(q);
            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/addQuestion?examId=" + examId + "&msg=questionAdded");
            } else {
                Exam exam = examDAO.getExamById(examId);
                List<Question> questions = questionDAO.getQuestionsByExam(examId);
                request.setAttribute("exam", exam);
                request.setAttribute("questions", questions);
                request.setAttribute("error", "Failed to add question. Please try again.");
                request.getRequestDispatcher("/jsp/admin/addQuestions.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/addQuestion?examId=" + examId + "&msg=error");
        }
    }
}
