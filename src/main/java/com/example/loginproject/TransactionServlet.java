package com.example.loginproject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/transaction")
public class TransactionServlet extends HttpServlet {

    private final TransactionDAO dao = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🔥 GET /transaction HIT");

        String action = request.getParameter("action");
        String username = (String) request.getSession().getAttribute("loggedInUser");

        response.setContentType("application/json");

        try {

            if (username == null) {
                System.out.println("❌ USER NOT LOGGED IN");
                response.getWriter().write("{\"error\":\"not logged in\"}");
                return;
            }

            if ("list".equals(action)) {
                String json = dao.getDashboardData(username);
                response.getWriter().write(json);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🔥 POST /transaction HIT");

        String username = (String) request.getSession().getAttribute("loggedInUser");

        try {

            if (username == null) {
                System.out.println("❌ USER NOT LOGGED IN");
                response.getWriter().write("{\"error\":\"not logged in\"}");
                return;
            }

            String type = request.getParameter("type");
            String amountStr = request.getParameter("amount");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String date = request.getParameter("date");

            System.out.println("➡ DATA RECEIVED:");
            System.out.println(type + " " + amountStr + " " + category);

            double amount = Double.parseDouble(amountStr);

            dao.addTransaction(username, type, amount, category, description, date);

            response.getWriter().write("{\"status\":\"success\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}