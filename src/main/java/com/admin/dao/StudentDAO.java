package com.admin.dao;

import com.admin.model.Student;
import com.admin.util.DBConnection;

import java.sql.*;

/**
 * DAO for Student registration, login and profile operations.
 * Uses the existing DBConnection utility.
 * Inserts into BOTH 'students' and 'users' tables inside a single
 * JDBC transaction (commit / rollback) during registration.
 */
public class StudentDAO {

    // ── REGISTRATION (Transaction) ─────────────────────────────────────────

    /**
     * Registers a new student.
     * Step 1 — INSERT into students (profile)
     * Step 2 — INSERT into users   (auth)
     * Both steps are wrapped in a transaction: if either fails the whole
     * registration is rolled back, preventing orphan records.
     *
     * @param student fully populated Student object (password included)
     * @return true on success, false on any failure
     */
    public boolean registerStudent(Student student) {
        String insertStudentSql =
            "INSERT INTO students (full_name, email, roll_number, department, cgpa, mobile) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        String insertUserSql =
            "INSERT INTO users (email, password, role, student_id) " +
            "VALUES (?, ?, 'student', ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // ── BEGIN TRANSACTION ──

            // Step 1: Insert into students
            PreparedStatement ps1 = conn.prepareStatement(
                    insertStudentSql, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, student.getFullName());
            ps1.setString(2, student.getEmail());
            ps1.setString(3, student.getRollNumber());
            ps1.setString(4, student.getDepartment());
            ps1.setDouble(5, student.getCgpa());
            ps1.setString(6, student.getMobile());
            ps1.executeUpdate();

            // Retrieve auto-generated student_id
            ResultSet keys = ps1.getGeneratedKeys();
            int generatedStudentId = 0;
            if (keys.next()) {
                generatedStudentId = keys.getInt(1);
            }
            ps1.close();

            if (generatedStudentId == 0) {
                conn.rollback();
                return false;
            }

            // Step 2: Insert into users with the new student_id
            PreparedStatement ps2 = conn.prepareStatement(insertUserSql);
            ps2.setString(1, student.getEmail());
            ps2.setString(2, student.getPassword()); // hash in production
            ps2.setInt(3, generatedStudentId);
            ps2.executeUpdate();
            ps2.close();

            conn.commit(); // ── COMMIT ──
            return true;

        } catch (SQLIntegrityConstraintViolationException e) {
            // Duplicate email or roll number
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            return false;
        } catch (SQLException e) {
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ── LOGIN ──────────────────────────────────────────────────────────────

    /**
     * Validates student credentials against the users table.
     * Returns the matching Student object (with joined profile data) on success,
     * or null if the credentials are invalid or the role is not 'student'.
     */
    public Student login(String email, String password) {
        String sql =
            "SELECT u.user_id, u.email, u.password, " +
            "       s.student_id, s.full_name, s.roll_number, " +
            "       s.department, s.cgpa, s.mobile, s.created_at " +
            "FROM users u " +
            "JOIN students s ON u.student_id = s.student_id " +
            "WHERE u.email = ? AND u.password = ? AND u.role = 'student'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student s = new Student();
                    s.setUserId(rs.getInt("user_id"));
                    s.setEmail(rs.getString("email"));
                    s.setStudentId(rs.getInt("student_id"));
                    s.setFullName(rs.getString("full_name"));
                    s.setRollNumber(rs.getString("roll_number"));
                    s.setDepartment(rs.getString("department"));
                    s.setCgpa(rs.getDouble("cgpa"));
                    s.setMobile(rs.getString("mobile"));
                    s.setCreatedAt(rs.getString("created_at"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── GET BY ID ──────────────────────────────────────────────────────────

    /**
     * Fetches a full student profile by student_id.
     */
    public Student getStudentById(int studentId) {
        String sql =
            "SELECT s.*, u.user_id, u.email AS u_email " +
            "FROM students s " +
            "LEFT JOIN users u ON u.student_id = s.student_id " +
            "WHERE s.student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student s = new Student();
                    s.setStudentId(rs.getInt("student_id"));
                    s.setFullName(rs.getString("full_name"));
                    s.setEmail(rs.getString("email"));
                    s.setRollNumber(rs.getString("roll_number"));
                    s.setDepartment(rs.getString("department"));
                    s.setCgpa(rs.getDouble("cgpa"));
                    s.setMobile(rs.getString("mobile"));
                    s.setCreatedAt(rs.getString("created_at"));
                    s.setUserId(rs.getInt("user_id"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── CHECK EMAIL EXISTS ─────────────────────────────────────────────────

    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── CHECK ROLL EXISTS ──────────────────────────────────────────────────

    public boolean rollNumberExists(String rollNumber) {
        String sql = "SELECT 1 FROM students WHERE roll_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rollNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
