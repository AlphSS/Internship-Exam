package com.admin.controller;

import com.admin.dao.ReportDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/studentsPerCompany")
public class StudentsPerCompanyServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Each String[] = { companyName, selectedCount }
        List<String[]> report = reportDAO.getStudentsSelectedPerCompany();
        request.setAttribute("report", report);

        request.getRequestDispatcher("/jsp/admin/studentsPerCompany.jsp")
               .forward(request, response);
    }
}
