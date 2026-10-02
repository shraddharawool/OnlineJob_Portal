package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateApplicationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Only employers can update application status
        String role = (String) session.getAttribute("role");

        if (!"Employer".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        String applicationIdText =
                request.getParameter("application_id");

        String status =
                request.getParameter("status");

        try {

            int applicationId =
                    Integer.parseInt(applicationIdText);

            int userId =
                    (Integer) session.getAttribute("user_id");

            Connection con =
                    DBConnection.getConnection();

            /*
             * Update only applications belonging to
             * jobs posted by the logged-in employer.
             */
            String sql =
                    "UPDATE applications "
                    + "SET status = ? "
                    + "WHERE application_id = ? "
                    + "AND job_id IN "
                    + "(SELECT j.job_id "
                    + "FROM jobs j "
                    + "INNER JOIN employers e "
                    + "ON j.employer_id = e.employer_id "
                    + "WHERE e.user_id = ?)";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, applicationId);
            ps.setInt(3, userId);

            int result =
                    ps.executeUpdate();

            ps.close();
            con.close();

            if (result > 0) {

                response.sendRedirect("viewApplicants.jsp");

            } else {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>You are not authorized to update this application.</h2>"
                );

                response.getWriter().println(
                        "<a href='viewApplicants.jsp'>Back to Applicants</a>"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Error: " + e.getMessage() + "</h2>"
            );

            response.getWriter().println(
                    "<a href='viewApplicants.jsp'>Back to Applicants</a>"
            );
        }
    }
}