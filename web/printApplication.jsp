<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Application Details - JobConnect</title>

    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            margin: 0;
            padding: 30px;
            color: #333;
        }

        .application-container {
            max-width: 850px;
            margin: auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.1);
        }

        h1 {
            color: #1e3a8a;
            text-align: center;
        }

        .section {
            margin-top: 25px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }

        .section h3 {
            color: #2563eb;
        }

        .row {
            margin: 10px 0;
        }

        .label {
            font-weight: bold;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px 5px;
            border-radius: 6px;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-light {
            background: #e5e7eb;
            color: #333;
        }

        .actions {
            text-align: center;
            margin-top: 25px;
        }

        @media print {

            body {
                background: white;
                padding: 0;
            }

            .application-container {
                box-shadow: none;
                max-width: 100%;
            }

            .actions {
                display: none;
            }
        }
    </style>
</head>

<body>

<%
    java.sql.Connection con = null;
    java.sql.PreparedStatement ps = null;
    java.sql.ResultSet rs = null;

    try {

        // Check login
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Only Job Seekers can view their applications
        String role =
                (String) session.getAttribute("role");

        if (!"Job Seeker".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId =
                (Integer) session.getAttribute("user_id");

        String applicationIdText =
                request.getParameter("application_id");

        int applicationId =
                Integer.parseInt(applicationIdText);

        con =
                com.jobportal.DBConnection.getConnection();

        /*
         * IMPORTANT:
         * The application is loaded only when it belongs
         * to the currently logged-in Job Seeker.
         */
        String sql =
                "SELECT a.application_id, "
                + "a.application_date, "
                + "a.status, "
                + "u.name AS applicant_name, "
                + "u.email AS applicant_email, "
                + "j.title AS job_title, "
                + "j.location, "
                + "j.salary, "
                + "j.job_type, "
                + "e.company_name "
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
                + "AND js.user_id = ?";

        ps = con.prepareStatement(sql);

        ps.setInt(1, applicationId);
        ps.setInt(2, userId);

        rs = ps.executeQuery();

        if (rs.next()) {
%>

<div class="application-container">

    <h1>Job Application</h1>

    <div class="section">

        <h3>Applicant Information</h3>

        <div class="row">
            <span class="label">Name:</span>
            <%= rs.getString("applicant_name") %>
        </div>

        <div class="row">
            <span class="label">Email:</span>
            <%= rs.getString("applicant_email") %>
        </div>

    </div>

    <div class="section">

        <h3>Job Information</h3>

        <div class="row">
            <span class="label">Job Title:</span>
            <%= rs.getString("job_title") %>
        </div>

        <div class="row">
            <span class="label">Company:</span>
            <%= rs.getString("company_name") %>
        </div>

        <div class="row">
            <span class="label">Location:</span>
            <%= rs.getString("location") %>
        </div>

        <div class="row">
            <span class="label">Salary:</span>
            <%= rs.getString("salary") %>
        </div>

        <div class="row">
            <span class="label">Job Type:</span>
            <%= rs.getString("job_type") %>
        </div>

    </div>

    <div class="section">

        <h3>Application Information</h3>

        <div class="row">
            <span class="label">Application ID:</span>
            <%= rs.getInt("application_id") %>
        </div>

        <div class="row">
            <span class="label">Application Date:</span>
            <%= rs.getDate("application_date") %>
        </div>

        <div class="row">
            <span class="label">Status:</span>
            <%= rs.getString("status") %>
        </div>

    </div>

    <div class="actions">

        <button onclick="window.print()"
                class="btn btn-primary">
            🖨 Print / Save as PDF
        </button>

        <a href="myApplications.jsp"
           class="btn btn-light">
            Back to Applications
        </a>

    </div>

</div>

<%
        } else {
%>

<div class="application-container">

    <h2>Application Not Found</h2>

    <p>
        You are not authorized to view this application,
        or the application does not exist.
    </p>

    <div class="actions">

        <a href="myApplications.jsp"
           class="btn btn-primary">
            Back to Applications
        </a>

    </div>

</div>

<%
        }

    } catch (Exception e) {

        out.println(
            "<h2>Error: " + e.getMessage() + "</h2>"
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

</body>
</html>