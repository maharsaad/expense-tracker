package com.example.loginproject;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            request.getSession().invalidate();
            response.getWriter().write("{\"status\":\"success\"}");
            return;
        }

        if ("signup".equals(action)) {
            handleSignup(request, response);
        } else {
            handleLogin(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        User user = userDAO.getUserByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            request.getSession().setAttribute("loggedInUser", username);
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Login successful\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Invalid credentials\"}");
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        User existing = userDAO.getUserByUsername(username);
        if (existing != null) {
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Username already taken\"}");
            return;
        }
        userDAO.addUser(new User(username, password));
        response.getWriter().write("{\"status\":\"success\",\"message\":\"Account created!\"}");
    }
}