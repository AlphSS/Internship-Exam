package com.admin.dao;

import com.admin.model.Result;
import com.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for fetching exam results (admin view).
 */
public class ResultDAO {

    private static final String BASE_SQL =
        "SELECT r.*, s.full_name, s.roll_number, s.department, " +
        "       e.exam_title, i.title AS internship_title, c.company_name " +
        "FROM results r " +
        "JOIN students    s ON r.student_id   = s.student_id " +
        "JOIN exams       e ON r.exam_id      = e.exam_id " +
        "JOIN internships i ON e.internship_id = i.internship_id " +
        "JOIN companies   c ON i.company_id   = c.company_id ";

    // ALL RESULTS for a specific exam
    public List<Result> getResultsByExam(int examId) {
        List<Result> list = new ArrayList<Result>();
        String sql = BASE_SQL + "WHERE r.exam_id = ? ORDER BY r.percentage DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ALL RESULTS (admin overview)
    public List<Result> getAllResults() {
        List<Result> list = new ArrayList<Result>();
        String sql = BASE_SQL + "ORDER BY r.submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // RESULT FOR ONE STUDENT in one exam
    public Result getResultForStudent(int studentId, int examId) {
        String sql = BASE_SQL + "WHERE r.student_id = ? AND r.exam_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, examId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Result mapRow(ResultSet rs) throws SQLException {
        Result r = new Result();
        r.setResultId(rs.getInt("result_id"));
        r.setStudentId(rs.getInt("student_id"));
        r.setExamId(rs.getInt("exam_id"));
        r.setScore(rs.getInt("score"));
        r.setTotalMarks(rs.getInt("total_marks"));
        r.setPercentage(rs.getDouble("percentage"));
        r.setSubmittedAt(rs.getString("submitted_at"));
        r.setStudentName(rs.getString("full_name"));
        r.setRollNumber(rs.getString("roll_number"));
        r.setDepartment(rs.getString("department"));
        r.setExamTitle(rs.getString("exam_title"));
        r.setInternshipTitle(rs.getString("internship_title"));
        r.setCompanyName(rs.getString("company_name"));
        return r;
    }
}
