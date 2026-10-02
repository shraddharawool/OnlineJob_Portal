<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Manage Applications - JobConnect</title>

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
            📋 Manage Applications
        </h2>

        <p>
            Monitor all job applications submitted by
            job seekers across the JobConnect portal.
        </p>

    </div>


    <!-- FILTER -->

    <div class="search-box">

        <form method="get"
              action="adminApplications.jsp">

            <input type="text"
                   name="keyword"
                   placeholder="Search applicant or job"
                   value="<%= request.getParameter("keyword") != null
                           ? request.getParameter("keyword")
                           : "" %>">


            <select name="status">

                <option value="">
                    All Statuses
                </option>

                <option value="Pending"
                    <%= "Pending".equals(request.getParameter("status"))
                        ? "selected" : "" %>>
                    Pending
                </option>

                <option value="Shortlisted"
                    <%= "Shortlisted".equals(request.getParameter("status"))
                        ? "selected" : "" %>>
                    Shortlisted
                </option>

                <option value="Selected"
                    <%= "Selected".equals(request.getParameter("status"))
                        ? "selected" : "" %>>
                    Selected
                </option>

                <option value="Rejected"
                    <%= "Rejected".equals(request.getParameter("status"))
                        ? "selected" : "" %>>
                    Rejected
                </option>

            </select>


            <input type="submit"
                   value="Search"
                   class="btn btn-primary">


            <a href="adminApplications.jsp"
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

        String status =
            request.getParameter("status");


        String sql =
            "SELECT "
            + "a.application_id, "
            + "a.application_date, "
            + "a.status, "
            + "j.title, "
            + "j.location, "
            + "u.name, "
            + "u.email, "
            + "e.company_name "
            + "FROM applications a "
            + "JOIN jobs j "
            + "ON a.job_id = j.job_id "
            + "JOIN job_seekers s "
            + "ON a.seeker_id = s.seeker_id "
            + "JOIN users u "
            + "ON s.user_id = u.user_id "
            + "LEFT JOIN employers e "
            + "ON j.employer_id = e.employer_id "
            + "WHERE 1 = 1 ";


        if (keyword != null &&
            !keyword.trim().isEmpty()) {

            sql +=
                "AND (LOWER(u.name) LIKE LOWER(?) "
                + "OR LOWER(u.email) LIKE LOWER(?) "
                + "OR LOWER(j.title) LIKE LOWER(?)) ";

        }


        if (status != null &&
            !status.trim().isEmpty()) {

            sql +=
                "AND a.status = ? ";

        }


        sql +=
            "ORDER BY a.application_id DESC";


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


            ps.setString(
                index++,
                searchText
            );

        }


        if (status != null &&
            !status.trim().isEmpty()) {

            ps.setString(
                index++,
                status
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
                Applicant
            </th>

            <th>
                Email
            </th>

            <th>
                Job
            </th>

            <th>
                Company
            </th>

            <th>
                Applied On
            </th>

            <th>
                Status
            </th>

        </tr>

    </thead>


    <tbody>

<%

        while (rs.next()) {

            found = true;


            String applicationStatus =
                rs.getString("status");


            String statusClass =
                "status-pending";


            if ("Shortlisted".equalsIgnoreCase(
                    applicationStatus)) {

                statusClass =
                    "status-shortlisted";

            }
            else if ("Selected".equalsIgnoreCase(
                    applicationStatus)) {

                statusClass =
                    "status-selected";

            }
            else if ("Rejected".equalsIgnoreCase(
                    applicationStatus)) {

                statusClass =
                    "status-rejected";

            }

%>

        <tr>

            <td>

                <strong>
                    #<%= rs.getInt("application_id") %>
                </strong>

            </td>


            <td>

                <strong>
                    <%= rs.getString("name") %>
                </strong>

            </td>


            <td>

                <%= rs.getString("email") %>

            </td>


            <td>

                <strong>
                    <%= rs.getString("title") %>
                </strong>

                <br>

                <small>

                    📍
                    <%= rs.getString("location") %>

                </small>

            </td>


            <td>

                <%= rs.getString("company_name") != null
                    ? rs.getString("company_name")
                    : "N/A" %>

            </td>


            <td>

                <%= rs.getDate("application_date") %>

            </td>


            <td>

                <span class="status <%= statusClass %>">

                    <%= applicationStatus %>

                </span>

            </td>

        </tr>

<%

        }


        if (!found) {

%>

        <tr>

            <td colspan="7"
                style="text-align:center;
                       padding:30px;">

                <strong>
                    No applications found.
                </strong>

                <br><br>

                Try another applicant,
                job title or status.

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


<div class="footer">

    <p>
        © 2026 JobConnect - Online Job Portal
    </p>

    <p>
        Application Management Administration
    </p>

</div>


</body>

</html>