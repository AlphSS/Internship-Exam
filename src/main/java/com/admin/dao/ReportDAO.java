package com.admin.dao;

import com.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for report-related queries.
 */
public class ReportDAO {

    /**
     * Returns the number of selected students per company.
     * Result: List of String[] { companyName, selectedCount }
     */
    public List<String[]> getStudentsSelectedPerCompany() {
        List<String[]> report = new ArrayList<>();
        String sql = "SELECT c.company_name, COUNT(a.application_id) AS selected_count "
                   + "FROM applications a "
                   + "JOIN internships i ON a.internship_id = i.internship_id "
                   + "JOIN companies   c ON i.company_id    = c.company_id "
                   + "WHERE a.status = 'selected' "
                   + "GROUP BY c.company_id, c.company_name "
                   + "ORDER BY selected_count DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                report.add(new String[]{
                    rs.getString("company_name"),
                    String.valueOf(rs.getInt("selected_count"))
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return report;
    }

    /**
     * Returns total application count per internship.
     * Result: List of String[] { internshipTitle, companyName, totalApplications }
     */
    public List<String[]> getApplicationCountPerInternship() {
        List<String[]> report = new ArrayList<>();
        String sql = "SELECT i.title, c.company_name, COUNT(a.application_id) AS app_count "
                   + "FROM internships i "
                   + "LEFT JOIN applications a ON i.internship_id = a.internship_id "
                   + "JOIN companies c ON i.company_id = c.company_id "
                   + "GROUP BY i.internship_id, i.title, c.company_name "
                   + "ORDER BY app_count DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                report.add(new String[]{
                    rs.getString("title"),
                    rs.getString("company_name"),
                    String.valueOf(rs.getInt("app_count"))
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return report;
    }

    /**
     * Returns quick summary counts for the dashboard:
     * total companies, internships, applications, selected students.
     */
    public Map<String, Integer> getDashboardSummary() {
        Map<String, Integer> summary = new LinkedHashMap<>();
        String[] queries = {
            "SELECT COUNT(*) FROM companies",
            "SELECT COUNT(*) FROM internships",
            "SELECT COUNT(*) FROM applications",
            "SELECT COUNT(*) FROM applications WHERE status = 'selected'"
        };
        String[] keys = { "totalCompanies", "totalInternships", "totalApplications", "totalSelected" };

        try (Connection conn = DBConnection.getConnection()) {
            for (int i = 0; i < queries.length; i++) {
                try (PreparedStatement ps = conn.prepareStatement(queries[i]);
                     ResultSet rs = ps.executeQuery()) {
                    summary.put(keys[i], rs.next() ? rs.getInt(1) : 0);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return summary;
    }
}
