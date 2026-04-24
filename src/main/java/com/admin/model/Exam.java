package com.admin.model;

/**
 * JavaBean representing an Exam linked to a specific Internship.
 */
public class Exam {

    private int    examId;
    private int    internshipId;
    private String internshipTitle; // joined field for display
    private String companyName;     // joined field for display
    private String examTitle;
    private int    duration;        // in minutes
    private String createdAt;
    private int    questionCount;   // aggregated field

    public Exam() {}

    public int    getExamId()                        { return examId; }
    public void   setExamId(int examId)              { this.examId = examId; }

    public int    getInternshipId()                  { return internshipId; }
    public void   setInternshipId(int v)             { this.internshipId = v; }

    public String getInternshipTitle()               { return internshipTitle; }
    public void   setInternshipTitle(String v)       { this.internshipTitle = v; }

    public String getCompanyName()                   { return companyName; }
    public void   setCompanyName(String v)           { this.companyName = v; }

    public String getExamTitle()                     { return examTitle; }
    public void   setExamTitle(String v)             { this.examTitle = v; }

    public int    getDuration()                      { return duration; }
    public void   setDuration(int v)                 { this.duration = v; }

    public String getCreatedAt()                     { return createdAt; }
    public void   setCreatedAt(String v)             { this.createdAt = v; }

    public int    getQuestionCount()                 { return questionCount; }
    public void   setQuestionCount(int v)            { this.questionCount = v; }
}
