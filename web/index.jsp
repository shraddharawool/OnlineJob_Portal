<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Online Job Portal</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<!-- ================= NAVIGATION ================= -->

<div class="navbar">

    <div class="logo">
        JobConnect
    </div>

    <div class="nav-links">

        <a href="index.jsp">Home</a>

        <a href="login.jsp">Login</a>

        <a href="register.jsp">Register</a>

    </div>

</div>


<!-- ================= HERO SECTION ================= -->

<section class="hero">

    <h1>Find Your Dream Job</h1>

    <p>
        Discover opportunities, connect with employers,
        and build your career with JobConnect.
    </p>

    <a href="searchJobs.jsp" class="btn btn-light">
        Browse Jobs
    </a>

    <a href="register.jsp" class="btn btn-primary">
        Create Account
    </a>

</section>


<!-- ================= FEATURES ================= -->

<div class="container">

    <h2 style="text-align:center;">
        Everything You Need to Find a Job
    </h2>

    <br>

    <div class="card-container">

        <div class="card">

            <h3>🔎 Search Jobs</h3>

            <p>
                Search for jobs based on title,
                location and job type.
            </p>

        </div>


        <div class="card">

            <h3>👤 Create Profile</h3>

            <p>
                Create your professional profile
                and showcase your skills.
            </p>

        </div>


        <div class="card">

            <h3>📄 Apply Online</h3>

            <p>
                Apply for jobs online and
                track your application status.
            </p>

        </div>

    </div>

</div>


<!-- ================= FOR EMPLOYERS ================= -->

<div class="container">

    <div class="card-container">

        <div class="card">

            <h3>🏢 For Employers</h3>

            <p>
                Post job opportunities,
                manage job listings and
                find suitable candidates.
            </p>

            <a href="register.jsp" class="btn btn-primary">
                Register as Employer
            </a>

        </div>


        <div class="card">

            <h3>💼 For Job Seekers</h3>

            <p>
                Explore jobs, apply online
                and track your applications
                from one dashboard.
            </p>

            <a href="register.jsp" class="btn btn-primary">
                Find Jobs
            </a>

        </div>

    </div>

</div>


<!-- ================= FOOTER ================= -->

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