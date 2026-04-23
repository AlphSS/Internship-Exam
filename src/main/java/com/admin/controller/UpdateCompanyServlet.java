package com.admin.controller;

import com.admin.dao.CompanyDAO;
import com.admin.model.Company;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/updateCompany")
public class UpdateCompanyServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();

    // GET — load company data into edit form
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
            response.sendRedirect(request.getContextPath() + "/admin/viewCompanies");
            return;
        }

        int companyId   = Integer.parseInt(idParam);
        Company company = companyDAO.getCompanyById(companyId);

        if (company == null) {
            response.sendRedirect(request.getContextPath() + "/admin/viewCompanies?msg=notfound");
            return;
        }

        request.setAttribute("company", company);
        request.getRequestDispatcher("/jsp/admin/editCompany.jsp").forward(request, response);
    }

    // POST — save updated company data
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        int    companyId   = Integer.parseInt(request.getParameter("companyId"));
        String companyName = request.getParameter("companyName").trim();
        String industry    = request.getParameter("industry").trim();
        String location    = request.getParameter("location").trim();
        String website     = request.getParameter("website").trim();
        String email       = request.getParameter("contactEmail").trim();

        // Server-side validation
        if (companyName.isEmpty()) {
            Company company = companyDAO.getCompanyById(companyId);
            request.setAttribute("company", company);
            request.setAttribute("error", "Company name cannot be empty.");
            request.getRequestDispatcher("/jsp/admin/editCompany.jsp").forward(request, response);
            return;
        }

        Company company  = new Company(companyId, companyName, industry, location, website, email);
        String adminUser = (String) session.getAttribute("adminUser");
        boolean success  = companyDAO.updateCompany(company, adminUser);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/viewCompanies?msg=updated");
        } else {
            request.setAttribute("company", company);
            request.setAttribute("error", "Failed to update. Please try again.");
            request.getRequestDispatcher("/jsp/admin/editCompany.jsp").forward(request, response);
        }
    }
}
