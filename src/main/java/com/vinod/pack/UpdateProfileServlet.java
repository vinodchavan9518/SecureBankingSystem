package com.vinod.pack;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("bank-login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");

        // Basic validation
        if (fullName == null || email == null || username == null || phoneNumber == null
                || fullName.trim().isEmpty() || email.trim().isEmpty()
                || username.trim().isEmpty() || phoneNumber.trim().isEmpty()) {

            response.sendRedirect("editProfile.jsp?error=All fields are required");
            return;
        }

        String sql;

        if (password != null && !password.trim().isEmpty()) {
            sql = "UPDATE BANK_USERS SET FULL_NAME=?, EMAIL=?, USERNAME=?, PASSWORD=?, PHONE_NUMBER=? WHERE USER_ID=?";
        } else {
            sql = "UPDATE BANK_USERS SET FULL_NAME=?, EMAIL=?, USERNAME=?, PHONE_NUMBER=? WHERE USER_ID=?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, username);

            if (password != null && !password.trim().isEmpty()) {
                ps.setString(4, password);
                ps.setString(5, phoneNumber);
                ps.setInt(6, user.getUserId());
            } else {
                ps.setString(4, phoneNumber);
                ps.setInt(5, user.getUserId());
            }

            int updated = ps.executeUpdate();

            if (updated > 0) {

                // Update session values
                user.setFullName(fullName);
                user.setEmail(email);
                user.setUsername(username);
                user.setPhoneNo(phoneNumber);

                session.setAttribute("user", user);

                response.sendRedirect("profile.jsp?success=Profile Updated");
            } else {
                response.sendRedirect("editProfile.jsp?error=Update Failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("editProfile.jsp?error=Database Error");
        }
    }
}