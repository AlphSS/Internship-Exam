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
import java.util.List;

@WebServlet("/admin/viewCompanies")
public class ViewCompaniesServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        List<Company> companies = companyDAO.getAllCompanies();
        request.setAttribute("companies", companies);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("msg", msg);

        request.getRequestDispatcher("/jsp/admin/manageCompanies.jsp")
               .forward(request, response);
    }
}
