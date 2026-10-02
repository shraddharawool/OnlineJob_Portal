<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Application - JobConnect</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<div class="navbar">
    <div class="logo">JobConnect</div>

    <div class="nav-links">
        <a href="employerDashboard.jsp">Dashboard</a>
        <a href="manageJobs.jsp">My Jobs</a>
        <a href="viewApplicants.jsp">Applicants</a>
        <a href="LogoutServlet">Logout</a>
    </div>
</div>

<div class="form-container">

    <h2>Update Application Status</h2>

<%
    String applicationIdText =
            request.getParameter("application_id");

    java.sql.Connection con = null;
    java.sql.PreparedStatement ps = null;
    java.sql.ResultSet rs = null;

    try {

        if (session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role =
                (String) session.getAttribute("role");

        if (!"Employer".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId =
                (Integer) session.getAttribute("user_id");

        int applicationId =
                Integer.parseInt(applicationIdText);

        con =
                com.jobportal.DBConnection.getConnection();

        /*
         * Load the application only when the
         * application belongs to a job posted
         * by the logged-in employer.
         */
        String sql =
                "SELECT a.application_id, "
                + "a.status, "
                + "u.name AS applicant_name, "
                + "u.email AS applicant_email, "
                + "j.title AS job_title "
                + "FROM applications a "
                + "INNER JOIN job_seekers js "
                + "ON a.seeker_id = js.seeker_id "
                + "INNER JOIN users u "
                + "ON js.user_id = u.user_id "
                + "INNER JOIN jobs j "
                + "ON a.job_id = j.job_id "
                + "INNER JOIN employers e "
                + "ON j.employer_id = e.employer_id "
                + "WHERE a.application_id = ? "
                + "AND e.user_id = ?";

        ps = con.prepareStatement(sql);

        ps.setInt(1, applicationId);
        ps.setInt(2, userId);

        rs = ps.executeQuery();

        if (rs.next()) {
%>

    <div class="dashboard-header">

        <p>
            <strong>Applicant:</strong>
            <%= rs.getString("applicant_name") %>
        </p>

        <p>
            <strong>Email:</strong>
            <%= rs.getString("applicant_email") %>
        </p>

        <p>
            <strong>Job:</strong>
            <%= rs.getString("job_title") %>
        </p>

        <p>
            <strong>Current Status:</strong>
            <%= rs.getString("status") %>
        </p>

    </div>

    <form action="UpdateApplicationServlet"
          method="post">

        <input type="hidden"
               name="application_id"
               value="<%= rs.getInt("application_id") %>">

        <div class="form-group">

            <label>Application Status</label>

            <select name="status" required>

                <option value="Pending"
                    <%= "Pending".equals(rs.getString("status"))
                        ? "selected" : "" %>>
                    Pending
                </option>

                <option value="Shortlisted"
                    <%= "Shortlisted".equals(rs.getString("status"))
                        ? "selected" : "" %>>
                    Shortlisted
                </option>

                <option value="Selected"
                    <%= "Selected".equals(rs.getString("status"))
                        ? "selected" : "" %>>
                    Selected
                </option>

                <option value="Rejected"
                    <%= "Rejected".equals(rs.getString("status"))
                        ? "selected" : "" %>>
                    Rejected
                </option>

            </select>

        </div>

        <div style="text-align:center;">

            <input type="submit"
                   value="Update Status"
                   class="btn btn-primary">

            <a href="viewApplicants.jsp"
               class="btn btn-light">
                Cancel
            </a>

        </div>

    </form>

<%
        } else {
%>

    <h3>You are not authorized to access this application.</h3>

    <br>

    <a href="viewApplicants.jsp"
       class="btn btn-primary">
        Back to Applicants
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