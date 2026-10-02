package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "SELECT user_id, name, email, password, role "
                    + "FROM users "
                    + "WHERE TRIM(email) = TRIM(?) "
                    + "AND TRIM(password) = TRIM(?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = request.getSession();

                session.setAttribute("user_id",
                        rs.getInt("user_id"));

                session.setAttribute("name",
                        rs.getString("name"));

                session.setAttribute("email",
                        rs.getString("email"));

                session.setAttribute("role",
                        rs.getString("role"));

                String role = rs.getString("role");

                if ("Job Seeker".equals(role)) {

                    response.sendRedirect("seekerDashboard.jsp");

                } else if ("Employer".equals(role)) {

                    response.sendRedirect("employerDashboard.jsp");

                } else if ("Admin".equals(role)) {

                    response.sendRedirect("adminDashboard.jsp");

                } else {

                    response.sendRedirect("index.jsp");
                }

            } else {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>Invalid email or password</h2>"
                );

                response.getWriter().println(
                        "<a href='login.jsp'>Try Again</a>"
                );
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Error: " + e.getMessage() + "</h2>"
            );
        }
    }
}