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

public class PostJobServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String salary = request.getParameter("salary");
        String jobType = request.getParameter("job_type");

        HttpSession session = request.getSession();

        int userId = (Integer) session.getAttribute("user_id");

        try {

            Connection con = DBConnection.getConnection();

            // Find employer_id using logged-in user_id
            String employerSql =
                    "SELECT employer_id FROM employers WHERE user_id = ?";

            PreparedStatement employerPs =
                    con.prepareStatement(employerSql);

            employerPs.setInt(1, userId);

            ResultSet employerRs = employerPs.executeQuery();

            if (employerRs.next()) {

                int employerId = employerRs.getInt("employer_id");

                // Find next job ID
                String idSql =
                        "SELECT COALESCE(MAX(job_id), 0) + 1 AS next_id "
                        + "FROM jobs";

                PreparedStatement idPs =
                        con.prepareStatement(idSql);

                ResultSet idRs = idPs.executeQuery();

                int jobId = 1;

                if (idRs.next()) {
                    jobId = idRs.getInt("next_id");
                }

                idRs.close();
                idPs.close();

                // Insert job
                String sql =
                        "INSERT INTO jobs "
                        + "(job_id, employer_id, title, description, "
                        + "location, salary, job_type) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, jobId);
                ps.setInt(2, employerId);
                ps.setString(3, title);
                ps.setString(4, description);
                ps.setString(5, location);
                ps.setString(6, salary);
                ps.setString(7, jobType);

                ps.executeUpdate();

                ps.close();

                response.sendRedirect("employerDashboard.jsp");

            } else {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>Company profile not found.</h2>"
                );

                response.getWriter().println(
                        "<a href='companyProfile.jsp'>Create Company Profile</a>"
                );
            }

            employerRs.close();
            employerPs.close();
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