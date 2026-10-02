package com.jobportal;

import java.sql.Connection;

public class DBTest {

    public static void main(String[] args) {

        Connection con = DBConnection.getConnection();

        if (con != null) {
            System.out.println("TEST PASSED - Database connection is working!");
        } else {
            System.out.println("TEST FAILED - Database connection is not working.");
        }
    }
}