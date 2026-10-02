<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Find Jobs - JobConnect</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<div class="navbar">

    <div class="logo">
        JobConnect
    </div>

    <div class="nav-links">

        <a href="seekerDashboard.jsp">Dashboard</a>
        <a href="searchJobs.jsp">Find Jobs</a>
        <a href="myApplications.jsp">Applications</a>
        <a href="LogoutServlet">
    Logout
</a>

    </div>

</div>


<div class="container">

    <div class="dashboard-header">

        <h2>Find Your Next Opportunity</h2>

        <p>
            Search for jobs by role, location or job type.
            Leave the fields empty to see all available jobs.
        </p>

    </div>


    <!-- SEARCH -->

    <div class="search-box">

        <form method="get" action="searchJobs.jsp">

            <input
                type="text"
                name="keyword"
                placeholder="Job title or keyword"
                value="<%= request.getParameter("keyword") != null
                        ? request.getParameter("keyword") : "" %>">

            <input
                type="text"
                name="location"
                placeholder="Location"
                value="<%= request.getParameter("location") != null
                        ? request.getParameter("location") : "" %>">

            <select name="job_type">

                <option value="">All Job Types</option>

                <option value="Full Time">Full Time</option>

                <option value="Part Time">Part Time</option>

                <option value="Internship">Internship</option>

                <option value="Contract">Contract</option>

            </select>

            <input
                type="submit"
                value="Search Jobs"
                class="btn btn-primary">

            <a
                href="searchJobs.jsp"
                class="btn btn-light">

                Clear

            </a>

        </form>

    </div>


    <h2>Available Jobs</h2>


<%

    java.sql.Connection con = null;
    java.sql.PreparedStatement ps = null;
    java.sql.ResultSet rs = null;

    try {

        con = com.jobportal.DBConnection.getConnection();

        String keyword = request.getParameter("keyword");
        String location = request.getParameter("location");
        String jobType = request.getParameter("job_type");

        String sql =
                "SELECT * FROM jobs "
                + "WHERE 1 = 1 ";

        if (keyword != null && !keyword.trim().isEmpty()) {

            sql +=
                "AND (LOWER(title) LIKE LOWER(?) "
                + "OR LOWER(description) LIKE LOWER(?)) ";

        }

        if (location != null && !location.trim().isEmpty()) {

            sql +=
                "AND LOWER(location) LIKE LOWER(?) ";

        }

        if (jobType != null && !jobType.trim().isEmpty()) {

            sql +=
                "AND job_type = ? ";

        }

        sql += "ORDER BY job_id DESC";

        ps = con.prepareStatement(sql);

        int index = 1;


        if (keyword != null && !keyword.trim().isEmpty()) {

            String searchText =
                    "%" + keyword.trim() + "%";

            ps.setString(index++, searchText);

            ps.setString(index++, searchText);

        }


        if (location != null && !location.trim().isEmpty()) {

            ps.setString(
                    index++,
                    "%" + location.trim() + "%"
            );

        }


        if (jobType != null && !jobType.trim().isEmpty()) {

            ps.setString(index++, jobType);

        }


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

                <strong>Job Description</strong>

            </p>

            <p>
                <%= rs.getString("description") %>
            </p>

            <br>

            <a
                href="applyJob.jsp?job_id=<%= rs.getInt("job_id") %>"
                class="btn btn-primary">

                Apply Now

            </a>

        </div>

<%

        }


        if (!found) {

%>

        <div class="card">

            <h3>No Jobs Found</h3>

            <p>
                No jobs match your search.
                Try another job role or location.
            </p>

        </div>

<%

        }


    } catch (Exception e) {

%>

        <div class="card">

            <h3>Error Loading Jobs</h3>

            <p>
                <%= e.getMessage() %>
            </p>

        </div>

<%

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

    <p>
        © 2026 JobConnect - Online Job Portal
    </p>

    <p>
        Find jobs. Apply online. Build your career.
    </p>

</div>

</body>
</html>