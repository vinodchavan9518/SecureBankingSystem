package com.vinod.pack;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class TransferServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User sender = (User) session.getAttribute("user");

        if (sender == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String receiverAccount = request.getParameter("receiverAccount");
        String amountStr = request.getParameter("amount");
        double amount = 0;

        // 1️⃣ Input Validation
        if (receiverAccount == null || receiverAccount.trim().isEmpty()) {
            response.sendRedirect("makePayment.jsp?error=Receiver account required");
            return;
        }

        try {
            amount = Double.parseDouble(amountStr);
            if (amount <= 0) {
                response.sendRedirect("makePayment.jsp?error=Amount must be positive");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("makePayment.jsp?error=Invalid amount");
            return;
        }

        // 2️⃣ Perform Transfer
        TransactionDAO dao = new TransactionDAO();
        boolean success = dao.transferAmount(sender.getAccountNumber(), receiverAccount, amount);

        if (success) {
            response.sendRedirect("dashboard.jsp?msg=Transfer Successful");
        } else {
            response.sendRedirect("makePayment.jsp?error=Transfer Failed");
        }
    }
}