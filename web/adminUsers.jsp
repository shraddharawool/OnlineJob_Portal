<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Manage Users - JobConnect</title>

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
            👥 Manage Users
        </h2>

        <p>
            View all registered users and their account types.
        </p>

    </div>


    <!-- SEARCH -->

    <div class="search-box">

        <form method="get"
              action="adminUsers.jsp">

            <input type="text"
                   name="search"
                   placeholder="Search by name or email"
                   value="<%= request.getParameter("search") != null
                           ? request.getParameter("search")
                           : "" %>">

            <select name="role">

                <option value="">
                    All Account Types
                </option>

                <option value="Job Seeker"
                    <%= "Job Seeker".equals(request.getParameter("role"))
                        ? "selected" : "" %>>
                    Job Seeker
                </option>

                <option value="Employer"
                    <%= "Employer".equals(request.getParameter("role"))
                        ? "selected" : "" %>>
                    Employer
                </option>

                <option value="Admin"
                    <%= "Admin".equals(request.getParameter("role"))
                        ? "selected" : "" %>>
                    Admin
                </option>

            </select>

            <input type="submit"
                   value="Search"
                   class="btn btn-primary">

            <a href="adminUsers.jsp"
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

        con = com.jobportal.DBConnection.getConnection();

        String search =
                request.getParameter("search");

        String role =
                request.getParameter("role");

        String sql =
                "SELECT user_id, name, email, role "
                + "FROM users "
                + "WHERE 1 = 1 ";

        if (search != null &&
            !search.trim().isEmpty()) {

            sql +=
                "AND (LOWER(name) LIKE LOWER(?) "
                + "OR LOWER(email) LIKE LOWER(?)) ";

        }

        if (role != null &&
            !role.trim().isEmpty()) {

            sql +=
                "AND role = ? ";

        }

        sql +=
            "ORDER BY user_id DESC";


        ps = con.prepareStatement(sql);

        int index = 1;


        if (search != null &&
            !search.trim().isEmpty()) {

            String text =
                "%" + search.trim() + "%";

            ps.setString(index++, text);

            ps.setString(index++, text);

        }


        if (role != null &&
            !role.trim().isEmpty()) {

            ps.setString(index++, role);

        }


        rs = ps.executeQuery();

        boolean found = false;

%>


<div class="table-container">

<table>

    <thead>

        <tr>

            <th>
                User ID
            </th>

            <th>
                Name
            </th>

            <th>
                Email
            </th>

            <th>
                Account Type
            </th>

        </tr>

    </thead>

    <tbody>

<%

        while (rs.next()) {

            found = true;

            String userRole =
                rs.getString("role");

%>

        <tr>

            <td>
                <%= rs.getInt("user_id") %>
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

                <span class="status status-shortlisted">

                    <%= userRole %>

                </span>

            </td>

        </tr>

<%

        }


        if (!found) {

%>

        <tr>

            <td colspan="4"
                style="text-align:center; padding:30px;">

                <strong>
                    No users found.
                </strong>

                <br><br>

                Try another search.

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
            Error Loading Users
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
        User Administration
    </p>

</div>


</body>

</html>