<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Job Seeker Dashboard - JobConnect</title>

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
            Manage your profile, find jobs and track your applications.
        </p>

    </div>


    <h2>
        Job Seeker Dashboard
    </h2>

    <br>


    <div class="dashboard-menu">


        <a href="profile.jsp"
           class="dashboard-card">

            <h3>
                👤 My Profile
            </h3>

            <p>
                Update your personal information,
                qualification and skills.
            </p>

        </a>


        <a href="searchJobs.jsp"
           class="dashboard-card">

            <h3>
                🔎 Find Jobs
            </h3>

            <p>
                Browse available job opportunities
                and find jobs that match your skills.
            </p>

        </a>


        <a href="myApplications.jsp"
           class="dashboard-card">

            <h3>
                📋 My Applications
            </h3>

            <p>
                View your submitted applications
                and check their current status.
            </p>

        </a>


        <a href="profile.jsp"
           class="dashboard-card">

            <h3>
                📄 My Resume
            </h3>

            <p>
                Keep your resume and professional
                information updated.
            </p>

        </a>


    </div>

</div>


<div class="footer">

    <p>
        © 2026 JobConnect - Online Job Portal
    </p>

    <p>
        Connecting Job Seekers with Employers
    </p>

</div>


</body>

</html>