package com.admin.controller;

import com.admin.dao.ApplicationDAO;
import com.admin.model.Application;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/processApplication")
public class ProcessApplicationServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    // GET — show application detail page with action form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/viewApplications");
            return;
        }

        int applicationId       = Integer.parseInt(idParam);
        Application application = applicationDAO.getApplicationById(applicationId);

        if (application == null) {
            response.sendRedirect(request.getContextPath() + "/admin/viewApplications?msg=notfound");
            return;
        }

        request.setAttribute("application", application);
        request.getRequestDispatcher("/jsp/admin/processApplication.jsp")
               .forward(request, response);
    }

    // POST — update application status with JDBC transaction (commit/rollback in DAO)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String idParam = request.getParameter("applicationId");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/viewApplications");
            return;
        }

        int    applicationId = Integer.parseInt(idParam);
        String newStatus     = request.getParameter("status");
        String remarks       = request.getParameter("remarks") != null
                             ? request.getParameter("remarks").trim() : "";
        String adminUser     = (String) session.getAttribute("adminUser");

        // Validate allowed status values
        if (!"shortlisted".equals(newStatus)
                && !"selected".equals(newStatus)
                && !"rejected".equals(newStatus)) {

            request.setAttribute("error", "Invalid status selected.");
            Application application = applicationDAO.getApplicationById(applicationId);
            request.setAttribute("application", application);
            request.getRequestDispatcher("/jsp/admin/processApplication.jsp")
                   .forward(request, response);
            return;
        }

        // Delegate to DAO — transaction commit/rollback handled inside
        boolean success = applicationDAO.processApplication(
                applicationId, newStatus, remarks, adminUser);

        if (success) {
            response.sendRedirect(request.getContextPath()
                + "/admin/viewApplications?msg=" + newStatus);
        } else {
            request.setAttribute("error", "Failed to process application. Please try again.");
            Application application = applicationDAO.getApplicationById(applicationId);
            request.setAttribute("application", application);
            request.getRequestDispatcher("/jsp/admin/processApplication.jsp")
                   .forward(request, response);
        }
    }
}
