<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>My Applications - JobConnect</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<!-- NAVBAR -->

<div class="navbar">

    <div class="logo">
        JobConnect
    </div>

    <div class="nav-links">

        <a href="seekerDashboard.jsp">
            Dashboard
        </a>

        <a href="searchJobs.jsp">
            Find Jobs
        </a>

        <a href="myApplications.jsp">
            Applications
        </a>

        <a href="LogoutServlet">
    Logout
</a>

    </div>

</div>


<!-- MAIN CONTENT -->

<div class="container">

    <div class="dashboard-header">

        <h2>
            My Applications
        </h2>

        <p>
            View your job applications, check their status,
            and print or save your application details as PDF.
        </p>

    </div>


    <%
        java.sql.Connection con = null;
        java.sql.PreparedStatement ps = null;
        java.sql.ResultSet rs = null;

        try {

            con = com.jobportal.DBConnection.getConnection();

            Integer userId =
                    (Integer) session.getAttribute("user_id");

            String sql =
                    "SELECT "
                    + "a.application_id, "
                    + "a.application_date, "
                    + "a.status, "
                    + "j.title, "
                    + "j.location, "
                    + "j.salary, "
                    + "j.job_type "
                    + "FROM applications a "
                    + "JOIN jobs j "
                    + "ON a.job_id = j.job_id "
                    + "JOIN job_seekers s "
                    + "ON a.seeker_id = s.seeker_id "
                    + "WHERE s.user_id = ? "
                    + "ORDER BY a.application_id DESC";

            ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            rs = ps.executeQuery();

            boolean found = false;

            while (rs.next()) {

                found = true;

                String status =
                        rs.getString("status");

                String statusClass =
                        "status-pending";

                if ("Shortlisted".equalsIgnoreCase(status)) {

                    statusClass =
                            "status-shortlisted";

                } else if ("Selected".equalsIgnoreCase(status)) {

                    statusClass =
                            "status-selected";

                } else if ("Rejected".equalsIgnoreCase(status)) {

                    statusClass =
                            "status-rejected";

                }

    %>


    <!-- APPLICATION CARD -->

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


        <p class="job-info">

            📅 <strong>Applied On:</strong>

            <%= rs.getDate("application_date") %>

        </p>


        <p class="job-info">

            📋 <strong>Application ID:</strong>

            <%= rs.getInt("application_id") %>

        </p>


        <p class="job-info">

            <strong>Application Status:</strong>

            <span class="status <%= statusClass %>">

                <%= status %>

            </span>

        </p>


        <br>


        <!-- PRINT / PDF BUTTON -->

        <a href="printApplication.jsp?application_id=<%= rs.getInt("application_id") %>"
           class="btn btn-primary">

            🖨 Print / Save PDF

        </a>


        <!-- SEARCH JOBS BUTTON -->

        <a href="searchJobs.jsp"
           class="btn btn-light">

            🔎 Find More Jobs

        </a>


    </div>


    <%

            }

            if (!found) {

    %>


    <!-- NO APPLICATIONS -->

    <div class="card">

        <h3>
            No Applications Yet
        </h3>

        <p>
            You have not applied for any jobs yet.
        </p>

        <br>

        <a href="searchJobs.jsp"
           class="btn btn-primary">

            🔎 Browse Available Jobs

        </a>

    </div>


    <%

            }

        } catch (Exception e) {

    %>


    <!-- ERROR -->

    <div class="card">

        <h3>
            Error Loading Applications
        </h3>

        <p>
            <%= e.getMessage() %>
        </p>

    </div>


    <%

        } finally {

            try {

                if (rs != null)
                    rs.close();

                if (ps != null)
                    ps.close();

                if (con != null)
                    con.close();

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
        Find jobs. Apply online. Track your career.
    </p>

</div>


</body>

</html>