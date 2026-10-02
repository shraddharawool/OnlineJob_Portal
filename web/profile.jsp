<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>My Profile - JobConnect</title>

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


<div class="form-container">

    <h2>
        My Professional Profile
    </h2>

    <p style="text-align:center;">
        Keep your professional information updated for employers.
    </p>

    <hr>


    <!-- USER NAME -->

    <div class="form-group">

        <label>
            Full Name
        </label>

        <input type="text"
               value="<%= session.getAttribute("name") %>"
               readonly>

    </div>


    <!-- EMAIL -->

    <div class="form-group">

        <label>
            Email Address
        </label>

        <input type="text"
               value="<%= session.getAttribute("email") %>"
               readonly>

    </div>


    <!-- PROFILE FORM -->

    <form action="ProfileServlet"
          method="post"
          enctype="multipart/form-data">


        <!-- PHONE -->

        <div class="form-group">

            <label>
                📱 Phone Number
            </label>

            <input type="text"
                   name="phone"
                   placeholder="Enter your phone number"
                   required>

        </div>


        <!-- QUALIFICATION -->

        <div class="form-group">

            <label>
                🎓 Qualification
            </label>

            <input type="text"
                   name="qualification"
                   placeholder="e.g. BSc IT, BCA, MCA"
                   required>

        </div>


        <!-- SKILLS -->

        <div class="form-group">

            <label>
                💻 Skills
            </label>

            <textarea
                name="skills"
                rows="5"
                placeholder="e.g. Java, JSP, SQL, HTML, CSS, Python"
                required></textarea>

        </div>


        <!-- RESUME UPLOAD -->

        <div class="form-group">

            <label>
                📄 Upload Resume (PDF)
            </label>

            <input type="file"
                   name="resume"
                   accept=".pdf,application/pdf"
                   required>

            <small>
                Only PDF files are allowed.
                Maximum file size: 5 MB.
            </small>

        </div>


        <!-- VIEW RESUME -->

        <div style="text-align:center;
                    margin-bottom:20px;">

            <a href="DownloadResumeServlet"
               class="btn btn-light"
               target="_blank">

                📄 View / Download My Resume

            </a>

        </div>


        <!-- BUTTONS -->

        <div style="text-align:center;">

            <input type="submit"
                   value="Save Profile"
                   class="btn btn-primary">

            <a href="seekerDashboard.jsp"
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
        Build your profile. Showcase your skills. Find your career.
    </p>

</div>


</body>

</html>