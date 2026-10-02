<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Manage Jobs - JobConnect</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<!-- NAVIGATION -->

<div class="navbar">

    <div class="logo">
        JobConnect
    </div>

    <div class="nav-links">

        <a href="employerDashboard.jsp">Dashboard</a>
        <a href="postJob.jsp">Post a Job</a>
        <a href="manageJobs.jsp">My Jobs</a>
        <a href="viewApplicants.jsp">Applicants</a>
        <a href="LogoutServlet">
    Logout
</a>

    </div>

</div>


<!-- PAGE -->

<div class="container">

    <div class="dashboard-header">

        <h2>Manage Your Jobs</h2>

        <p>
            View all job opportunities posted by your company.
        </p>

    </div>


    <div style="margin-bottom:25px;">

        <a href="postJob.jsp"
           class="btn btn-primary">

            + Post New Job

        </a>

    </div>


<%
    java.sql.Connection con = null;
    java.sql.PreparedStatement ps = null;
    java.sql.ResultSet rs = null;

    try {

        int userId = (Integer) session.getAttribute("user_id");

        con = com.jobportal.DBConnection.getConnection();

        String sql =
            "SELECT j.* FROM jobs j "
            + "JOIN employers e "
            + "ON j.employer_id = e.employer_id "
            + "WHERE e.user_id = ? "
            + "ORDER BY j.job_id DESC";

        ps = con.prepareStatement(sql);

        ps.setInt(1, userId);

        rs = ps.executeQuery();

        boolean found = false;

        while (rs.next()) {

            found = true;
%>

    <div class="job-card">

        <h2>
            <%= rs.getString("title") %>
        </h2>

        <p class="job-info">

            📍 <strong>Location:</strong>
            <%= rs.getString("location") %>

        </p>

        <p class="job-info">

            💰 <strong>Salary:</strong>
            ₹<%= rs.getString("salary") %>

        </p>

        <p class="job-info">

            💼 <strong>Job Type:</strong>
            <%= rs.getString("job_type") %>

        </p>

        <p>
            <strong>Description:</strong>
        </p>

        <p>
            <%= rs.getString("description") %>
        </p>

        <hr>

        <p>
            <strong>Job ID:</strong>
            <%= rs.getInt("job_id") %>
        </p>
        <br>

       <a href="editJob.jsp?job_id=<%= rs.getInt("job_id") %>"
       class="btn btn-primary">
    ✏ Edit Job
</a>
       <a href="DeleteJobServlet?job_id=<%= rs.getInt("job_id") %>"
   class="btn btn-danger"
   onclick="return confirm('Are you sure you want to delete this job?');">
    🗑 Delete Job
</a>

    </div>

<%
        }

        if (!found) {
%>

    <div class="card">

        <h3>No Jobs Posted Yet</h3>

        <p>
            You have not posted any jobs.
        </p>

        <a href="postJob.jsp"
           class="btn btn-primary">

            Post Your First Job

        </a>

    </div>

<%
        }

    } catch (Exception e) {

        out.println(
            "<div class='card'>"
            + "<h3>Error Loading Jobs</h3>"
            + "<p>" + e.getMessage() + "</p>"
            + "</div>"
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


<!-- FOOTER -->

<div class="footer">

    <p>
        © 2026 JobConnect - Online Job Portal
    </p>

    <p>
        Manage your opportunities and find talented candidates.
    </p>

</div>

</body>
</html>