<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>


<%@page import="com.vinod.pack.DBConnection"%>
<%@page import="com.vinod.pack.User"%>
<%@page import="java.sql.*"%>


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
<title>Send Money</title>

<style>

body{
font-family: Arial;
background:#f4f6f9;
margin:0;
padding:0;
}

.container{
width:420px;
margin:60px auto;
background:white;
padding:25px;
border-radius:10px;
box-shadow:0 0 10px rgba(0,0,0,0.2);
}

h2{
text-align:center;
color:#0078d7;
margin-bottom:20px;
}

label{
font-weight:bold;
}

input[type=text],input[type=number]{
width:100%;
padding:10px;
margin:8px 0 15px 0;
border:1px solid #ccc;
border-radius:6px;
}

button{
width:100%;
padding:12px;
background:#0078d7;
color:white;
border:none;
border-radius:6px;
font-size:16px;
cursor:pointer;
}

button:hover{
background:#005fa3;
}

.success{
color:green;
text-align:center;
margin-top:15px;
}

.error{
color:red;
text-align:center;
margin-top:15px;
}

a.back{
display:block;
text-align:center;
margin-top:15px;
text-decoration:none;
color:#0078d7;
}

</style>

</head>

<body>

<div class="container">

<h2>💸 Send Money</h2>

<form method="post">

<label>Recipient Account Number or Mobile</label>
<input type="text" name="receiver" required placeholder="Enter account or mobile number">

<label>Amount (₹)</label>
<input type="number" name="amount" required min="1">

<label>Description</label>
<input type="text" name="description" placeholder="Purpose (optional)">

<button type="submit">Send Money</button>


</form>

<%

if("POST".equalsIgnoreCase(request.getMethod())){

String receiver=request.getParameter("receiver").trim();
String description=request.getParameter("description");
double amount=0;

try{
amount=Double.parseDouble(request.getParameter("amount"));
}
catch(Exception e)
{
out.println("<p class='error'>Invalid amount</p>");
return;
}
if(amount <= 0){ out.println("<p style='color:red'>Amount must be > 0</p>"); return; }

Connection con=null;

try{

con=DBConnection.getConnection();
con.setAutoCommit(false);

String senderAccount=user.getAccountNumber();

/* Check sender balance */

PreparedStatement ps=con.prepareStatement(
"SELECT BALANCE FROM BANK_USERS WHERE ACCOUNT_NUMBER=?");

ps.setString(1,senderAccount);

ResultSet rs=ps.executeQuery();

if(!rs.next()){
out.println("<p class='error'>Sender not found</p>");return;}



double senderBalance=rs.getDouble("BALANCE");

if(senderBalance < amount){ out.println("<p style='color:red'>Insufficient Balance</p>"); return; }



/* Find receiver */

PreparedStatement ps2=con.prepareStatement(
"SELECT ACCOUNT_NUMBER,FULL_NAME,BALANCE FROM BANK_USERS WHERE ACCOUNT_NUMBER=? OR PHONE_NUMBER=?");

ps2.setString(1,receiver);
ps2.setString(2,receiver);

ResultSet rs2=ps2.executeQuery();

if(!rs2.next()){
out.println("<p style='color:red'>Receiver not found</p>"); return; }



String receiverAccount=rs2.getString("ACCOUNT_NUMBER");
String receiverName=rs2.getString("FULL_NAME");
double receiverBalance=rs2.getDouble("BALANCE");

if(senderAccount.equals(receiverAccount)){
out.println("<p class='error'>Cannot send money to your own account</p>");return;}

/* Deduct sender balance */

PreparedStatement ps3=con.prepareStatement(
"UPDATE BANK_USERS SET BALANCE=? WHERE ACCOUNT_NUMBER=?");

ps3.setDouble(1,senderBalance-amount);
ps3.setString(2,senderAccount);
ps3.executeUpdate();

/* Add receiver balance */

PreparedStatement ps4=con.prepareStatement(
"UPDATE BANK_USERS SET BALANCE=? WHERE ACCOUNT_NUMBER=?");

ps4.setDouble(1,receiverBalance+amount);
ps4.setString(2,receiverAccount);
ps4.executeUpdate();

/* Insert transaction */

PreparedStatement ps5=con.prepareStatement(
"INSERT INTO BANK_TRANSACTIONS (SENDER_ACCOUNT,RECEIVER_ACCOUNT,AMOUNT,TXN_TYPE,DESCRIPTION,STATUS,TXN_DATE) VALUES (?,?,?,?,?,?,SYSDATE)");

ps5.setString(1,senderAccount);
ps5.setString(2,receiverAccount);
ps5.setDouble(3,amount);
ps5.setString(4,"TRANSFER");
ps5.setString(5,(description==null||description.isEmpty())?"Money Transfer":description);
ps5.setString(6,"SUCCESS");

ps5.executeUpdate();

con.commit();

/* Update session balance */

user.setBalance(senderBalance-amount);

out.println("<p class='success'>₹ "+amount+" sent successfully to "+receiverName+"</p>");



}catch(Exception e){

if(con!=null) con.rollback();

out.println("<p class='error'>Transaction Failed:"+e.getMessage()+"</p>");

}finally{

if(con!=null) con.close();

}

}

%>

<a href="dashboard.jsp" class="back">⬅ Back to Dashboard</a>

</div>

</body>
</html>