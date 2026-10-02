package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DeleteJobServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Check login
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Check employer role
        String role = (String) session.getAttribute("role");

        if (!"Employer".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        String jobIdText = request.getParameter("job_id");

        try {

            int jobId = Integer.parseInt(jobIdText);

            int userId = (Integer) session.getAttribute("user_id");

            Connection con = DBConnection.getConnection();

            /*
             * Delete only if the job belongs to
             * the currently logged-in employer.
             */
            String sql =
                    "DELETE FROM jobs "
                    + "WHERE job_id = ? "
                    + "AND employer_id = "
                    + "(SELECT employer_id FROM employers WHERE user_id = ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, jobId);
            ps.setInt(2, userId);

            int result = ps.executeUpdate();

            ps.close();
            con.close();

            if (result > 0) {

                response.sendRedirect("manageJobs.jsp");

            } else {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>You are not authorized to delete this job.</h2>"
                );

                response.getWriter().println(
                        "<a href='manageJobs.jsp'>Back to My Jobs</a>"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Error: " + e.getMessage() + "</h2>"
            );

            response.getWriter().println(
                    "<a href='manageJobs.jsp'>Back to My Jobs</a>"
            );
        }
    }
}