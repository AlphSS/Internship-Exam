package com.admin.dao;

import com.admin.model.Internship;
import com.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for student-facing internship queries.
 * Extends the existing InternshipDAO logic with CGPA-based eligibility filtering.
 * Named StudentInternshipDAO to avoid collision with the existing InternshipDAO
 * used by the admin module.
 */
public class StudentInternshipDAO {

    // ── ALL ELIGIBLE INTERNSHIPS ────────────────────────────────────────────

    /**
     * Returns all OPEN internships where student's CGPA meets the minimum.
     * Also marks which ones the student has already applied to.
     *
     * @param studentCgpa  the logged-in student's CGPA
     * @param studentId    used to check for existing applications
     */
    public List<Internship> getEligibleInternships(double studentCgpa, int studentId) {
        List<Internship> list = new ArrayList<>();
        String sql =
            "SELECT i.internship_id, i.company_id, i.title, i.description, " +
            "       i.stipend, i.duration_months, i.min_cgpa, i.vacancies, " +
            "       i.start_date, i.end_date, i.status, i.created_at, " +
            "       c.company_name, c.location, c.industry, " +
            "       CASE WHEN a.application_id IS NOT NULL THEN 1 ELSE 0 END AS already_applied " +
            "FROM internships i " +
            "JOIN companies c ON i.company_id = c.company_id " +
            "LEFT JOIN applications a " +
            "       ON a.internship_id = i.internship_id AND a.student_id = ? " +
            "WHERE i.status = 'open' " +
            "  AND i.min_cgpa <= ? " +
            "ORDER BY i.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setDouble(2, studentCgpa);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Internship i = mapRow(rs);
                    // Store already_applied flag in a transient field we reuse
                    i.setStatus(rs.getInt("already_applied") == 1 ? "applied" : i.getStatus());
                    list.add(i);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── ALL OPEN INTERNSHIPS (for browsing, no CGPA filter) ────────────────

    public List<Internship> getAllOpenInternships(int studentId) {
        List<Internship> list = new ArrayList<>();
        String sql =
            "SELECT i.internship_id, i.company_id, i.title, i.description, " +
            "       i.stipend, i.duration_months, i.min_cgpa, i.vacancies, " +
            "       i.start_date, i.end_date, i.status, i.created_at, " +
            "       c.company_name, c.location, c.industry, " +
            "       CASE WHEN a.application_id IS NOT NULL THEN 1 ELSE 0 END AS already_applied " +
            "FROM internships i " +
            "JOIN companies c ON i.company_id = c.company_id " +
            "LEFT JOIN applications a " +
            "       ON a.internship_id = i.internship_id AND a.student_id = ? " +
            "WHERE i.status = 'open' " +
            "ORDER BY i.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Internship i = mapRow(rs);
                    // Tag already-applied ones
                    if (rs.getInt("already_applied") == 1) {
                        i.setStatus("applied");
                    }
                    list.add(i);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── GET SINGLE INTERNSHIP BY ID ────────────────────────────────────────

    public Internship getInternshipById(int internshipId) {
        String sql =
            "SELECT i.*, c.company_name, c.location, c.industry " +
            "FROM internships i " +
            "JOIN companies c ON i.company_id = c.company_id " +
            "WHERE i.internship_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, internshipId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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
