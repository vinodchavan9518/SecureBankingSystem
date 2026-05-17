package com.vinod.pack;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ApplyLoanServlet")
public class ApplyLoanServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null){
            response.sendRedirect("index.jsp");
            return;
        }

        double amount = Double.parseDouble(request.getParameter("amount"));
        String type = request.getParameter("loanType");  // Fixed parameter name
        int duration = Integer.parseInt(request.getParameter("duration"));

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO BANK_LOANS (ACCOUNT_NUMBER, LOAN_AMOUNT, LOAN_TYPE, DURATION_MONTHS, STATUS, APPLICATION_DATE) " +
                "VALUES (?, ?, ?, ?, 'PENDING', SYSDATE)"
            );
            ps.setString(1, user.getAccountNumber());
            ps.setDouble(2, amount);
            ps.setString(3, type);
            ps.setInt(4, duration);
            ps.executeUpdate();

            response.sendRedirect("dashboard.jsp?msg=LoanApplied");
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("ApplyLoan.jsp?error=Failed");
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e){}
            try { if(con != null) con.close(); } catch(Exception e){}
        }
    }
}