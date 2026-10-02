package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EditJobServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
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
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String salary = request.getParameter("salary");
        String jobType = request.getParameter("job_type");

        try {

            int jobId = Integer.parseInt(jobIdText);

            int userId = (Integer) session.getAttribute("user_id");

            Connection con = DBConnection.getConnection();

            /*
             * Update only if the job belongs to the
             * currently logged-in employer.
             */
            String sql =
                    "UPDATE jobs "
                    + "SET title = ?, "
                    + "description = ?, "
                    + "location = ?, "
                    + "salary = ?, "
                    + "job_type = ? "
                    + "WHERE job_id = ? "
                    + "AND employer_id = "
                    + "(SELECT employer_id FROM employers WHERE user_id = ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, location);
            ps.setString(4, salary);
            ps.setString(5, jobType);
            ps.setInt(6, jobId);
            ps.setInt(7, userId);

            int result = ps.executeUpdate();

            ps.close();
            con.close();

            if (result > 0) {

                response.sendRedirect("manageJobs.jsp");

            } else {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>You are not authorized to edit this job.</h2>"
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