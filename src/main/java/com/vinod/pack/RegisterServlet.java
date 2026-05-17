package com.vinod.pack;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Password check
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        int userId = (int)(Math.random()*10000);

        // Generate random account number
        String accountNumber = "SB" + (long)(Math.random() * 10000000000L);

        User user = new User();
        user.setUserId(userId);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNo(phone);
        user.setUsername(username);
        user.setPassword(password);
        user.setAccountNumber(accountNumber);
        user.setBalance(15000.0); // default initial balance

        RegisterDAO dao=new RegisterDAO();
        boolean success = dao.registerUser(user);

        if (success) {
            response.sendRedirect("index.jsp?msg=Registration successful!");
        } else {
            request.setAttribute("error", "Registration failed. Try again!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
