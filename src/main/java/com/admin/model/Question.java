package com.admin.model;

/**
 * JavaBean representing a single MCQ Question within an Exam.
 */
public class Question {

    private int    questionId;
    private int    examId;
    private String questionText;
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private char   correctOption; // 'A','B','C','D'
    private int    marks;
    private String createdAt;

    // Transient field — student's selected option (populated during exam)
    private String selectedOption;

    public Question() {}

    public int    getQuestionId()                    { return questionId; }
    public void   setQuestionId(int v)               { this.questionId = v; }

    public int    getExamId()                        { return examId; }
    public void   setExamId(int v)                   { this.examId = v; }

    public String getQuestionText()                  { return questionText; }
    public void   setQuestionText(String v)          { this.questionText = v; }

    public String getOptionA()                       { return optionA; }
    public void   setOptionA(String v)               { this.optionA = v; }

    public String getOptionB()                       { return optionB; }
    public void   setOptionB(String v)               { this.optionB = v; }

    public String getOptionC()                       { return optionC; }
    public void   setOptionC(String v)               { this.optionC = v; }

    public String getOptionD()                       { return optionD; }
    public void   setOptionD(String v)               { this.optionD = v; }

    public char   getCorrectOption()                 { return correctOption; }
    public void   setCorrectOption(char v)           { this.correctOption = v; }

    public int    getMarks()                         { return marks; }
    public void   setMarks(int v)                    { this.marks = v; }

    public String getCreatedAt()                     { return createdAt; }
    public void   setCreatedAt(String v)             { this.createdAt = v; }

    public String getSelectedOption()                { return selectedOption; }
    public void   setSelectedOption(String v)        { this.selectedOption = v; }
}
