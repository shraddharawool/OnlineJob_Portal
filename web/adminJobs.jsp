<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Manage Jobs - JobConnect</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<div class="navbar">

    <div class="logo">
        JobConnect
    </div>

    <div class="nav-links">

        <a href="adminDashboard.jsp">
            Dashboard
        </a>

        <a href="adminUsers.jsp">
            Users
        </a>

        <a href="adminJobs.jsp">
            Jobs
        </a>

        <a href="adminApplications.jsp">
            Applications
        </a>

       <a href="LogoutServlet">
    Logout
</a>

    </div>

</div>


<div class="container">

    <div class="dashboard-header">

        <h2>
            💼 Manage Jobs
        </h2>

        <p>
            View and search all job opportunities posted
            by employers on JobConnect.
        </p>

    </div>


    <!-- SEARCH AND FILTER -->

    <div class="search-box">

        <form method="get"
              action="adminJobs.jsp">

            <input type="text"
                   name="keyword"
                   placeholder="Search job title or description"
                   value="<%= request.getParameter("keyword") != null
                           ? request.getParameter("keyword")
                           : "" %>">


            <input type="text"
                   name="location"
                   placeholder="Location"
                   value="<%= request.getParameter("location") != null
                           ? request.getParameter("location")
                           : "" %>">


            <select name="job_type">

                <option value="">
                    All Job Types
                </option>

                <option value="Full Time"
                    <%= "Full Time".equals(request.getParameter("job_type"))
                        ? "selected" : "" %>>
                    Full Time
                </option>

                <option value="Part Time"
                    <%= "Part Time".equals(request.getParameter("job_type"))
                        ? "selected" : "" %>>
                    Part Time
                </option>

                <option value="Internship"
                    <%= "Internship".equals(request.getParameter("job_type"))
                        ? "selected" : "" %>>
                    Internship
                </option>

                <option value="Contract"
                    <%= "Contract".equals(request.getParameter("job_type"))
                        ? "selected" : "" %>>
                    Contract
                </option>

            </select>


            <input type="submit"
                   value="Search Jobs"
                   class="btn btn-primary">


            <a href="adminJobs.jsp"
               class="btn btn-light">

                Clear

            </a>

        </form>

    </div>


<%

    java.sql.Connection con = null;
    java.sql.PreparedStatement ps = null;
    java.sql.ResultSet rs = null;

    try {

        con =
            com.jobportal.DBConnection.getConnection();


        String keyword =
            request.getParameter("keyword");

        String location =
            request.getParameter("location");

        String jobType =
            request.getParameter("job_type");


        String sql =
            "SELECT "
            + "j.job_id, "
            + "j.title, "
            + "j.description, "
            + "j.location, "
            + "j.salary, "
            + "j.job_type, "
            + "e.company_name "
            + "FROM jobs j "
            + "LEFT JOIN employers e "
            + "ON j.employer_id = e.employer_id "
            + "WHERE 1 = 1 ";


        if (keyword != null &&
            !keyword.trim().isEmpty()) {

            sql +=
                "AND (LOWER(j.title) LIKE LOWER(?) "
                + "OR LOWER(j.description) LIKE LOWER(?)) ";

        }


        if (location != null &&
            !location.trim().isEmpty()) {

            sql +=
                "AND LOWER(j.location) LIKE LOWER(?) ";

        }


        if (jobType != null &&
            !jobType.trim().isEmpty()) {

            sql +=
                "AND j.job_type = ? ";

        }


        sql +=
            "ORDER BY j.job_id DESC";


        ps =
            con.prepareStatement(sql);


        int index = 1;


        if (keyword != null &&
            !keyword.trim().isEmpty()) {

            String searchText =
                "%" + keyword.trim() + "%";

            ps.setString(
                index++,
                searchText
            );

            ps.setString(
                index++,
                searchText
            );

        }


        if (location != null &&
            !location.trim().isEmpty()) {

            ps.setString(
                index++,
                "%" + location.trim() + "%"
            );

        }


        if (jobType != null &&
            !jobType.trim().isEmpty()) {

            ps.setString(
                index++,
                jobType
            );

        }


        rs =
            ps.executeQuery();


        boolean found = false;

%>


<div class="table-container">

<table>

    <thead>

        <tr>

            <th>
                ID
            </th>

            <th>
                Job
            </th>

            <th>
                Employer
            </th>

            <th>
                Location
            </th>

            <th>
                Salary
            </th>

            <th>
                Type
            </th>

        </tr>

    </thead>


    <tbody>

<%

        while (rs.next()) {

            found = true;

%>

        <tr>

            <td>
                <%= rs.getInt("job_id") %>
            </td>


            <td>

                <strong>
                    <%= rs.getString("title") %>
                </strong>

                <br>

                <small>
                    <%= rs.getString("description") %>
                </small>

            </td>


            <td>

                <%= rs.getString("company_name") != null
                    ? rs.getString("company_name")
                    : "N/A" %>

            </td>


            <td>

                📍
                <%= rs.getString("location") %>

            </td>


            <td>

                ₹<%= rs.getString("salary") %>

            </td>


            <td>

                <span class="status status-shortlisted">

                    <%= rs.getString("job_type") %>

                </span>

            </td>

        </tr>

<%

        }


        if (!found) {

%>

        <tr>

            <td colspan="6"
                style="text-align:center;
                       padding:30px;">

                <strong>
                    No jobs found.
                </strong>

                <br><br>

                Try another keyword,
                location or job type.

            </td>

        </tr>

<%

        }

%>

    </tbody>

</table>

</div>


<%

    } catch (Exception e) {

%>

    <div class="card">

        <h3>
            Error Loading Jobs
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


<div class="footer">

    <p>
        © 2026 JobConnect - Online Job Portal
    </p>

    <p>
        Job Management Administration
    </p>

</div>


</body>

</html>