<%@page import="com.vinod.pack.User"%>
<%@page import="com.vinod.pack.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

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
<title>Deposit / Withdraw | SecureBank</title>
<style>
body {font-family: Arial; background:#f4f6f9; margin:0; padding:0;}
.container {width:400px; margin:60px auto; background:white; padding:25px; border-radius:10px; box-shadow:0 0 10px #ccc;}
h2{text-align:center; color:#0078d7; margin-bottom:20px;}
label{font-weight:bold;}
input[type=number]{width:100%; padding:10px; margin:8px 0 15px 0; border:1px solid #ccc; border-radius:6px;}
button{width:100%; padding:12px; background:#0078d7; color:white; border:none; border-radius:6px; font-size:16px; cursor:pointer;}
button:hover{background:#005fa3;}
a.back{display:block; text-align:center; margin-top:15px; text-decoration:none; color:#0078d7;}
.error{color:red;text-align:center;margin-top:10px;}
.success{color:green;text-align:center;margin-top:10px;}
</style>
</head>
<body>
<div class="container">
<h2>💰 Deposit / Withdraw</h2>

<form method="post" action="GenerateOTP">
<label>Amount (₹)</label>
<input type="number" name="amount" required min="1">

<label>Transaction Type</label>
<select name="txnType" required style="width:100%; padding:10px; margin-bottom:15px;">
<option value="DEPOSIT">Deposit</option>
<option value="WITHDRAW">Withdraw</option>
</select>

<button type="submit">Proceed</button>
</form>

<a href="dashboard.jsp" class="back">⬅ Back to Dashboard</a>
</div>
</body>
</html>