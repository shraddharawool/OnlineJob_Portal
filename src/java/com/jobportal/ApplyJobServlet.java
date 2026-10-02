package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ApplyJobServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String jobIdText = request.getParameter("job_id");

        HttpSession session = request.getSession();

        int userId = (Integer) session.getAttribute("user_id");

        try {

            int jobId = Integer.parseInt(jobIdText);

            Connection con = DBConnection.getConnection();

            // Find seeker_id using logged-in user_id
            String seekerSql =
                    "SELECT seeker_id FROM job_seekers WHERE user_id = ?";

            PreparedStatement seekerPs =
                    con.prepareStatement(seekerSql);

            seekerPs.setInt(1, userId);

            ResultSet seekerRs = seekerPs.executeQuery();

            if (seekerRs.next()) {

                int seekerId = seekerRs.getInt("seeker_id");

                // Generate next application ID
                String idSql =
                        "SELECT COALESCE(MAX(application_id), 0) + 1 "
                        + "AS next_id FROM applications";

                PreparedStatement idPs =
                        con.prepareStatement(idSql);

                ResultSet idRs = idPs.executeQuery();

                int applicationId = 1;

                if (idRs.next()) {
                    applicationId = idRs.getInt("next_id");
                }

                idRs.close();
                idPs.close();

                // Insert application
                String sql =
                        "INSERT INTO applications "
                        + "(application_id, job_id, seeker_id, "
                        + "application_date, status) "
                        + "VALUES (?, ?, ?, ?, ?)";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, applicationId);
                ps.setInt(2, jobId);
                ps.setInt(3, seekerId);
                ps.setDate(4, Date.valueOf(LocalDate.now()));
                ps.setString(5, "Pending");

                ps.executeUpdate();

                ps.close();

                response.sendRedirect("seekerDashboard.jsp");

            } else {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>Job Seeker profile not found.</h2>"
                );

                response.getWriter().println(
                        "<a href='profile.jsp'>Create Profile</a>"
                );
            }

            seekerRs.close();
            seekerPs.close();
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