package com.admin.dao;

import com.admin.model.Application;
import com.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for student-facing application operations.
 * applyForInternship() uses a full JDBC transaction (commit/rollback).
 * Named StudentApplicationDAO to avoid collision with existing ApplicationDAO.
 */
public class StudentApplicationDAO {

    // ── APPLY (Transaction) ────────────────────────────────────────────────

    /**
     * Submits a new application for an internship.
     * Performs these checks inside a single transaction:
     *   1. Prevent duplicate application (UNIQUE constraint guard)
     *   2. Verify internship is still 'open' (deadline / status check)
     *   3. Insert into applications table
     *
     * Returns:
     *   "success"   — application submitted
     *   "duplicate" — student already applied to this internship
     *   "closed"    — internship is not open for applications
     *   "error"     — unexpected DB error
     */
    public String applyForInternship(int studentId, int internshipId) {
        // Step 1: Check internship status inside the transaction
        String checkSql  = "SELECT status FROM internships WHERE internship_id = ?";
        String checkDupSql =
            "SELECT 1 FROM applications WHERE student_id = ? AND internship_id = ?";
        String insertSql =
            "INSERT INTO applications (student_id, internship_id, status) " +
            "VALUES (?, ?, 'pending')";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // ── BEGIN TRANSACTION ──

            // Guard 1: Is internship open?
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, internshipId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next() || !"open".equals(rs.getString("status"))) {
                        conn.rollback();
                        return "closed";
                    }
                }
            }

            // Guard 2: Already applied?
            try (PreparedStatement ps = conn.prepareStatement(checkDupSql)) {
                ps.setInt(1, studentId);
                ps.setInt(2, internshipId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        conn.rollback();
                        return "duplicate";
                    }
                }
            }

            // Step 3: Insert application
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, studentId);
                ps.setInt(2, internshipId);
                ps.executeUpdate();
            }

            conn.commit(); // ── COMMIT ──
            return "success";

        } catch (SQLIntegrityConstraintViolationException e) {
            // UNIQUE constraint caught at DB level (safety net)
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            return "duplicate";
        } catch (SQLException e) {
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
            return "error";
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── VIEW APPLICATIONS BY STUDENT ───────────────────────────────────────

    /**
     * Returns all applications submitted by a student,
     * joined with internship and company details.
     */
    public List<Application> getApplicationsByStudent(int studentId) {
        List<Application> list = new ArrayList<>();
        String sql =
            "SELECT a.application_id, a.student_id, a.internship_id, " +
            "       a.applied_at, a.status, a.remarks, " +
            "       i.title AS internship_title, " +
            "       c.company_name, c.location, c.industry " +
            "FROM applications a " +
            "JOIN internships i ON a.internship_id = i.internship_id " +
            "JOIN companies   c ON i.company_id    = c.company_id " +
            "WHERE a.student_id = ? " +
            "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Application app = new Application();
                    app.setApplicationId(rs.getInt("application_id"));
                    app.setStudentId(rs.getInt("student_id"));
                    app.setInternshipId(rs.getInt("internship_id"));
                    app.setAppliedAt(rs.getString("applied_at"));
                    app.setStatus(rs.getString("status"));
                    app.setRemarks(rs.getString("remarks"));
                    app.setInternshipTitle(rs.getString("internship_title"));
                    app.setCompanyName(rs.getString("company_name"));
                    list.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── COUNT APPLICATIONS BY STUDENT ─────────────────────────────────────

    public int countApplicationsByStudent(int studentId) {
        String sql = "SELECT COUNT(*) FROM applications WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // ── COUNT SELECTED ─────────────────────────────────────────────────────

    public int countSelectedByStudent(int studentId) {
        String sql = "SELECT COUNT(*) FROM applications WHERE student_id = ? AND status = 'selected'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
