<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Admin Dashboard - JobConnect</title>

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
            🛡 Admin Dashboard
        </h2>

        <p>
            Welcome to the JobConnect administration panel.
            Manage users, employers, jobs and applications.
        </p>

    </div>


    <div class="dashboard-menu">


        <a href="adminUsers.jsp"
           class="dashboard-card">

            <h3>
                👥 Manage Users
            </h3>

            <p>
                View registered job seekers,
                employers and administrator accounts.
            </p>

            <strong>
                View Users →
            </strong>

        </a>


        <a href="adminJobs.jsp"
           class="dashboard-card">

            <h3>
                💼 Manage Jobs
            </h3>

            <p>
                View all job vacancies posted
                by employers on the portal.
            </p>

            <strong>
                View Jobs →
            </strong>

        </a>


        <a href="adminApplications.jsp"
           class="dashboard-card">

            <h3>
                📋 Manage Applications
            </h3>

            <p>
                Monitor applications submitted
                by job seekers.
            </p>

            <strong>
                View Applications →
            </strong>

        </a>


        <div class="dashboard-card">

            <h3>
                🔐 System Administration
            </h3>

            <p>
                JobConnect provides centralized
                management of the online recruitment system.
            </p>

            <strong>
                System Active ✓
            </strong>

        </div>


    </div>


    <div class="dashboard-header"
         style="margin-top:30px;">

        <h3>
            📊 Administration Overview
        </h3>

        <p>
            Use the management sections above to monitor
            the complete job portal.
        </p>

        <p>

            <strong>
                Job Seekers
            </strong>

            → Profiles, resumes and applications

        </p>

        <p>

            <strong>
                Employers
            </strong>

            → Companies and job postings

        </p>

        <p>

            <strong>
                Applications
            </strong>

            → Application status and recruitment activity

        </p>

    </div>

</div>


<div class="footer">

    <p>
        © 2026 JobConnect - Online Job Portal
    </p>

    <p>
        Administration Panel
    </p>

</div>


</body>

</html>