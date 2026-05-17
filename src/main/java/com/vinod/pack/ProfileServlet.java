package com.vinod.pack;



import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

 protected void doGet(HttpServletRequest request, HttpServletResponse response)
 throws ServletException, IOException {

  try {

   Class.forName("oracle.jdbc.driver.OracleDriver");

   Connection con = DriverManager.getConnection(
     "jdbc:oracle:thin:@localhost:1521:xe","MYVINOD","SYSTEM");

   HttpSession session = request.getSession();
   String username = (String) session.getAttribute("username");

   PreparedStatement ps =
   con.prepareStatement("select * from BANK_USERS  where username=?");

   ps.setString(1, username);

   ResultSet rs = ps.executeQuery();

   if(rs.next())
   {
    request.setAttribute("fullname", rs.getString("FULLNAME"));
    request.setAttribute("email", rs.getString("EMAIL"));
    request.setAttribute("phone", rs.getString("PHONE"));
    request.setAttribute("balance", rs.getDouble("BALANCE"));
   }

   request.getRequestDispatcher("profile.jsp").forward(request,response);

  }
  catch(Exception e)
  {
   e.printStackTrace();
  }

 }

}