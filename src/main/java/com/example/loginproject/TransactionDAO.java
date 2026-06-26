package com.example.loginproject;

import java.sql.*;

public class TransactionDAO {

    public void addTransaction(String username, String type, double amount,
                               String category, String description, String date) throws SQLException {

        String sql = "INSERT INTO transactions(username,type,amount,category,description,date) VALUES (?,?,?,?,?,?)";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("🔌 INSERT START");

            ps.setString(1, username);
            ps.setString(2, type);
            ps.setDouble(3, amount);
            ps.setString(4, category);
            ps.setString(5, description);

            if (date == null || date.isEmpty()) {
                ps.setDate(6, new Date(System.currentTimeMillis()));
            } else {
                ps.setDate(6, Date.valueOf(date));
            }

            int rows = ps.executeUpdate();

            System.out.println("✅ INSERT SUCCESS, rows = " + rows);

        } catch (Exception e) {
            System.out.println("❌ INSERT FAILED");
            e.printStackTrace();
            throw e;
        }
    }

    public String getDashboardData(String username) throws SQLException {
        return "{\"status\":\"ok\"}";
    }
}