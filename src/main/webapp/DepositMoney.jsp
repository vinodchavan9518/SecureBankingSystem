<%@ page import="com.vinod.pack.DBConnection, com.vinod.pack.User, java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
User user = (User) session.getAttribute("user");
if(user == null){
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Deposit Money | SecureBank</title>
<style>
body{font-family: Arial; background:#f4f6f9; margin:0; padding:0;}
.container{width:400px; margin:60px auto; background:white; padding:25px; border-radius:10px; box-shadow:0 0 10px #ccc;}
h2{text-align:center; color:#0078d7;}
input[type=number]{width:100%; padding:10px; margin:8px 0 15px 0; border:1px solid #ccc; border-radius:6px;}
button{width:100%; padding:12px; background:#0078d7; color:white; border:none; border-radius:6px; font-size:16px; cursor:pointer;}
button:hover{background:#005fa3;}
.success{color:green; text-align:center; margin-top:15px;}
.error{color:red; text-align:center; margin-top:15px;}
a.back{display:block; text-align:center; margin-top:15px; text-decoration:none; color:#0078d7;}
</style>
</head>
<body>

<div class="container">
<h2>💰 Deposit Money</h2>

<form method="post">
<label>Amount to Deposit (₹)</label>
<input type="number" name="amount" required min="1">
<button type="submit">Deposit</button>
</form>

<%
if("POST".equalsIgnoreCase(request.getMethod())){
    double amount = 0;
    try{
        amount = Double.parseDouble(request.getParameter("amount"));
    }catch(Exception e){
        out.println("<p class='error'>Invalid amount</p>");
        return;
    }

    if(amount <= 0){
        out.println("<p class='error'>Amount must be greater than 0</p>");
        return;
    }

    Connection con = null;
    try{
        con = DBConnection.getConnection();
        con.setAutoCommit(false);

        // 1️⃣ Update user balance
        PreparedStatement ps = con.prepareStatement(
            "UPDATE BANK_USERS SET BALANCE = BALANCE + ? WHERE ACCOUNT_NUMBER=?"
        );
        ps.setDouble(1, amount);
        ps.setString(2, user.getAccountNumber());
        ps.executeUpdate();

        // 2️⃣ Record transaction
        PreparedStatement psTxn = con.prepareStatement(
            "INSERT INTO BANK_TRANSACTIONS (SENDER_ACCOUNT, RECEIVER_ACCOUNT, AMOUNT, TXN_TYPE, DESCRIPTION, STATUS, TXN_DATE) " +
            "VALUES (?,?,?,?,?,?,SYSDATE)"
        );
        psTxn.setString(1, "BANK"); // BANK is sender for deposit
        psTxn.setString(2, user.getAccountNumber());
        psTxn.setDouble(3, amount);
        psTxn.setString(4, "DEPOSIT");
        psTxn.setString(5, "Cash Deposit");
        psTxn.setString(6, "SUCCESS");
        psTxn.executeUpdate();

        con.commit();

        // 3️⃣ Update session balance
        user.setBalance(user.getBalance() + amount);

        out.println("<p class='success'>₹" + amount + " deposited successfully!</p>");

    }catch(Exception e){
        if(con != null) con.rollback();
        out.println("<p class='error'>Transaction Failed: " + e.getMessage() + "</p>");
    }finally{
        if(con != null) con.close();
    }
}
%>

<a href="dashboard.jsp" class="back">⬅ Back to Dashboard</a>
</div>

</body>
</html>