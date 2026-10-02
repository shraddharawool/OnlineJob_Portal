<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Post a Job - JobConnect</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<!-- NAVIGATION -->

<div class="navbar">

    <div class="logo">
        JobConnect
    </div>

    <div class="nav-links">

        <a href="employerDashboard.jsp">Dashboard</a>
        <a href="postJob.jsp">Post a Job</a>
        <a href="manageJobs.jsp">My Jobs</a>
        <a href="viewApplicants.jsp">Applicants</a>
        <a href="LogoutServlet">
    Logout
</a>

    </div>

</div>


<!-- POST JOB FORM -->

<div class="form-container">

    <h2>Post a New Job</h2>

    <p style="text-align:center;">
        Find the right candidate for your organization.
    </p>

    <br>

    <form action="PostJobServlet" method="post">

        <div class="form-group">

            <label>Job Title</label>

            <input
                type="text"
                name="title"
                placeholder="e.g. Java Developer, Accountant, HR Executive"
                required>

        </div>


        <div class="form-group">

            <label>Job Description</label>

            <textarea
                name="description"
                rows="6"
                placeholder="Describe the job responsibilities, requirements and skills..."
                required></textarea>

        </div>


        <div class="form-group">

            <label>Location</label>

            <input
                type="text"
                name="location"
                placeholder="e.g. Mumbai, Pune, Delhi, Bangalore or Remote">

        </div>


        <div class="form-group">

            <label>Salary</label>

            <input
                type="text"
                name="salary"
                placeholder="e.g. 30000-50000">

        </div>


        <div class="form-group">

            <label>Job Type</label>

            <select name="job_type">

                <option value="Full Time">
                    Full Time
                </option>

                <option value="Part Time">
                    Part Time
                </option>

                <option value="Internship">
                    Internship
                </option>

                <option value="Contract">
                    Contract
                </option>

            </select>

        </div>


        <div style="text-align:center;">

            <input
                type="submit"
                value="Post Job"
                class="btn btn-primary">

            <a
                href="employerDashboard.jsp"
                class="btn btn-light">

                Cancel

            </a>

        </div>

    </form>

</div>


<!-- FOOTER -->

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