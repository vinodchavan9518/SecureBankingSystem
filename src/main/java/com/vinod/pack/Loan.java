package com.vinod.pack;

import java.util.Date;

public class Loan {

    private int loanId;
    private double amount;
    private String type;
    private int durationMonths;
    private String status;
    private Date applicationDate;

    // ===== Getters and Setters =====

    public int getLoanId() {
        return loanId;
    }

    public void setLoanId(int loanId) {
        this.loanId = loanId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getDurationMonths() {
        return durationMonths;
    }

    public void setDurationMonths(int durationMonths) {
        this.durationMonths = durationMonths;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getApplicationDate() {
        return applicationDate;
    }

    public void setApplicationDate(Date applicationDate) {
        this.applicationDate = applicationDate;
    }

    // Optional: toString method for debugging
    @Override
    public String toString() {
        return "Loan{" +
                "loanId=" + loanId +
                ", amount=" + amount +
                ", type='" + type + '\'' +
                ", durationMonths=" + durationMonths +
                ", status='" + status + '\'' +
                ", applicationDate=" + applicationDate +
                '}';
    }
}