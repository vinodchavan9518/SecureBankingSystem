package com.vinod.pack;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TransactionDAO {

    // Transfer Amount Method
    public boolean transferAmount(String senderAccount, String receiverAccount, double amount) {

        if (amount <= 0) return false; // Reject invalid amounts

        String getBalanceSQL = "SELECT BALANCE FROM BANK_USERS WHERE ACCOUNT_NUMBER = ?";
        String debitSQL = "UPDATE BANK_USERS SET BALANCE = BALANCE - ? WHERE ACCOUNT_NUMBER = ?";
        String creditSQL = "UPDATE BANK_USERS SET BALANCE = BALANCE + ? WHERE ACCOUNT_NUMBER = ?";
        String insertTxnSQL = "INSERT INTO BANK_TRANSACTIONS "
                + "(SENDER_ACCOUNT, RECEIVER_ACCOUNT, AMOUNT, TXN_TYPE, DESCRIPTION, STATUS, TXN_DATE) "
                + "VALUES (?, ?, ?, ?, ?, ?, SYSDATE)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1️⃣ Check Sender Balance
            double senderBalance;
            try (PreparedStatement balStmt = conn.prepareStatement(getBalanceSQL)) {
                balStmt.setString(1, senderAccount);
                try (ResultSet rs = balStmt.executeQuery()) {
                    if (rs.next()) {
                        senderBalance = rs.getDouble("BALANCE");
                    } else {
                        insertFailedTransaction(conn, senderAccount, receiverAccount, amount, "SENDER NOT FOUND");
                        conn.rollback();
                        return false;
                    }
                }
            }

            if (senderBalance < amount) {
                insertFailedTransaction(conn, senderAccount, receiverAccount, amount, "INSUFFICIENT BALANCE");
                conn.rollback();
                return false;
            }

            // 2️⃣ Perform Debit & Credit
            try (
                PreparedStatement debitStmt = conn.prepareStatement(debitSQL);
                PreparedStatement creditStmt = conn.prepareStatement(creditSQL);
                PreparedStatement txnStmt = conn.prepareStatement(insertTxnSQL)
            ) {
                // Debit sender
                debitStmt.setDouble(1, amount);
                debitStmt.setString(2, senderAccount);
                int debited = debitStmt.executeUpdate();

                // Credit receiver
                creditStmt.setDouble(1, amount);
                creditStmt.setString(2, receiverAccount);
                int credited = creditStmt.executeUpdate();

                if (debited > 0 && credited > 0) {
                    // Log sender debit
                    txnStmt.setString(1, senderAccount);
                    txnStmt.setString(2, receiverAccount);
                    txnStmt.setDouble(3, amount);
                    txnStmt.setString(4, "Debit");
                    txnStmt.setString(5, "Money sent to " + receiverAccount);
                    txnStmt.setString(6, "SUCCESS");
                    txnStmt.executeUpdate();

                    // Log receiver credit
                    txnStmt.setString(1, senderAccount);
                    txnStmt.setString(2, receiverAccount);
                    txnStmt.setDouble(3, amount);
                    txnStmt.setString(4, "Credit");
                    txnStmt.setString(5, "Money received from " + senderAccount);
                    txnStmt.setString(6, "SUCCESS");
                    txnStmt.executeUpdate();

                    conn.commit();
                    return true;
                } else {
                    insertFailedTransaction(conn, senderAccount, receiverAccount, amount, "ACCOUNT NOT FOUND OR UPDATE FAILED");
                    conn.rollback();
                    return false;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Failed Transaction Logger
    private void insertFailedTransaction(Connection conn, String sender, String receiver, double amount, String reason)
            throws SQLException {
        String sql = "INSERT INTO BANK_TRANSACTIONS "
                + "(SENDER_ACCOUNT, RECEIVER_ACCOUNT, AMOUNT, TXN_TYPE, DESCRIPTION, STATUS, TXN_DATE) "
                + "VALUES (?, ?, ?, 'TRANSFER', ?, 'FAILED', SYSDATE)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sender);
            ps.setString(2, receiver);
            ps.setDouble(3, amount);
            ps.setString(4, "Transaction Failed: " + reason);
            ps.executeUpdate();
        }
    }
}