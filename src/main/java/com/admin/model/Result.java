package com.admin.model;

/**
 * JavaBean representing a student's exam result after auto-evaluation.
 */
public class Result {

    private int    resultId;
    private int    studentId;
    private int    examId;
    private int    score;
    private int    totalMarks;
    private double percentage;
    private String submittedAt;

    // Joined fields for display
    private String studentName;
    private String rollNumber;
    private String department;
    private String examTitle;
    private String internshipTitle;
    private String companyName;

    public Result() {}

    public int    getResultId()                      { return resultId; }
    public void   setResultId(int v)                 { this.resultId = v; }

    public int    getStudentId()                     { return studentId; }
    public void   setStudentId(int v)                { this.studentId = v; }

    public int    getExamId()                        { return examId; }
    public void   setExamId(int v)                   { this.examId = v; }

    public int    getScore()                         { return score; }
    public void   setScore(int v)                    { this.score = v; }

    public int    getTotalMarks()                    { return totalMarks; }
    public void   setTotalMarks(int v)               { this.totalMarks = v; }

    public double getPercentage()                    { return percentage; }
    public void   setPercentage(double v)            { this.percentage = v; }

    public String getSubmittedAt()                   { return submittedAt; }
    public void   setSubmittedAt(String v)           { this.submittedAt = v; }

    public String getStudentName()                   { return studentName; }
    public void   setStudentName(String v)           { this.studentName = v; }

    public String getRollNumber()                    { return rollNumber; }
    public void   setRollNumber(String v)            { this.rollNumber = v; }

    public String getDepartment()                    { return department; }
    public void   setDepartment(String v)            { this.department = v; }

    public String getExamTitle()                     { return examTitle; }
    public void   setExamTitle(String v)             { this.examTitle = v; }

    public String getInternshipTitle()               { return internshipTitle; }
    public void   setInternshipTitle(String v)       { this.internshipTitle = v; }

    public String getCompanyName()                   { return companyName; }
    public void   setCompanyName(String v)           { this.companyName = v; }
}
