package com.admin.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

/**
 * AdminLogoutServlet
 * Invalidates the current admin session and redirects to the login page.
 */
@WebServlet("/admin/logout")
public class AdminLogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get existing session — pass false so we don't create a new one
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate(); // destroy all session data
        }

        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    // Support POST logout as well (e.g. from a form button)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
