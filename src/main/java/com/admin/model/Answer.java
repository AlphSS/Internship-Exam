package com.admin.model;

/**
 * JavaBean representing a student's saved answer for one question.
 * Used for auto-save and resume functionality.
 */
public class Answer {

    private int    answerId;
    private int    studentId;
    private int    examId;
    private int    questionId;
    private String selectedOption; // 'A','B','C','D'
    private String savedAt;

    public Answer() {}

    public int    getAnswerId()                      { return answerId; }
    public void   setAnswerId(int v)                 { this.answerId = v; }

    public int    getStudentId()                     { return studentId; }
    public void   setStudentId(int v)                { this.studentId = v; }

    public int    getExamId()                        { return examId; }
    public void   setExamId(int v)                   { this.examId = v; }

    public int    getQuestionId()                    { return questionId; }
    public void   setQuestionId(int v)               { this.questionId = v; }

    public String getSelectedOption()                { return selectedOption; }
    public void   setSelectedOption(String v)        { this.selectedOption = v; }

    public String getSavedAt()                       { return savedAt; }
    public void   setSavedAt(String v)               { this.savedAt = v; }
}
