package com.example.loginproject;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbUtil {

    private static final String URL =
            "jdbc:postgresql://database-1.c38qosyyskcl.ap-south-1.rds.amazonaws.com:5432/postgres";

    private static final String USER = "postgres";
    private static final String PASSWORD = "12345678";

    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");

            System.out.println("🔌 Connecting to RDS...");

            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("✅ RDS Connected");

            return conn;

        } catch (Exception e) {
            System.out.println("❌ DB CONNECTION FAILED");
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}