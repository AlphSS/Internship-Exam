package com.admin.model;

/**
 * JavaBean representing an Internship entity.
 */
public class Internship {

    private int     internshipId;
    private int     companyId;
    private String  companyName;   // Joined from companies table for display
    private String  title;
    private String  description;
    private double  stipend;
    private int     durationMonths;
    private double  minCgpa;       // CGPA eligibility threshold
    private int     vacancies;
    private String  startDate;
    private String  endDate;
    private String  status;        // 'open' | 'closed'
    private String  createdAt;

    public Internship() {}

    // ── Getters & Setters ──────────────────────────────────────────────────

    public int    getInternshipId()    { return internshipId; }
    public void   setInternshipId(int internshipId) { this.internshipId = internshipId; }

    public int    getCompanyId()       { return companyId; }
    public void   setCompanyId(int companyId) { this.companyId = companyId; }

    public String getCompanyName()     { return companyName; }
    public void   setCompanyName(String companyName) { this.companyName = companyName; }

    public String getTitle()           { return title; }
    public void   setTitle(String title) { this.title = title; }

    public String getDescription()     { return description; }
    public void   setDescription(String description) { this.description = description; }

    public double getStipend()         { return stipend; }
    public void   setStipend(double stipend) { this.stipend = stipend; }

    public int    getDurationMonths()  { return durationMonths; }
    public void   setDurationMonths(int durationMonths) { this.durationMonths = durationMonths; }

    public double getMinCgpa()         { return minCgpa; }
    public void   setMinCgpa(double minCgpa) { this.minCgpa = minCgpa; }

    public int    getVacancies()       { return vacancies; }
    public void   setVacancies(int vacancies) { this.vacancies = vacancies; }

    public String getStartDate()       { return startDate; }
    public void   setStartDate(String startDate) { this.startDate = startDate; }

    public String getEndDate()         { return endDate; }
    public void   setEndDate(String endDate) { this.endDate = endDate; }

    public String getStatus()          { return status; }
    public void   setStatus(String status) { this.status = status; }

    public String getCreatedAt()       { return createdAt; }
    public void   setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
