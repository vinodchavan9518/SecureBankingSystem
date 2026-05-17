package com.vinod.pack;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

protected void doPost(HttpServletRequest request,HttpServletResponse response)
throws ServletException,IOException{

String username=request.getParameter("username");
String password=request.getParameter("password");

System.out.println("Username: "+username);
System.out.println("Password: "+password);
try{

Connection con=DBConnection.getConnection();

String query="SELECT * FROM BANK_USERS WHERE USERNAME=? AND PASSWORD=?";

PreparedStatement ps=con.prepareStatement(query);

ps.setString(1,username);
ps.setString(2,password);

ResultSet rs=ps.executeQuery();

if(rs.next())
{
	
	User user = new User();
	
	user.setUsername(rs.getString("USERNAME"));
    user.setFullName(rs.getString("FULL_NAME"));
    user.setEmail(rs.getString("EMAIL"));
    user.setPhoneNo(rs.getString("PHONE_NUMBER"));
    user.setAccountNumber(rs.getString("ACCOUNT_NUMBER"));
    user.setBalance(rs.getDouble("BALANCE"));

HttpSession session=request.getSession();

session.setAttribute("user",user);

response.sendRedirect("dashboard.jsp");

}else{

response.sendRedirect("index.jsp?error=1");

}

}catch(Exception e){

e.printStackTrace();

response.sendRedirect("index.jsp?error=1");

}

}

}