package com.example.loginproject;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private Connection connection;

    public UserDAO() {
        this.connection = DbUtil.getConnection();
    }

    public void addUser(User user) {

        try {

            PreparedStatement ps = connection.prepareStatement(
                    "INSERT INTO users(username, password) VALUES (?, ?)"
            );

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());

            int rows = ps.executeUpdate();

            System.out.println("Inserted rows: " + rows);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public User getUserByUsername(String username) {

        try {

            PreparedStatement ps = connection.prepareStatement(
                    "SELECT * FROM users WHERE username = ?"
            );

            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                User user = new User();

                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));

                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();

        try {

            Statement st = connection.createStatement();

            ResultSet rs = st.executeQuery(
                    "SELECT * FROM users"
            );

            while (rs.next()) {

                User user = new User();

                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));

                users.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }
}