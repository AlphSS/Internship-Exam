package com.admin.dao;

import com.admin.model.Internship;
import com.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Internship CRUD operations.
 */
public class InternshipDAO {

    // ── INSERT ─────────────────────────────────────────────────────────────

    public boolean addInternship(Internship internship, String adminUser) {
        String sql = "INSERT INTO internships (company_id, title, description, stipend, "
                   + "duration_months, min_cgpa, vacancies, start_date, end_date, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String auditSql = "INSERT INTO audit_logs (admin_user, action, entity_type, entity_id, details) "
                        + "VALUES (?, ?, 'Internship', ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, internship.getCompanyId());
            ps.setString(2, internship.getTitle());
            ps.setString(3, internship.getDescription());
            ps.setDouble(4, internship.getStipend());
            ps.setInt(5, internship.getDurationMonths());
            ps.setDouble(6, internship.getMinCgpa());
            ps.setInt(7, internship.getVacancies());
            ps.setString(8, internship.getStartDate());
            ps.setString(9, internship.getEndDate());
            ps.setString(10, internship.getStatus());
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            int generatedId = 0;
            if (keys.next()) { generatedId = keys.getInt(1); }
            ps.close();

            PreparedStatement auditPs = conn.prepareStatement(auditSql);
            auditPs.setString(1, adminUser);
            auditPs.setString(2, "ADD_INTERNSHIP");
            auditPs.setInt(3, generatedId);
            auditPs.setString(4, "Added internship: " + internship.getTitle());
            auditPs.executeUpdate();
            auditPs.close();

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── SELECT ALL (with company name join) ────────────────────────────────

    public List<Internship> getAllInternships() {
        List<Internship> list = new ArrayList<>();
        String sql = "SELECT i.*, c.company_name FROM internships i "
                   + "JOIN companies c ON i.company_id = c.company_id "
                   + "ORDER BY i.created_at DESC";

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

    public Internship getInternshipById(int internshipId) {
        String sql = "SELECT i.*, c.company_name FROM internships i "
                   + "JOIN companies c ON i.company_id = c.company_id "
                   + "WHERE i.internship_id = ?";
        Internship internship = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, internshipId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) { internship = mapRow(rs); }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return internship;
    }

    // ── UPDATE ─────────────────────────────────────────────────────────────

    public boolean updateInternship(Internship internship, String adminUser) {
        String sql = "UPDATE internships SET company_id=?, title=?, description=?, stipend=?, "
                   + "duration_months=?, min_cgpa=?, vacancies=?, start_date=?, end_date=?, status=? "
                   + "WHERE internship_id=?";
        String auditSql = "INSERT INTO audit_logs (admin_user, action, entity_type, entity_id, details) "
                        + "VALUES (?, ?, 'Internship', ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, internship.getCompanyId());
            ps.setString(2, internship.getTitle());
            ps.setString(3, internship.getDescription());
            ps.setDouble(4, internship.getStipend());
            ps.setInt(5, internship.getDurationMonths());
            ps.setDouble(6, internship.getMinCgpa());
            ps.setInt(7, internship.getVacancies());
            ps.setString(8, internship.getStartDate());
            ps.setString(9, internship.getEndDate());
            ps.setString(10, internship.getStatus());
            ps.setInt(11, internship.getInternshipId());
            ps.executeUpdate();
            ps.close();

            PreparedStatement auditPs = conn.prepareStatement(auditSql);
            auditPs.setString(1, adminUser);
            auditPs.setString(2, "UPDATE_INTERNSHIP");
            auditPs.setInt(3, internship.getInternshipId());
            auditPs.setString(4, "Updated internship: " + internship.getTitle());
            auditPs.executeUpdate();
            auditPs.close();

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── DELETE ─────────────────────────────────────────────────────────────

    public boolean deleteInternship(int internshipId, String adminUser) {
        String sql      = "DELETE FROM internships WHERE internship_id = ?";
        String auditSql = "INSERT INTO audit_logs (admin_user, action, entity_type, entity_id, details) "
                        + "VALUES (?, ?, 'Internship', ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, internshipId);
            ps.executeUpdate();
            ps.close();

            PreparedStatement auditPs = conn.prepareStatement(auditSql);
            auditPs.setString(1, adminUser);
            auditPs.setString(2, "DELETE_INTERNSHIP");
            auditPs.setInt(3, internshipId);
            auditPs.setString(4, "Deleted internship ID: " + internshipId);
            auditPs.executeUpdate();
            auditPs.close();

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Helper ─────────────────────────────────────────────────────────────

    private Internship mapRow(ResultSet rs) throws SQLException {
        Internship i = new Internship();
        i.setInternshipId(rs.getInt("internship_id"));
        i.setCompanyId(rs.getInt("company_id"));
        i.setCompanyName(rs.getString("company_name"));
        i.setTitle(rs.getString("title"));
        i.setDescription(rs.getString("description"));
        i.setStipend(rs.getDouble("stipend"));
        i.setDurationMonths(rs.getInt("duration_months"));
        i.setMinCgpa(rs.getDouble("min_cgpa"));
        i.setVacancies(rs.getInt("vacancies"));
        i.setStartDate(rs.getString("start_date"));
        i.setEndDate(rs.getString("end_date"));
        i.setStatus(rs.getString("status"));
        i.setCreatedAt(rs.getString("created_at"));
        return i;
    }
}
