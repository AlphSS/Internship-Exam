package com.admin.dao;

import com.admin.model.Exam;
import com.admin.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Exam CRUD operations.
 */
public class ExamDAO {

    // ── INSERT ─────────────────────────────────────────────────────────────
    public boolean addExam(Exam exam) {
        String sql = "INSERT INTO exams (internship_id, exam_title, duration) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, exam.getInternshipId());
            ps.setString(2, exam.getExamTitle());
            ps.setInt(3, exam.getDuration());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── SELECT ALL ─────────────────────────────────────────────────────────
    public List<Exam> getAllExams() {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT e.*, i.title AS internship_title, c.company_name, " +
                     "       COUNT(q.question_id) AS question_count " +
                     "FROM exams e " +
                     "JOIN internships i ON e.internship_id = i.internship_id " +
                     "JOIN companies   c ON i.company_id    = c.company_id " +
                     "LEFT JOIN questions q ON e.exam_id    = q.exam_id " +
                     "GROUP BY e.exam_id " +
                     "ORDER BY e.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRow(rs));

        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── SELECT BY ID ───────────────────────────────────────────────────────
    public Exam getExamById(int examId) {
        String sql = "SELECT e.*, i.title AS internship_title, c.company_name, " +
                     "       COUNT(q.question_id) AS question_count " +
                     "FROM exams e " +
                     "JOIN internships i ON e.internship_id = i.internship_id " +
                     "JOIN companies   c ON i.company_id    = c.company_id " +
                     "LEFT JOIN questions q ON e.exam_id    = q.exam_id " +
                     "WHERE e.exam_id = ? " +
                     "GROUP BY e.exam_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, examId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ── SELECT BY INTERNSHIP ID ────────────────────────────────────────────
    public Exam getExamByInternshipId(int internshipId) {
        String sql = "SELECT e.*, i.title AS internship_title, c.company_name, " +
                     "       COUNT(q.question_id) AS question_count " +
                     "FROM exams e " +
                     "JOIN internships i ON e.internship_id = i.internship_id " +
                     "JOIN companies   c ON i.company_id    = c.company_id " +
                     "LEFT JOIN questions q ON e.exam_id    = q.exam_id " +
                     "WHERE e.internship_id = ? " +
                     "GROUP BY e.exam_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, internshipId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /**
     * Returns internship IDs that already have an exam assigned,
     * so they can be excluded from the "Add Exam" dropdown.
     */
    public List<Integer> getInternshipIdsWithExam() {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT internship_id FROM exams";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) ids.add(rs.getInt(1));

        } catch (SQLException e) { e.printStackTrace(); }
        return ids;
    }

    // ── DELETE ─────────────────────────────────────────────────────────────
    public boolean deleteExam(int examId) {
        String sql = "DELETE FROM exams WHERE exam_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, examId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ── Helper ─────────────────────────────────────────────────────────────
    private Exam mapRow(ResultSet rs) throws SQLException {
        Exam e = new Exam();
        e.setExamId(rs.getInt("exam_id"));
        e.setInternshipId(rs.getInt("internship_id"));
        e.setInternshipTitle(rs.getString("internship_title"));
        e.setCompanyName(rs.getString("company_name"));
        e.setExamTitle(rs.getString("exam_title"));
        e.setDuration(rs.getInt("duration"));
        e.setCreatedAt(rs.getString("created_at"));
        e.setQuestionCount(rs.getInt("question_count"));
        return e;
    }
}
