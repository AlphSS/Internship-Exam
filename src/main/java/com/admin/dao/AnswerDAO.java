package com.admin.dao;

import com.admin.model.Answer;
import com.admin.model.Question;
import com.admin.model.Result;
import com.admin.util.DBConnection;

import java.sql.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for student answer operations:
 *  - Auto-save individual answers (AJAX)
 *  - Session start / resume
 *  - Auto-evaluation and result storage (full JDBC transaction)
 */
public class AnswerDAO {

    // ── START / RESUME SESSION ─────────────────────────────────────────────

    /**
     * Creates an exam session for the student if one does not exist yet.
     * Returns the start timestamp (epoch seconds) for timer calculation.
     */
    public long startOrResumeSession(int studentId, int examId) {
        String selectSql = "SELECT start_time FROM exam_sessions " +
                           "WHERE student_id = ? AND exam_id = ?";
        String insertSql = "INSERT INTO exam_sessions (student_id, exam_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection()) {

            // Check if session already exists
            try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                ps.setInt(1, studentId);
                ps.setInt(2, examId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Resume: return existing start time
                        Timestamp ts = rs.getTimestamp("start_time");
                        return ts.getTime() / 1000L;
                    }
                }
            }

            // New session: insert and return current time
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, studentId);
                ps.setInt(2, examId);
                ps.executeUpdate();
            }
            return System.currentTimeMillis() / 1000L;

        } catch (SQLException e) { e.printStackTrace(); return System.currentTimeMillis() / 1000L; }
    }

    // ── CHECK SUBMITTED ────────────────────────────────────────────────────

    public boolean isSubmitted(int studentId, int examId) {
        String sql = "SELECT submitted FROM exam_sessions " +
                     "WHERE student_id = ? AND exam_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, examId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("submitted") == 1;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── AUTO-SAVE (AJAX) ───────────────────────────────────────────────────

    /**
     * Inserts or updates a single answer. Called by AJAX every time a
     * student selects an option. Uses INSERT ... ON DUPLICATE KEY UPDATE.
     */
    public boolean saveAnswer(int studentId, int examId,
                              int questionId, String selectedOption) {
        String sql = "INSERT INTO student_answers (student_id, exam_id, question_id, selected_option) " +
                     "VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE selected_option = VALUES(selected_option), " +
                     "                        saved_at = CURRENT_TIMESTAMP";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, examId);
            ps.setInt(3, questionId);
            ps.setString(4, selectedOption.toUpperCase());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ── LOAD SAVED ANSWERS (for resume) ───────────────────────────────────

    /**
     * Returns a map of questionId → selectedOption for a student's exam.
     * Used to pre-fill answers when the student resumes after a refresh.
     */
    public Map<Integer, String> getSavedAnswers(int studentId, int examId) {
        Map<Integer, String> map = new HashMap<>();
        String sql = "SELECT question_id, selected_option FROM student_answers " +
                     "WHERE student_id = ? AND exam_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, examId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("question_id"), rs.getString("selected_option"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    // ── AUTO-EVALUATE & SUBMIT ─────────────────────────────────────────────

    /**
     * Evaluates the exam, stores the result, and marks the session as submitted.
     * Uses a full JDBC transaction with commit/rollback.
     *
     * @param studentId  the student submitting
     * @param examId     the exam being submitted
     * @param questions  full question list (with correct answers)
     * @return Result object with score, total, percentage; or null on failure
     */
    public Result submitAndEvaluate(int studentId, int examId,
                                    List<Question> questions) {

        // ── 1. Load student answers ────────────────────────────────────────
        Map<Integer, String> savedAnswers = getSavedAnswers(studentId, examId);

        // ── 2. Evaluate ────────────────────────────────────────────────────
        int score      = 0;
        int totalMarks = 0;

        for (Question q : questions) {
            totalMarks += q.getMarks();
            String chosen  = savedAnswers.get(q.getQuestionId());
            if (chosen != null &&
                chosen.equalsIgnoreCase(String.valueOf(q.getCorrectOption()))) {
                score += q.getMarks();
            }
        }

        double percentage = totalMarks > 0 ? (score * 100.0 / totalMarks) : 0.0;

        // ── 3. Persist result + mark session submitted (transaction) ───────
        String insertResultSql =
            "INSERT INTO results (student_id, exam_id, score, total_marks, percentage) " +
            "VALUES (?, ?, ?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE score=VALUES(score), " +
            "total_marks=VALUES(total_marks), percentage=VALUES(percentage), " +
            "submitted_at=CURRENT_TIMESTAMP";

        String markSubmittedSql =
            "UPDATE exam_sessions SET submitted = 1 " +
            "WHERE student_id = ? AND exam_id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // ── BEGIN TRANSACTION ──

            // Insert/update result
            try (PreparedStatement ps = conn.prepareStatement(insertResultSql)) {
                ps.setInt(1, studentId);
                ps.setInt(2, examId);
                ps.setInt(3, score);
                ps.setInt(4, totalMarks);
                ps.setDouble(5, percentage);
                ps.executeUpdate();
            }

            // Mark session as submitted
            try (PreparedStatement ps = conn.prepareStatement(markSubmittedSql)) {
                ps.setInt(1, studentId);
                ps.setInt(2, examId);
                ps.executeUpdate();
            }

            conn.commit(); // ── COMMIT ──

            // Build and return Result object
            Result result = new Result();
            result.setStudentId(studentId);
            result.setExamId(examId);
            result.setScore(score);
            result.setTotalMarks(totalMarks);
            result.setPercentage(Math.round(percentage * 100.0) / 100.0);
            return result;

        } catch (SQLException e) {
            // ── ROLLBACK ──
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return null;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }
}
