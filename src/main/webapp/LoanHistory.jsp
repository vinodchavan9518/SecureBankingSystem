<%@page import="com.vinod.pack.DBConnection, com.vinod.pack.User, java.sql.*"%>
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
<title>My Loans | SecureBank</title>
<link rel="stylesheet" href="style.css">
<style>
body {font-family: Arial; background:#f4f6f9; margin:0; padding:0;}
.container {width:90%; max-width:900px; margin:50px auto; background:white; padding:20px; border-radius:10px; box-shadow:0 0 10px rgba(0,0,0,0.2);}
h2{text-align:center; color:#0078d7; margin-bottom:20px;}
table {width:100%; border-collapse:collapse;}
th, td {padding:12px; text-align:center; border-bottom:1px solid #ddd;}
th {background:#0078d7; color:white;}
.status-approved{color:green; font-weight:bold;}
.status-pending{color:orange; font-weight:bold;}
.status-rejected{color:red; font-weight:bold;}
a.back{display:block; text-align:center; margin-top:15px; text-decoration:none; color:#0078d7;}
</style>
</head>

<body>

<header class="navbar">
<div class="container">
<h1 class="logo">💳 SecureBank</h1>
<nav>
<ul>
<li><a href="dashboard.jsp">Dashboard</a></li>
<li><a href="Transaction.jsp">Transactions</a></li>
<li><a href="profile.jsp">Profile</a></li>
<li><a href="SendMoney.jsp">Send Money</a></li>
<li><a href="ApplyLoan.jsp">Apply Loan</a></li>
<li><a href="LoanHistory.jsp" class="active">My Loans</a></li>
<li><a href="logout" class="logout-btn">Logout</a></li>
</ul>
</nav>
</div>
</header>

<div class="container">
<h2>My Loans</h2>

<table>
<tr>
<th>Loan ID</th>
<th>Amount (₹)</th>
<th>Loan Type</th>
<th>Duration (Months)</th>
<th>Status</th>
<th>Applied On</th>
</tr>

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    con = DBConnection.getConnection();
    String sql = "SELECT * FROM BANK_LOANS WHERE ACCOUNT_NUMBER=? ORDER BY APPLIED_DATE DESC";
    ps = con.prepareStatement(sql);
    ps.setString(1, user.getAccountNumber());
    rs = ps.executeQuery();

    boolean found = false;
    while(rs.next()) {
        found = true;
%>
<tr>
<td><%= rs.getInt("LOAN_ID") %></td>
<td>₹ <%= rs.getDouble("LOAN_AMOUNT") %></td>
<td><%= rs.getString("LOAN_TYPE") %></td>
<td><%= rs.getInt("DURATION_MONTHS") %></td>
<td class="<%= rs.getString("STATUS").equalsIgnoreCase("APPROVED")?"status-approved":rs.getString("STATUS").equalsIgnoreCase("PENDING")?"status-pending":"status-rejected" %>">
<%= rs.getString("STATUS") %></td>
<td><%= rs.getTimestamp("APPLIED_DATE") %></td>
</tr>
<%
    }

    if(!found){
%>
<tr>
<td colspan="6">No loans found</td>
</tr>
<%
    }

} catch(Exception e){
    out.println("<tr><td colspan='6'>Error loading loans</td></tr>");
    e.printStackTrace();
} finally {
    try { if(rs != null) rs.close(); } catch(Exception e){}
    try { if(ps != null) ps.close(); } catch(Exception e){}
    try { if(con != null) con.close(); } catch(Exception e){}
}
%>

</table>

<a href="dashboard.jsp" class="back">⬅ Back to Dashboard</a>
</div>

</body>
</html>