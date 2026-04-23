package com.admin.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

/**
 * AdminLoginServlet
 * GET  → shows the login page (index.jsp)
 * POST → validates credentials and creates the admin session
 *
 * NOTE: Credentials are hardcoded here for demo purposes.
 *       In production, replace with a DB lookup against an admins table.
 */
@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin123";

    // ── GET ────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Already logged in → redirect straight to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    // ── POST ───────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Trim whitespace
        if (username != null) username = username.trim();
        if (password != null) password = password.trim();

        if (ADMIN_USERNAME.equals(username) && ADMIN_PASSWORD.equals(password)) {

            // Create session, store admin username, set 30-minute timeout
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", username);
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } else {
            // Invalid credentials — return to login with error message
            request.setAttribute("error", "Invalid username or password. Please try again.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
