<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Apply for Job - JobConnect</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>


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

        <a href="index.jsp">
            Logout
        </a>

    </div>

</div>


<div class="form-container">

    <h2>
        📄 Apply for Job
    </h2>

    <p style="text-align:center;">
        Submit your application for this opportunity.
    </p>

    <hr>


<%

    String jobId =
        request.getParameter("job_id");


    java.sql.Connection con = null;
    java.sql.PreparedStatement ps = null;
    java.sql.ResultSet rs = null;


    try {

        if (jobId == null ||
            jobId.trim().isEmpty()) {

%>

            <div class="card"
                 style="width:100%;">

                <h3>
                    Job ID is missing
                </h3>

                <p>
                    Please return to the job search
                    and select a job.
                </p>

                <a href="searchJobs.jsp"
                   class="btn btn-primary">

                    ← Find Jobs

                </a>

            </div>

<%

        } else {


            con =
                com.jobportal.DBConnection.getConnection();


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
                + "WHERE j.job_id = ?";


            ps =
                con.prepareStatement(sql);


            ps.setInt(
                1,
                Integer.parseInt(jobId)
            );


            rs =
                ps.executeQuery();


            if (rs.next()) {

%>


    <!-- JOB INFORMATION -->

    <div class="job-card">

        <h2>
            <%= rs.getString("title") %>
        </h2>


        <p class="job-info">

            🏢 <strong>Company:</strong>

            <%= rs.getString("company_name") != null
                ? rs.getString("company_name")
                : "Not specified" %>

        </p>


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


        <hr>


        <h3>
            Job Description
        </h3>

        <p>
            <%= rs.getString("description") %>
        </p>

    </div>


    <!-- APPLICATION FORM -->

    <form action="ApplyJobServlet"
          method="post">


        <input type="hidden"
               name="job_id"
               value="<%= rs.getInt("job_id") %>">


        <div class="form-group">

            <label>
                👤 Applicant Name
            </label>

            <input type="text"
                   value="<%= session.getAttribute("name") %>"
                   readonly>

        </div>


        <div class="form-group">

            <label>
                📧 Email Address
            </label>

            <input type="text"
                   value="<%= session.getAttribute("email") %>"
                   readonly>

        </div>


        <div class="form-group">

            <label>
                ✉ Cover Letter
            </label>

            <textarea name="cover_letter"
                      rows="7"
                      placeholder="Write a short message to the employer explaining why you are suitable for this position..."></textarea>

            <small>
                Introduce yourself and briefly mention
                your skills, qualification and interest
                in this position.
            </small>

        </div>


        <!-- APPLICATION NOTICE -->

        <div class="card"
             style="width:100%;
                    margin-bottom:20px;">

            <h3>
                📌 Before You Apply
            </h3>

            <p>
                Make sure your profile and resume are
                updated before submitting your application.
            </p>

            <p>
                ✓ Check your contact information
            </p>

            <p>
                ✓ Keep your skills updated
            </p>

            <p>
                ✓ Upload your latest resume
            </p>

        </div>


        <div style="text-align:center;">

            <input type="submit"
                   value="🚀 Submit Application"
                   class="btn btn-primary">


            <a href="searchJobs.jsp"
               class="btn btn-light">

                Cancel

            </a>

        </div>


    </form>


<%

            } else {

%>

        <div class="card"
             style="width:100%;">

            <h3>
                Job Not Found
            </h3>

            <p>
                The selected job is no longer available.
            </p>

            <a href="searchJobs.jsp"
               class="btn btn-primary">

                ← Back to Jobs

            </a>

        </div>

<%

            }

        }


    } catch (Exception e) {

%>

        <div class="card"
             style="width:100%;">

            <h3>
                Error Loading Job
            </h3>

            <p>
                <%= e.getMessage() %>
            </p>

            <a href="searchJobs.jsp"
               class="btn btn-primary">

                ← Back to Jobs

            </a>

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
        Apply online. Track applications. Build your career.
    </p>

</div>


</body>

</html>