package com.vinod.pack;

import java.sql.*;

public class RegisterDAO {
    
    public boolean registerUser(User user)
    {
    	boolean status=false;
        try {
        	Connection con = DBConnection.getConnection();
        	String sql="INSERT INTO BANK_USERS VALUES(?,?,?,?,?,?,?,?)";

             PreparedStatement ps = con.prepareStatement(sql);

             ps.setInt(1,user.getUserId());
             ps.setString(2,user.getFullName());
             ps.setString(3,user.getEmail());
             ps.setString(4,user.getUsername());
             ps.setString(5,user.getAccountNumber());
             ps.setDouble(6,user.getBalance());
             ps.setString(7,user.getPhoneNo());
             ps.setString(8,user.getPassword());

            int rows = ps.executeUpdate();
            if(rows>0)
            {
            	status=true;
            	}

            	}catch(Exception e){
            	e.printStackTrace();
            	}

            	return status;
            	}
}
