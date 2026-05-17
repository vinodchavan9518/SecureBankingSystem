package com.vinod.pack;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public User validateUser(String username, String password) {

        User user = null;

        String sql = "SELECT * FROM BANK_USERS WHERE USERNAME=? AND PASSWORD=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, username);
            pst.setString(2, password);

            try (ResultSet rs = pst.executeQuery()) {

                if (rs.next()) {
                    user = new User();

                    user.setUserId(rs.getInt("USER_ID"));
                    user.setFullName(rs.getString("FULL_NAME"));
                    user.setEmail(rs.getString("EMAIL"));
                    user.setUsername(rs.getString("USERNAME"));
                    user.setAccountNumber(rs.getString("ACCOUNT_NUMBER"));
                    user.setBalance(rs.getDouble("BALANCE"));
                    user.setPhoneNo(rs.getString("PHONE_NUMBER"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }
}