package com.admin.controller;

import com.admin.dao.CompanyDAO;
import com.admin.model.Company;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * GET  → renders the Add Company form
 * POST → processes form submission and inserts a new company
 */
@WebServlet("/admin/addCompany")
public class AddCompanyServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        request.getRequestDispatcher("/jsp/admin/addCompany.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Read and trim form parameters
        String companyName  = request.getParameter("companyName")  != null ? request.getParameter("companyName").trim()  : "";
        String industry     = request.getParameter("industry")     != null ? request.getParameter("industry").trim()     : "";
        String location     = request.getParameter("location")     != null ? request.getParameter("location").trim()     : "";
        String website      = request.getParameter("website")      != null ? request.getParameter("website").trim()      : "";
        String contactEmail = request.getParameter("contactEmail") != null ? request.getParameter("contactEmail").trim() : "";

        // Basic server-side validation
        if (companyName.isEmpty()) {
            request.setAttribute("error", "Company name is required.");
            request.getRequestDispatcher("/jsp/admin/addCompany.jsp").forward(request, response);
            return;
        }

        // Build model
        Company company = new Company();
        company.setCompanyName(companyName);
        company.setIndustry(industry);
        company.setLocation(location);
        company.setWebsite(website);
        company.setContactEmail(contactEmail);

        String adminUser = (String) request.getSession().getAttribute("adminUser");
        boolean success  = companyDAO.addCompany(company, adminUser);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/viewCompanies?msg=added");
        } else {
            request.setAttribute("error", "Failed to add company. Please try again.");
            request.getRequestDispatcher("/jsp/admin/addCompany.jsp").forward(request, response);
        }
    }

    private boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("adminUser") != null;
    }
}
