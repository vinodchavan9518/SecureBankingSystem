<%@page import="com.vinod.pack.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // Check Customer Login
   User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index.html");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Apply Loan</title>
 <link rel="stylesheet" href="style.css" />
<style>
    body {
        background: #eef3f8;
        font-family: Arial, sans-serif;
    }
    .loan-box {
        width: 400px;
        margin: 60px auto;
        background: white;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
    }
    .loan-box h3 {
        text-align: center;
        margin-bottom: 20px;
        color: #004aad;
    }
    label {
        font-weight: bold;
    }
    .btn {
        width: 100%;
        background: #004aad;
        border: none;
        padding: 12px;
        color: white;
        border-radius: 7px;
        cursor: pointer;
    }
    .btn:hover {
        background: #003580;
    }
    .msg {
        text-align: center;
        margin-top: 10px;
        color: red;
    }
</style>
</head>

<body>
<header class="navbar">
    <div class="container">
        <h1 class="logo">💳 SecureBank</h1>
        <nav>
            <ul>
                <li><a href="dashboard.jsp" class="active">Dashboard</a></li>
                <li><a href="Transaction.jsp">Transactions</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="SendMoney.jsp">Send Money</a></li>
                <li><a href="ApplyLoan.jsp">Apply Loan</a></li>
                
                <li><a href="logout" class="logout-btn">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>
<div class="loan-box">
    <h3>Apply for Loan</h3>

    <form action="ApplyLoanServlet" method="post">
        <input type="hidden" name="customerId" value="<%= user.getUserId() %>">

        <!-- Loan Amount -->
        <label>Loan Amount (₹)</label>
        <input type="number" name="amount" class="form-control" required style="width:100%; padding:8px; margin-bottom:15px;">

        <!-- Loan Type -->
        <label>Loan Type</label>
        <select name="loanType" class="form-control" required style="width:100%; padding:8px; margin-bottom:15px;">
            <option value="">-- Select Loan Type --</option>
            <option>Home Loan</option>
            <option>Personal Loan</option>
            <option>Education Loan</option>
            <option>Vehicle Loan</option>
            <option>Business Loan</option>
        </select>

        <!-- Loan Duration -->
        <label>Duration (Months)</label>
        <input type="number" name="duration" required class="form-control" style="width:100%; padding:8px; margin-bottom:15px;">

        <button class="btn">Submit Application</button>
    </form>

    <p class="msg">${msg}</p>
</div>

</body>
</html>
