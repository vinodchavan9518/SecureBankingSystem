<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@page import="com.vinod.pack.User"%>
<%@page import="com.vinod.pack.DBConnection"%>
<%@ page import="java.sql.*"%>

<%

User user = (User) session.getAttribute("user");

if (user == null) {
response.sendRedirect("index.jsp");
return;
}

%>

<!DOCTYPE html>
<html>

<head>

<title>SecureBank Dashboard</title>

<style>

body{
font-family: Arial;
margin:0;
background:#f4f6f9;
}

header{
background:#0078d7;
color:white;
padding:15px;
}

.container{
width:90%;
margin:auto;
}

.card{
background:white;
padding:20px;
margin-top:20px;
border-radius:8px;
box-shadow:0 0 10px rgba(0,0,0,0.1);
}

.balance{
font-size:28px;
color:green;
}

.menu{
margin-top:20px;
}

.menu a{
display:inline-block;
margin-right:10px;
padding:10px 15px;
background:#0078d7;
color:white;
text-decoration:none;
border-radius:5px;
}

.menu a:hover{
background:#005fa3;
}

table{
width:100%;
border-collapse:collapse;
margin-top:20px;
}

th,td{
padding:10px;
border-bottom:1px solid #ddd;
text-align:center;
}

th{
background:#0078d7;
color:white;
}

</style>

</head>

<body>

<header>

<div class="container">

<h2>💳 SecureBank Dashboard</h2>

</div>

</header>

<div class="container">

<div class="card">

<h3>Welcome, <%=user.getFullName()%></h3>

<p><b>Account Number:</b> <%=user.getAccountNumber()%></p>

<p class="balance">Balance: ₹ <%=user.getBalance()%></p>

</div>

<div class="menu">

<a href="SendMoney.jsp">Send Money</a>
<a href="Transaction.jsp">Transactions</a>
<a href="profile.jsp">Profile</a>
<a href="ApplyLoan.jsp">Apply Loan</a>
<a href="logout">Logout</a>

</div>

<div class="card">

<h3>Recent Transactions</h3>

<table>

<tr>
<th>ID</th>
<th>Date</th>
<th>Description</th>
<th>Amount</th>
<th>Status</th>
</tr>

<%

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

con = DBConnection.getConnection();

String sql = "SELECT * FROM BANK_TRANSACTIONS WHERE SENDER_ACCOUNT=? OR RECEIVER_ACCOUNT=? ORDER BY TXN_DATE DESC";

ps = con.prepareStatement(sql);

ps.setString(1, user.getAccountNumber());
ps.setString(2, user.getAccountNumber());

rs = ps.executeQuery();

while (rs.next()) {

%>

<tr>

<td><%=rs.getInt("TXN_ID")%></td>

<td><%=rs.getDate("TXN_DATE")%></td>

<td><%=rs.getString("DESCRIPTION")%></td>

<td>₹ <%=rs.getDouble("AMOUNT")%></td>

<td><%=rs.getString("STATUS")%></td>

</tr>

<%

}

} catch (Exception e) {

out.println("Error loading transactions");

} finally {

if(rs!=null)rs.close();
if(ps!=null)ps.close();
if(con!=null)con.close();

}

%>

</table>

</div>

</div>

</body>

</html>