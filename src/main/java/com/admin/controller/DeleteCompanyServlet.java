package com.admin.controller;

import com.admin.dao.CompanyDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/deleteCompany")
public class DeleteCompanyServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();

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

        int    companyId = Integer.parseInt(idParam);
        String adminUser = (String) session.getAttribute("adminUser");
        boolean success  = companyDAO.deleteCompany(companyId, adminUser);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/viewCompanies?msg=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/viewCompanies?msg=error");
        }
    }
}
