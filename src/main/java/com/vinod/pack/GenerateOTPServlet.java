package com.vinod.pack;

import java.io.IOException;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/GenerateOTP")
public class GenerateOTPServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Get amount and type from request
        String receiver = request.getParameter("receiver");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String description = request.getParameter("description");

        // Generate 6-digit OTP
        Random rand = new Random();
        int otpCode = 100000 + rand.nextInt(900000);

        // Store in session
        session.setAttribute("otp_code", otpCode);
        session.setAttribute("otp_receiver", receiver);
        session.setAttribute("otp_amount", amount);
        session.setAttribute("otp_description", description);

        // Redirect to OTP page with OTP for testing
        System.out.println("OTP Generated: " + otpCode);

        response.sendRedirect("OTP.jsp?otp=" + otpCode); 
        
        response.sendRedirect("VerifyOTP.jsp?testotp=" + otpCode);
    }
}