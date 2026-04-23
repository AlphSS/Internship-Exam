package com.admin.controller;

import com.admin.dao.ReportDAO;
import com.admin.dao.CompanyDAO;
import com.admin.model.Company;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

/**
 * Displays the Admin Dashboard with summary statistics.
 * Requires an active admin session.
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Session Guard ──────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Load summary counts for dashboard cards
        Map<String, Integer> summary = reportDAO.getDashboardSummary();
        request.setAttribute("summary", summary);

        request.getRequestDispatcher("/jsp/admin/adminDashboard.jsp")
               .forward(request, response);
    }
}
