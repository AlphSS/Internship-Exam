-- ============================================================
-- DATABASE SCHEMA: Internship & Online Exam Management System
-- ============================================================

CREATE DATABASE IF NOT EXISTS ERP_admin_db;
USE ERP_admin_db;

-- Companies Table
CREATE TABLE IF NOT EXISTS companies (
    company_id    INT AUTO_INCREMENT PRIMARY KEY,
    company_name  VARCHAR(150) NOT NULL,
    industry      VARCHAR(100),
    location      VARCHAR(150),
    website       VARCHAR(255),
    contact_email VARCHAR(150),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Internships Table
CREATE TABLE IF NOT EXISTS internships (
    internship_id   INT AUTO_INCREMENT PRIMARY KEY,
    company_id      INT NOT NULL,
    title           VARCHAR(200) NOT NULL,
    description     TEXT,
    stipend         DECIMAL(10,2),
    duration_months INT,
    min_cgpa        DECIMAL(3,2) DEFAULT 0.00,
    vacancies       INT DEFAULT 1,
    start_date      DATE,
    end_date        DATE,
    status          ENUM('open','closed') DEFAULT 'open',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

-- Students Table (assumed to exist; minimal definition for reference)
CREATE TABLE IF NOT EXISTS students (
    student_id     INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(150) NOT NULL,
    email          VARCHAR(150) UNIQUE NOT NULL,
    roll_number    VARCHAR(50) UNIQUE,
    department     VARCHAR(100),
    cgpa           DECIMAL(3,2),
    mobile         VARCHAR(15),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Applications Table
CREATE TABLE IF NOT EXISTS applications (
    application_id  INT AUTO_INCREMENT PRIMARY KEY,
    student_id      INT NOT NULL,
    internship_id   INT NOT NULL,
    applied_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('pending','shortlisted','selected','rejected') DEFAULT 'pending',
    remarks         TEXT,
    FOREIGN KEY (student_id)    REFERENCES students(student_id)     ON DELETE CASCADE,
    FOREIGN KEY (internship_id) REFERENCES internships(internship_id) ON DELETE CASCADE
);

-- Audit Logs Table
CREATE TABLE IF NOT EXISTS audit_logs (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    admin_user  VARCHAR(100) NOT NULL,
    action      VARCHAR(255) NOT NULL,
    entity_type VARCHAR(100),
    entity_id   INT,
    log_time    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details     TEXT
);

-- ============================================================
-- EXAM MODULE — Additional Tables
-- Run these after the existing schema.sql
-- ============================================================

-- Exams table (one exam per internship)
CREATE TABLE IF NOT EXISTS exams (
    exam_id        INT AUTO_INCREMENT PRIMARY KEY,
    internship_id  INT NOT NULL UNIQUE,
    exam_title     VARCHAR(255) NOT NULL,
    duration       INT NOT NULL DEFAULT 30,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (internship_id) REFERENCES internships(internship_id) ON DELETE CASCADE
);

-- Questions table
CREATE TABLE IF NOT EXISTS questions (
    question_id    INT AUTO_INCREMENT PRIMARY KEY,
    exam_id        INT NOT NULL,
    question_text  TEXT NOT NULL,
    option_a       VARCHAR(500) NOT NULL,
    option_b       VARCHAR(500) NOT NULL,
    option_c       VARCHAR(500) NOT NULL,
    option_d       VARCHAR(500) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    marks          INT NOT NULL DEFAULT 1,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE
);

-- Auto-save answers table
CREATE TABLE IF NOT EXISTS student_answers (
    answer_id       INT AUTO_INCREMENT PRIMARY KEY,
    student_id      INT NOT NULL,
    exam_id         INT NOT NULL,
    question_id     INT NOT NULL,
    selected_option CHAR(1),
    saved_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_student_question (student_id, question_id),
    FOREIGN KEY (student_id)  REFERENCES students(student_id)   ON DELETE CASCADE,
    FOREIGN KEY (exam_id)     REFERENCES exams(exam_id)         ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
);

-- Exam sessions (timer + resume)
CREATE TABLE IF NOT EXISTS exam_sessions (
    session_id  INT AUTO_INCREMENT PRIMARY KEY,
    student_id  INT NOT NULL,
    exam_id     INT NOT NULL,
    start_time  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    submitted   TINYINT(1) DEFAULT 0,
    UNIQUE KEY uq_student_exam (student_id, exam_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id)    REFERENCES exams(exam_id)       ON DELETE CASCADE
);

-- Results table
CREATE TABLE IF NOT EXISTS results (
    result_id    INT AUTO_INCREMENT PRIMARY KEY,
    student_id   INT NOT NULL,
    exam_id      INT NOT NULL,
    score        INT NOT NULL DEFAULT 0,
    total_marks  INT NOT NULL DEFAULT 0,
    percentage   DECIMAL(5,2) DEFAULT 0.00,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_result (student_id, exam_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id)    REFERENCES exams(exam_id)       ON DELETE CASCADE
);

-- ============================================================
-- STUDENT MODULE — Additional Schema
-- Run this AFTER the existing schema.sql
-- Adds authentication support for student login
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    user_id     INT AUTO_INCREMENT PRIMARY KEY,
    email       VARCHAR(150) UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL,      -- store hashed in production
    role        ENUM('student','admin') DEFAULT 'student',
    student_id  INT UNIQUE,                 -- FK to students table (NULL for admin)
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

ALTER TABLE applications
    ADD CONSTRAINT uq_student_internship
    UNIQUE (student_id, internship_id);

