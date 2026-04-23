package com.admin.dao;

import com.admin.model.Application;
import com.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Application management.
 * processApplication() uses explicit JDBC transactions with commit/rollback.
 */
public class ApplicationDAO {

    // ── SELECT ALL ─────────────────────────────────────────────────────────

    /**
     * Returns all applications joined with student and internship details.
     */
    public List<Application> getAllApplications() {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.application_id, a.student_id, a.internship_id, "
                   + "       a.applied_at, a.status, a.remarks, "
                   + "       s.full_name, s.email, s.roll_number, s.department, s.cgpa, s.mobile, "
                   + "       i.title AS internship_title, c.company_name "
                   + "FROM applications a "
                   + "JOIN students    s ON a.student_id    = s.student_id "
                   + "JOIN internships i ON a.internship_id = i.internship_id "
                   + "JOIN companies   c ON i.company_id    = c.company_id "
                   + "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── SELECT BY ID ───────────────────────────────────────────────────────

    public Application getApplicationById(int applicationId) {
        String sql = "SELECT a.application_id, a.student_id, a.internship_id, "
                   + "       a.applied_at, a.status, a.remarks, "
                   + "       s.full_name, s.email, s.roll_number, s.department, s.cgpa, s.mobile, "
                   + "       i.title AS internship_title, c.company_name "
                   + "FROM applications a "
                   + "JOIN students    s ON a.student_id    = s.student_id "
                   + "JOIN internships i ON a.internship_id = i.internship_id "
                   + "JOIN companies   c ON i.company_id    = c.company_id "
                   + "WHERE a.application_id = ?";

        Application app = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, applicationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) { app = mapRow(rs); }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return app;
    }

    // ── PROCESS APPLICATION (with JDBC Transaction) ────────────────────────

    /**
     * Updates application status (shortlisted/selected/rejected) with a remark.
     * Uses explicit transaction: any failure causes a full rollback.
     *
     * @param applicationId  the application to process
     * @param newStatus      'shortlisted' | 'selected' | 'rejected'
     * @param remarks        admin remarks/notes
     * @param adminUser      logged-in admin username (for audit log)
     * @return true on success
     */
    public boolean processApplication(int applicationId, String newStatus,
                                      String remarks, String adminUser) {
        String updateSql = "UPDATE applications SET status = ?, remarks = ? "
                         + "WHERE application_id = ?";
        String auditSql  = "INSERT INTO audit_logs (admin_user, action, entity_type, entity_id, details) "
                         + "VALUES (?, ?, 'Application', ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // ── BEGIN TRANSACTION ──

            // Step 1: Update application status
            PreparedStatement updatePs = conn.prepareStatement(updateSql);
            updatePs.setString(1, newStatus);
            updatePs.setString(2, remarks);
            updatePs.setInt(3, applicationId);
            int rowsAffected = updatePs.executeUpdate();
            updatePs.close();

            if (rowsAffected == 0) {
                // Application not found – rollback and return false
                conn.rollback();
                return false;
            }

            // Step 2: Write audit log
            String actionCode = "PROCESS_APPLICATION_" + newStatus.toUpperCase();
            PreparedStatement auditPs = conn.prepareStatement(auditSql);
            auditPs.setString(1, adminUser);
            auditPs.setString(2, actionCode);
            auditPs.setInt(3, applicationId);
            auditPs.setString(4, "Application #" + applicationId + " marked as " + newStatus
                               + ". Remarks: " + remarks);
            auditPs.executeUpdate();
            auditPs.close();

            conn.commit(); // ── COMMIT TRANSACTION ──
            return true;

        } catch (SQLException e) {
            // ── ROLLBACK on any error ──
            if (conn != null) {
                try {
                    conn.rollback();
                    System.err.println("Transaction rolled back for applicationId=" + applicationId);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Helper ─────────────────────────────────────────────────────────────

    private Application mapRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setApplicationId(rs.getInt("application_id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setInternshipId(rs.getInt("internship_id"));
        a.setAppliedAt(rs.getString("applied_at"));
        a.setStatus(rs.getString("status"));
        a.setRemarks(rs.getString("remarks"));
        a.setStudentName(rs.getString("full_name"));
        a.setStudentEmail(rs.getString("email"));
        a.setRollNumber(rs.getString("roll_number"));
        a.setDepartment(rs.getString("department"));
        a.setCgpa(rs.getDouble("cgpa"));
        a.setMobile(rs.getString("mobile"));
        a.setInternshipTitle(rs.getString("internship_title"));
        a.setCompanyName(rs.getString("company_name"));
        return a;
    }
}
