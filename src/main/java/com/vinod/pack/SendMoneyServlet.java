package com.vinod.pack;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/sendMoney")
public class SendMoneyServlet extends HttpServlet {

protected void doPost(HttpServletRequest request,HttpServletResponse response)
throws ServletException,IOException{

String receiver=request.getParameter("receiver");
double amount=Double.parseDouble(request.getParameter("amount"));
String description=request.getParameter("description");

HttpSession session=request.getSession();
User sender=(User)session.getAttribute("user");

try{

Connection con=DBConnection.getConnection();

String query="SELECT * FROM BANK_USERS WHERE ACCOUNT_NUMBER=? OR PHONE_NUMBER=?";
PreparedStatement ps=con.prepareStatement(query);

ps.setString(1,receiver);
ps.setString(2,receiver);

ResultSet rs=ps.executeQuery();

if(!rs.next()){
response.sendRedirect("SendMoney.jsp?error=ReceiverNotFound");
return;
}

String receiverAcc=rs.getString("ACCOUNT_NUMBER");

/* Balance Check */

if(sender.getBalance()<amount){
response.sendRedirect("SendMoney.jsp?error=InsufficientBalance");
return;
}

/* OTP Generate */

Random rand=new Random();
int otp=1000+rand.nextInt(9000);

/* Store Correct Session Attributes */

session.setAttribute("otp_code",otp);
session.setAttribute("otp_receiver",receiverAcc);
session.setAttribute("otp_amount",amount);
session.setAttribute("otp_description",description);

/* Show OTP in console */

System.out.println("OTP CODE : "+otp);

/* Redirect to OTP page */

response.sendRedirect("OTP.jsp");

}catch(Exception e){
e.printStackTrace();
response.sendRedirect("SendMoney.jsp?error=TransactionFailed");
}

}
}