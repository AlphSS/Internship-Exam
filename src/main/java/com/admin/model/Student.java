package com.admin.model;

/**
 * JavaBean representing a Student.
 * Maps to the existing 'students' table + 'users' table (for auth).
 * Package kept as com.admin.model for consistency with existing system.
 */
public class Student {

    // Fields from students table
    private int    studentId;
    private String fullName;
    private String email;
    private String rollNumber;
    private String department;
    private double cgpa;
    private String mobile;
    private String createdAt;

    // Field from users table (auth)
    private String password;
    private int    userId;

    public Student() {}

    // ── Getters & Setters ──────────────────────────────────────────────────

    public int    getStudentId()                    { return studentId; }
    public void   setStudentId(int v)               { this.studentId = v; }

    public String getFullName()                     { return fullName; }
    public void   setFullName(String v)             { this.fullName = v; }

    public String getEmail()                        { return email; }
    public void   setEmail(String v)                { this.email = v; }

    public String getRollNumber()                   { return rollNumber; }
    public void   setRollNumber(String v)           { this.rollNumber = v; }

    public String getDepartment()                   { return department; }
    public void   setDepartment(String v)           { this.department = v; }

    public double getCgpa()                         { return cgpa; }
    public void   setCgpa(double v)                 { this.cgpa = v; }

    public String getMobile()                       { return mobile; }
    public void   setMobile(String v)               { this.mobile = v; }

    public String getCreatedAt()                    { return createdAt; }
    public void   setCreatedAt(String v)            { this.createdAt = v; }

    public String getPassword()                     { return password; }
    public void   setPassword(String v)             { this.password = v; }

    public int    getUserId()                       { return userId; }
    public void   setUserId(int v)                  { this.userId = v; }
}
