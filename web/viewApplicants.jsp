<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Applicants - JobConnect</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<div class="navbar">

    <div class="logo">
        JobConnect
    </div>

    <div class="nav-links">

        <a href="employerDashboard.jsp">
            Dashboard
        </a>

        <a href="postJob.jsp">
            Post a Job
        </a>

        <a href="manageJobs.jsp">
            My Jobs
        </a>

        <a href="viewApplicants.jsp">
            Applicants
        </a>

      <a href="LogoutServlet">
    Logout
</a>

    </div>

</div>


<div class="container">

    <div class="dashboard-header">

        <h2>
            👥 Job Applicants
        </h2>

        <p>
            View candidates who have applied for your job
            openings and manage their application status.
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
                + "j.title, "
                + "u.name, "
                + "u.email, "
                + "a.application_date, "
                + "a.status "
                + "FROM applications a "
                + "JOIN jobs j "
                + "ON a.job_id = j.job_id "
                + "JOIN employers e "
                + "ON j.employer_id = e.employer_id "
                + "JOIN job_seekers s "
                + "ON a.seeker_id = s.seeker_id "
                + "JOIN users u "
                + "ON s.user_id = u.user_id "
                + "WHERE e.user_id = ? "
                + "ORDER BY a.application_id DESC";

        ps = con.prepareStatement(sql);

        ps.setInt(1, userId);

        rs = ps.executeQuery();

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
                Applied On
            </th>

            <th>
                Status
            </th>

            <th>
                Action
            </th>

        </tr>

    </thead>

    <tbody>

<%

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

        <tr>

            <td>
                <%= rs.getInt("application_id") %>
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
                <%= rs.getString("title") %>
            </td>

            <td>
                <%= rs.getDate("application_date") %>
            </td>

            <td>

                <span class="status <%= statusClass %>">

                    <%= status %>

                </span>

            </td>

            <td>

                <a
                    href="updateApplication.jsp?application_id=<%= rs.getInt("application_id") %>"
                    class="btn btn-primary">

                    Update

                </a>

            </td>

        </tr>

<%

        }

        if (!found) {

%>

        <tr>

            <td colspan="7"
                style="text-align:center; padding:30px;">

                <strong>
                    No applicants yet.
                </strong>

                <br><br>

                Candidates who apply for your jobs
                will appear here.

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
            Error Loading Applicants
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
        Helping employers find the right talent.
    </p>

</div>


</body>

</html>