package com.admin.controller;

import com.admin.dao.CompanyDAO;
import com.admin.dao.InternshipDAO;
import com.admin.model.Company;
import com.admin.model.Internship;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * AddInternshipServlet
 * GET  → loads the add internship form with company dropdown
 * POST → validates input and inserts a new internship record
 */
@WebServlet("/admin/addInternship")
public class AddInternshipServlet extends HttpServlet {

    private final InternshipDAO internshipDAO = new InternshipDAO();
    private final CompanyDAO    companyDAO    = new CompanyDAO();

    // ── GET ────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Load all companies for the dropdown
        List<Company> companies = companyDAO.getAllCompanies();
        request.setAttribute("companies", companies);

        request.getRequestDispatcher("/jsp/admin/addInternship.jsp")
               .forward(request, response);
    }

    // ── POST ───────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Re-load companies in case we need to forward back with an error
        List<Company> companies = companyDAO.getAllCompanies();

        try {
            // ── Read form parameters ──────────────────────────────────────
            String companyIdStr     = request.getParameter("companyId");
            String title            = request.getParameter("title");
            String description      = request.getParameter("description");
            String stipendStr       = request.getParameter("stipend");
            String durationStr      = request.getParameter("durationMonths");
            String minCgpaStr       = request.getParameter("minCgpa");
            String vacanciesStr     = request.getParameter("vacancies");
            String startDate        = request.getParameter("startDate");
            String endDate          = request.getParameter("endDate");
            String status           = request.getParameter("status");

            // ── Server-side validation ────────────────────────────────────
            if (companyIdStr == null || companyIdStr.trim().isEmpty()) {
                request.setAttribute("companies", companies);
                request.setAttribute("error", "Please select a company.");
                request.getRequestDispatcher("/jsp/admin/addInternship.jsp").forward(request, response);
                return;
            }

            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("companies", companies);
                request.setAttribute("error", "Internship title is required.");
                request.getRequestDispatcher("/jsp/admin/addInternship.jsp").forward(request, response);
                return;
            }

            double minCgpa = Double.parseDouble(minCgpaStr != null ? minCgpaStr.trim() : "0");
            if (minCgpa < 0 || minCgpa > 10) {
                request.setAttribute("companies", companies);
                request.setAttribute("error", "Minimum CGPA must be between 0.00 and 10.00.");
                request.getRequestDispatcher("/jsp/admin/addInternship.jsp").forward(request, response);
                return;
            }

            // ── Build Internship model ────────────────────────────────────
            Internship internship = new Internship();
            internship.setCompanyId(Integer.parseInt(companyIdStr.trim()));
            internship.setTitle(title.trim());
            internship.setDescription(description != null ? description.trim() : "");
            internship.setStipend(Double.parseDouble(stipendStr != null ? stipendStr.trim() : "0"));
            internship.setDurationMonths(Integer.parseInt(durationStr != null ? durationStr.trim() : "1"));
            internship.setMinCgpa(minCgpa);
            internship.setVacancies(Integer.parseInt(vacanciesStr != null ? vacanciesStr.trim() : "1"));
            internship.setStartDate(startDate != null && !startDate.isEmpty() ? startDate : null);
            internship.setEndDate(endDate != null && !endDate.isEmpty() ? endDate : null);
            internship.setStatus(status != null ? status : "open");

            // ── Persist via DAO (includes audit log + transaction) ────────
            String adminUser = (String) session.getAttribute("adminUser");
            boolean success  = internshipDAO.addInternship(internship, adminUser);

            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/viewInternships?msg=added");
            } else {
                request.setAttribute("companies", companies);
                request.setAttribute("error", "Failed to save internship. Please try again.");
                request.getRequestDispatcher("/jsp/admin/addInternship.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("companies", companies);
            request.setAttribute("error",
                    "Invalid numeric input. Please check Stipend, Duration, CGPA and Vacancies fields.");
            request.getRequestDispatcher("/jsp/admin/addInternship.jsp").forward(request, response);
        }
    }
}
