<%@page import="com.vinod.pack.DBConnection"%>
<%@page import="com.vinod.pack.User"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
User user = (User) session.getAttribute("user");
if(user == null){
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Your Transactions | SecureBank</title>

<style>
body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; padding:0;}
.container {width:90%; max-width:1000px; margin:40px auto; background:white; padding:25px; border-radius:10px; box-shadow:0 0 10px rgba(0,0,0,0.2);}
h2 {text-align:center; color:#0078d7; margin-bottom:20px;}
table {width:100%; border-collapse:collapse; margin-top:15px;}
th, td {padding:12px; text-align:center; border-bottom:1px solid #ddd;}
th {background:#0078d7; color:white;}
tr:hover {background:#f1f1f1;}
.debit {color:red; font-weight:bold;}
.credit {color:green; font-weight:bold;}
.status-success {color:green; font-weight:bold;}
.status-failed {color:red; font-weight:bold;}
a.back {display:inline-block; margin-top:20px; text-decoration:none; background:#0078d7; color:white; padding:10px 15px; border-radius:6px;}
a.back:hover {background:#005fa3;}
</style>

</head>
<body>

<div class="container">
<h2>💳 Your Transactions</h2>

<table>
<tr>
<th>ID</th>
<th>Date</th>
<th>Description</th>
<th>Type</th>
<th>Amount (₹)</th>
<th>Status</th>
</tr>

<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    conn = DBConnection.getConnection();

    String sql = "SELECT * FROM BANK_TRANSACTIONS WHERE SENDER_ACCOUNT=? OR RECEIVER_ACCOUNT=? ORDER BY TXN_DATE DESC";
    ps = conn.prepareStatement(sql);
    ps.setString(1, user.getAccountNumber());
    ps.setString(2, user.getAccountNumber());
    rs = ps.executeQuery();

    NumberFormat formatter = NumberFormat.getCurrencyInstance(new java.util.Locale("en","IN"));
    boolean hasData = false;

    while(rs.next()){
        hasData = true;
        String sender = rs.getString("SENDER_ACCOUNT");
        String receiver = rs.getString("RECEIVER_ACCOUNT");
        boolean isDebit = sender.equals(user.getAccountNumber());

        double amt = rs.getDouble("AMOUNT");
        if(isDebit) amt = -amt; // negative for sent
%>

<tr>
<td><%=rs.getInt("TXN_ID")%></td>
<td><%=rs.getTimestamp("TXN_DATE")%></td>
<td><%=rs.getString("DESCRIPTION")%></td>
<td><%=rs.getString("TXN_TYPE")%></td>
<td class="<%=isDebit?"debit":"credit"%>"><%=formatter.format(amt)%></td>
<td class="<%= "SUCCESS".equalsIgnoreCase(rs.getString("STATUS")) ? "status-success" : "status-failed" %>"><%=rs.getString("STATUS")%></td>
</tr>

<%
    }

    if(!hasData){
%>
<tr>
<td colspan="6" style="color:gray;">No transactions found</td>
</tr>
<%
    }

} catch(Exception e){
%>
<tr>
<td colspan="6" style="color:red;">Error loading transactions: <%=e.getMessage()%></td>
</tr>
<%
} finally {
    if(rs != null) rs.close();
    if(ps != null) ps.close();
    if(conn != null) conn.close();
}
%>
</table>

<a href="dashboard.jsp" class="back">⬅ Back to Dashboard</a>
</div>

</body>
</html>