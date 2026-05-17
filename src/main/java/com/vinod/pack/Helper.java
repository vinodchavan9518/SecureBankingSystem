package com.vinod.pack;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Helper {

	public double getBalance(String accountNumber) {
	    double balance = 0;
	    try {
	    	Connection conn = DBConnection.getConnection();
	    
	         PreparedStatement ps = conn.prepareStatement("SELECT BALANCE FROM BANK_USERS WHERE ACCOUNT_NUMBER = ?");
	        ps.setString(1, accountNumber);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            balance = rs.getDouble("BALANCE");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return balance;
	}

	public List<Transaction> getRecentTransactions(String accountNumber) {
	    List<Transaction> list = new ArrayList<>();
	    String sql = "SELECT * FROM BANK_TRANSACTIONS WHERE SENDER_ACCOUNT = ? OR RECEIVER_ACCOUNT = ? ORDER BY TXN_DATE DESC FETCH FIRST 5 ROWS ONLY";
	    try {
	    	Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	        ps.setString(1, accountNumber);
	        ps.setString(2, accountNumber);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Transaction t = new Transaction();
	            t.setTxnId(rs.getInt("TXN_ID"));
	            t.setSenderAccount(rs.getString("SENDER_ACCOUNT"));
	            t.setReceiverAccount(rs.getString("RECEIVER_ACCOUNT"));
	            t.setAmount(rs.getDouble("AMOUNT"));
	            t.setTxnType(rs.getString("TXN_TYPE"));
	            t.setDescription(rs.getString("DESCRIPTION"));
	            t.setStatus(rs.getString("STATUS"));
	            t.setTxnDate(rs.getDate("TXN_DATE"));
	            list.add(t);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
}
