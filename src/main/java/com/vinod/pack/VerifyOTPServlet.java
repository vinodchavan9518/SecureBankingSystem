package com.vinod.pack;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/VerifyOTPServlet")
public class VerifyOTPServlet extends HttpServlet{

protected void doPost(HttpServletRequest request,HttpServletResponse response)
throws ServletException,IOException{

HttpSession session=request.getSession();

User user=(User)session.getAttribute("user");

if(user==null){
response.sendRedirect("index.jsp");
return;
}

String otpInput=request.getParameter("otp");
Integer otpSession=(Integer)session.getAttribute("otp_code");

if(otpSession==null || !otpInput.equals(otpSession.toString())){
response.sendRedirect("OTP.jsp?error=InvalidOTP");
return;
}

String receiver=(String)session.getAttribute("otp_receiver");
Double amount=(Double)session.getAttribute("otp_amount");
String description=(String)session.getAttribute("otp_description");

Connection con=null;

try{

con=DBConnection.getConnection();
con.setAutoCommit(false);

/* Sender balance */

PreparedStatement ps=con.prepareStatement(
"SELECT BALANCE FROM BANK_USERS WHERE ACCOUNT_NUMBER=?");

ps.setString(1,user.getAccountNumber());

ResultSet rs=ps.executeQuery();

rs.next();

double senderBalance=rs.getDouble("BALANCE");

/* Receiver balance */

ps=con.prepareStatement(
"SELECT BALANCE FROM BANK_USERS WHERE ACCOUNT_NUMBER=?");

ps.setString(1,receiver);

rs=ps.executeQuery();

rs.next();

double receiverBalance=rs.getDouble("BALANCE");

/* Update sender */

ps=con.prepareStatement(
"UPDATE BANK_USERS SET BALANCE=? WHERE ACCOUNT_NUMBER=?");

ps.setDouble(1,senderBalance-amount);
ps.setString(2,user.getAccountNumber());

ps.executeUpdate();

/* Update receiver */

ps=con.prepareStatement(
"UPDATE BANK_USERS SET BALANCE=? WHERE ACCOUNT_NUMBER=?");

ps.setDouble(1,receiverBalance+amount);
ps.setString(2,receiver);

ps.executeUpdate();

/* Insert transaction */

ps=con.prepareStatement(
"INSERT INTO BANK_TRANSACTIONS(SENDER_ACCOUNT,RECEIVER_ACCOUNT,AMOUNT,TXN_TYPE,DESCRIPTION,STATUS,TXN_DATE) VALUES(?,?,?,?,?,?,SYSDATE)");

ps.setString(1,user.getAccountNumber());
ps.setString(2,receiver);
ps.setDouble(3,amount);
ps.setString(4,"TRANSFER");
ps.setString(5,description);
ps.setString(6,"SUCCESS");

ps.executeUpdate();

con.commit();

/* Update session balance */

user.setBalance(senderBalance-amount);

/* Clear OTP */

session.removeAttribute("otp_code");

response.sendRedirect("dashboard.jsp?msg=TransferSuccess");

}catch(Exception e){

try{if(con!=null)con.rollback();}catch(Exception ex){}
e.printStackTrace();

response.sendRedirect("SendMoney.jsp?error=Failed");

}

}
}