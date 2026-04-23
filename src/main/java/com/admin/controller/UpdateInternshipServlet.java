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

@WebServlet("/admin/updateInternship")
public class UpdateInternshipServlet extends HttpServlet {

    private final InternshipDAO internshipDAO = new InternshipDAO();
    private final CompanyDAO    companyDAO    = new CompanyDAO();

    // GET — load internship data into edit form
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
            response.sendRedirect(request.getContextPath() + "/admin/viewInternships");
            return;
        }

        int internshipId      = Integer.parseInt(idParam);
        Internship internship = internshipDAO.getInternshipById(internshipId);
        List<Company> companies = companyDAO.getAllCompanies();

        if (internship == null) {
            response.sendRedirect(request.getContextPath() + "/admin/viewInternships?msg=notfound");
            return;
        }

        request.setAttribute("internship", internship);
        request.setAttribute("companies", companies);
        request.getRequestDispatcher("/jsp/admin/editInternship.jsp").forward(request, response);
    }

    // POST — save updated internship data
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            int internshipId = Integer.parseInt(request.getParameter("internshipId"));

            Internship internship = new Internship();
            internship.setInternshipId(internshipId);
            internship.setCompanyId(Integer.parseInt(request.getParameter("companyId")));
            internship.setTitle(request.getParameter("title").trim());
            internship.setDescription(request.getParameter("description").trim());
            internship.setStipend(Double.parseDouble(request.getParameter("stipend")));
            internship.setDurationMonths(Integer.parseInt(request.getParameter("durationMonths")));
            internship.setMinCgpa(Double.parseDouble(request.getParameter("minCgpa")));
            internship.setVacancies(Integer.parseInt(request.getParameter("vacancies")));
            internship.setStartDate(request.getParameter("startDate"));
            internship.setEndDate(request.getParameter("endDate"));
            internship.setStatus(request.getParameter("status"));

            // Server-side validation
            if (internship.getTitle().isEmpty()) {
                List<Company> companies = companyDAO.getAllCompanies();
                request.setAttribute("internship", internship);
                request.setAttribute("companies", companies);
                request.setAttribute("error", "Internship title cannot be empty.");
                request.getRequestDispatcher("/jsp/admin/editInternship.jsp").forward(request, response);
                return;
            }

            String adminUser = (String) session.getAttribute("adminUser");
            boolean success  = internshipDAO.updateInternship(internship, adminUser);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/viewInternships?msg=updated");
            } else {
                List<Company> companies = companyDAO.getAllCompanies();
                request.setAttribute("internship", internship);
                request.setAttribute("companies", companies);
                request.setAttribute("error", "Failed to update internship. Please try again.");
                request.getRequestDispatcher("/jsp/admin/editInternship.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/viewInternships?msg=error");
        }
    }
}
