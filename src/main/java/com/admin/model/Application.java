package com.admin.model;

/**
 * JavaBean representing a student's internship Application.
 */
public class Application {

    private int    applicationId;
    private int    studentId;
    private int    internshipId;
    private String appliedAt;
    private String status;       // pending | shortlisted | selected | rejected
    private String remarks;

    // ── Joined fields for display ──────────────────────────────────────────
    private String studentName;
    private String studentEmail;
    private String rollNumber;
    private String department;
    private double cgpa;
    private String mobile;

    private String internshipTitle;
    private String companyName;

    public Application() {}

    // ── Getters & Setters ──────────────────────────────────────────────────

    public int    getApplicationId()   { return applicationId; }
    public void   setApplicationId(int applicationId) { this.applicationId = applicationId; }

    public int    getStudentId()       { return studentId; }
    public void   setStudentId(int studentId) { this.studentId = studentId; }

    public int    getInternshipId()    { return internshipId; }
    public void   setInternshipId(int internshipId) { this.internshipId = internshipId; }

    public String getAppliedAt()       { return appliedAt; }
    public void   setAppliedAt(String appliedAt) { this.appliedAt = appliedAt; }

    public String getStatus()          { return status; }
    public void   setStatus(String status) { this.status = status; }

    public String getRemarks()         { return remarks; }
    public void   setRemarks(String remarks) { this.remarks = remarks; }

    public String getStudentName()     { return studentName; }
    public void   setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentEmail()    { return studentEmail; }
    public void   setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }

    public String getRollNumber()      { return rollNumber; }
    public void   setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }

    public String getDepartment()      { return department; }
    public void   setDepartment(String department) { this.department = department; }

    public double getCgpa()            { return cgpa; }
    public void   setCgpa(double cgpa) { this.cgpa = cgpa; }

    public String getMobile()          { return mobile; }
    public void   setMobile(String mobile) { this.mobile = mobile; }

    public String getInternshipTitle() { return internshipTitle; }
    public void   setInternshipTitle(String internshipTitle) { this.internshipTitle = internshipTitle; }

    public String getCompanyName()     { return companyName; }
    public void   setCompanyName(String companyName) { this.companyName = companyName; }
}
