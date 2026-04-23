package com.admin.dao;

import com.admin.model.Company;
import com.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Company CRUD operations.
 * All DB interactions use PreparedStatements to prevent SQL injection.
 */
public class CompanyDAO {

    // ── INSERT ─────────────────────────────────────────────────────────────

    /**
     * Adds a new company and writes an audit log entry.
     *
     * @param company   the company to insert
     * @param adminUser the logged-in admin's username (for audit)
     * @return true if insert succeeded
     */
    public boolean addCompany(Company company, String adminUser) {
        String sql = "INSERT INTO companies (company_name, industry, location, website, contact_email) "
                   + "VALUES (?, ?, ?, ?, ?)";
        String auditSql = "INSERT INTO audit_logs (admin_user, action, entity_type, entity_id, details) "
                        + "VALUES (?, ?, 'Company', ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // 1. Insert company
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getIndustry());
            ps.setString(3, company.getLocation());
            ps.setString(4, company.getWebsite());
            ps.setString(5, company.getContactEmail());
            ps.executeUpdate();

            // Retrieve generated primary key
            ResultSet keys = ps.getGeneratedKeys();
            int generatedId = 0;
            if (keys.next()) {
                generatedId = keys.getInt(1);
            }
            ps.close();

            // 2. Write audit log
            PreparedStatement auditPs = conn.prepareStatement(auditSql);
            auditPs.setString(1, adminUser);
            auditPs.setString(2, "ADD_COMPANY");
            auditPs.setInt(3, generatedId);
            auditPs.setString(4, "Added company: " + company.getCompanyName());
            auditPs.executeUpdate();
            auditPs.close();

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── SELECT ALL ─────────────────────────────────────────────────────────

    /**
     * Returns all companies ordered by creation date (newest first).
     */
    public List<Company> getAllCompanies() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT * FROM companies ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── SELECT BY ID ───────────────────────────────────────────────────────

    /**
     * Finds a single company by its primary key.
     */
    public Company getCompanyById(int companyId) {
        String sql = "SELECT * FROM companies WHERE company_id = ?";
        Company company = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    company = mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return company;
    }

    // ── UPDATE ─────────────────────────────────────────────────────────────

    /**
     * Updates an existing company record and writes an audit log entry.
     */
    public boolean updateCompany(Company company, String adminUser) {
        String sql = "UPDATE companies SET company_name=?, industry=?, location=?, "
                   + "website=?, contact_email=? WHERE company_id=?";
        String auditSql = "INSERT INTO audit_logs (admin_user, action, entity_type, entity_id, details) "
                        + "VALUES (?, ?, 'Company', ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getIndustry());
            ps.setString(3, company.getLocation());
            ps.setString(4, company.getWebsite());
            ps.setString(5, company.getContactEmail());
            ps.setInt(6, company.getCompanyId());
            ps.executeUpdate();
            ps.close();

            PreparedStatement auditPs = conn.prepareStatement(auditSql);
            auditPs.setString(1, adminUser);
            auditPs.setString(2, "UPDATE_COMPANY");
            auditPs.setInt(3, company.getCompanyId());
            auditPs.setString(4, "Updated company: " + company.getCompanyName());
            auditPs.executeUpdate();
            auditPs.close();

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── DELETE ─────────────────────────────────────────────────────────────

    /**
     * Deletes a company by ID. Audit-logged.
     */
    public boolean deleteCompany(int companyId, String adminUser) {
        String sql      = "DELETE FROM companies WHERE company_id = ?";
        String auditSql = "INSERT INTO audit_logs (admin_user, action, entity_type, entity_id, details) "
                        + "VALUES (?, ?, 'Company', ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, companyId);
            ps.executeUpdate();
            ps.close();

            PreparedStatement auditPs = conn.prepareStatement(auditSql);
            auditPs.setString(1, adminUser);
            auditPs.setString(2, "DELETE_COMPANY");
            auditPs.setInt(3, companyId);
            auditPs.setString(4, "Deleted company with ID: " + companyId);
            auditPs.executeUpdate();
            auditPs.close();

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── Helper ─────────────────────────────────────────────────────────────

    /** Maps a ResultSet row to a Company object. */
    private Company mapRow(ResultSet rs) throws SQLException {
        Company c = new Company();
        c.setCompanyId(rs.getInt("company_id"));
        c.setCompanyName(rs.getString("company_name"));
        c.setIndustry(rs.getString("industry"));
        c.setLocation(rs.getString("location"));
        c.setWebsite(rs.getString("website"));
        c.setContactEmail(rs.getString("contact_email"));
        c.setCreatedAt(rs.getString("created_at"));
        return c;
    }
}
