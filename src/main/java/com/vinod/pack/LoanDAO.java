package com.vinod.pack;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LoanDAO {

    public boolean applyLoan(Connection con, Loan loan, String accountNumber) {
        boolean result = false;
        try {
            String sql = "INSERT INTO BANK_LOANS (ACCOUNT_NUMBER, AMOUNT, TYPE, DURATION_MONTHS, STATUS, APPLICATION_DATE) " +
                         "VALUES (?, ?, ?, ?, ?, SYSDATE)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, accountNumber);
            ps.setDouble(2, loan.getAmount());
            ps.setString(3, loan.getType());
            ps.setInt(4, loan.getDurationMonths());
            ps.setString(5, "PENDING");
            int i = ps.executeUpdate();
            if(i > 0) result = true;
        } catch(Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Loan> getUserLoans(Connection con, String accountNumber) {
        List<Loan> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM BANK_LOANS WHERE ACCOUNT_NUMBER=? ORDER BY APPLICATION_DATE DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, accountNumber);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Loan loan = new Loan();
                loan.setLoanId(rs.getInt("LOAN_ID"));
                loan.setAmount(rs.getDouble("AMOUNT"));
                loan.setType(rs.getString("TYPE"));
                loan.setDurationMonths(rs.getInt("DURATION_MONTHS"));
                loan.setStatus(rs.getString("STATUS"));
                loan.setApplicationDate(rs.getDate("APPLICATION_DATE"));
                list.add(loan);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}