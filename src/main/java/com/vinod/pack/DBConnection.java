package com.vinod.pack;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection conn;

    public static Connection getConnection() {

        try {

            if (conn == null || conn.isClosed()) {

                Class.forName("oracle.jdbc.driver.OracleDriver");

                conn = DriverManager.getConnection(
                        "jdbc:oracle:thin:@localhost:1521:xe",
                        "MYVINOD",
                        "SYSTEM");

                System.out.println("Database Connected Successfully");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return conn;
    }
}

//there are three table 
//select * from   BANK_TRANSACTIONS;
//select * from    BANK_USERS;
//select * from  BANK_LOANS;