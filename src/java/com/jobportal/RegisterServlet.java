package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        Connection con = null;
        PreparedStatement idPs = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            // Find the next available user ID
            String idSql =
                    "SELECT COALESCE(MAX(user_id), 0) + 1 AS next_id "
                    + "FROM users";

            idPs = con.prepareStatement(idSql);
            rs = idPs.executeQuery();

            int userId = 1;

            if (rs.next()) {
                userId = rs.getInt("next_id");
            }

            rs.close();
            idPs.close();

            // Insert new user
            String sql =
                    "INSERT INTO users "
                    + "(user_id, name, email, password, role) "
                    + "VALUES (?, ?, ?, ?, ?)";

            ps = con.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, role);

            int result = ps.executeUpdate();

            if (result > 0) {

                response.sendRedirect("login.jsp");

            } else {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>Registration failed.</h2>"
                );

                response.getWriter().println(
                        "<a href='register.jsp'>Try Again</a>"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Registration Error</h2>"
            );

            response.getWriter().println(
                    "<p>" + e.getMessage() + "</p>"
            );

            response.getWriter().println(
                    "<a href='register.jsp'>Back to Registration</a>"
            );

        } finally {

            try {
                if (rs != null) rs.close();
                if (idPs != null) idPs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
            }
        }
    }
}