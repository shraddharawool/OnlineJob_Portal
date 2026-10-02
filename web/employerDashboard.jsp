<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Employer Dashboard - JobConnect</title>

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

        <a href="companyProfile.jsp">
            Company
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
            Welcome, <%= session.getAttribute("name") %>! 👋
        </h2>

        <p>
            Manage your company, publish job opportunities
            and find the right candidates.
        </p>

    </div>


    <h2>
        Employer Dashboard
    </h2>

    <br>


    <div class="dashboard-menu">


        <a href="companyProfile.jsp"
           class="dashboard-card">

            <h3>
                🏢 Company Profile
            </h3>

            <p>
                Manage your company information,
                description and location.
            </p>

            <strong>
                Manage Profile →
            </strong>

        </a>


        <a href="postJob.jsp"
           class="dashboard-card">

            <h3>
                ➕ Post a Job
            </h3>

            <p>
                Create a new job vacancy and reach
                potential candidates.
            </p>

            <strong>
                Post Job →
            </strong>

        </a>


        <a href="manageJobs.jsp"
           class="dashboard-card">

            <h3>
                📋 Manage Jobs
            </h3>

            <p>
                View, edit and delete your existing
                job postings.
            </p>

            <strong>
                Manage Jobs →
            </strong>

        </a>


        <a href="viewApplicants.jsp"
           class="dashboard-card">

            <h3>
                👥 View Applicants
            </h3>

            <p>
                View candidates who have applied
                for your job openings.
            </p>

            <strong>
                View Applicants →
            </strong>

        </a>


        <a href="viewApplicants.jsp"
           class="dashboard-card">

            <h3>
                🔄 Update Applications
            </h3>

            <p>
                Select an applicant and update their
                application status.
            </p>

            <strong>
                Manage Applications →
            </strong>

        </a>


        <div class="dashboard-card">

            <h3>
                💼 Employer Tools
            </h3>

            <p>
                Manage vacancies, review candidates
                and handle recruitment activity.
            </p>

            <strong>
                System Active ✓
            </strong>

        </div>


    </div>


    <div class="dashboard-header"
         style="margin-top:30px;">

        <h3>
            ⚡ Quick Actions
        </h3>

        <p>

            <a href="postJob.jsp"
               class="btn btn-primary">

                ➕ Post New Job

            </a>


            <a href="viewApplicants.jsp"
               class="btn btn-light">

                👥 View Applicants

            </a>


            <a href="manageJobs.jsp"
               class="btn btn-light">

                📋 Manage Jobs

            </a>

        </p>

    </div>


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