<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Job - JobConnect</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<div class="navbar">
    <div class="logo">JobConnect</div>

    <div class="nav-links">
        <a href="employerDashboard.jsp">Dashboard</a>
        <a href="postJob.jsp">Post a Job</a>
        <a href="manageJobs.jsp">My Jobs</a>
        <a href="viewApplicants.jsp">Applicants</a>
        <a href="LogoutServlet">Logout</a>
    </div>
</div>

<div class="form-container">

    <h2>Edit Job</h2>

<%
    String jobId = request.getParameter("job_id");

    java.sql.Connection con = null;
    java.sql.PreparedStatement ps = null;
    java.sql.ResultSet rs = null;

    try {

        // Check login
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Only employers can edit jobs
        String role = (String) session.getAttribute("role");

        if (!"Employer".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId =
                (Integer) session.getAttribute("user_id");

        con = com.jobportal.DBConnection.getConnection();

        /*
         * Load the job only if it belongs to
         * the currently logged-in employer.
         */
        String sql =
                "SELECT j.* "
                + "FROM jobs j "
                + "INNER JOIN employers e "
                + "ON j.employer_id = e.employer_id "
                + "WHERE j.job_id = ? "
                + "AND e.user_id = ?";

        ps = con.prepareStatement(sql);

        ps.setInt(1, Integer.parseInt(jobId));
        ps.setInt(2, userId);

        rs = ps.executeQuery();

        if (rs.next()) {
%>

    <form action="EditJobServlet" method="post">

        <input type="hidden"
               name="job_id"
               value="<%= rs.getInt("job_id") %>">

        <div class="form-group">

            <label>Job Title</label>

            <input type="text"
                   name="title"
                   value="<%= rs.getString("title") %>"
                   required>

        </div>

        <div class="form-group">

            <label>Job Description</label>

            <textarea name="description"
                      rows="6"
                      required><%= rs.getString("description") %></textarea>

        </div>

        <div class="form-group">

            <label>Location</label>

            <input type="text"
                   name="location"
                   value="<%= rs.getString("location") %>">

        </div>

        <div class="form-group">

            <label>Salary</label>

            <input type="text"
                   name="salary"
                   value="<%= rs.getString("salary") %>">

        </div>

        <div class="form-group">

            <label>Job Type</label>

            <select name="job_type">

                <option value="Full Time"
                    <%= "Full Time".equals(rs.getString("job_type"))
                        ? "selected" : "" %>>
                    Full Time
                </option>

                <option value="Part Time"
                    <%= "Part Time".equals(rs.getString("job_type"))
                        ? "selected" : "" %>>
                    Part Time
                </option>

                <option value="Internship"
                    <%= "Internship".equals(rs.getString("job_type"))
                        ? "selected" : "" %>>
                    Internship
                </option>

                <option value="Contract"
                    <%= "Contract".equals(rs.getString("job_type"))
                        ? "selected" : "" %>>
                    Contract
                </option>

            </select>

        </div>

        <div style="text-align:center;">

            <input type="submit"
                   value="Update Job"
                   class="btn btn-primary">

            <a href="manageJobs.jsp"
               class="btn btn-light">
                Cancel
            </a>

        </div>

    </form>

<%
        } else {
%>

    <h3>You are not authorized to edit this job.</h3>

    <br>

    <a href="manageJobs.jsp"
       class="btn btn-primary">
        Back to My Jobs
    </a>

<%
        }

    } catch (Exception e) {

        out.println(
            "<p>Error: " + e.getMessage() + "</p>"
        );

    } finally {

        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (Exception e) {
        }

    }
%>

</div>

<div class="footer">

    <p>© 2026 JobConnect - Online Job Portal</p>

</div>

</body>
</html>