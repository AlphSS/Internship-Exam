package com.admin.controller;

import com.admin.dao.InternshipDAO;
import com.admin.model.Internship;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/viewInternships")
public class ViewInternshipsAdminServlet extends HttpServlet {

    private final InternshipDAO internshipDAO = new InternshipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        List<Internship> internships = internshipDAO.getAllInternships();
        request.setAttribute("internships", internships);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("msg", msg);

        request.getRequestDispatcher("/jsp/admin/manageInternships.jsp")
               .forward(request, response);
    }
}
