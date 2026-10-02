<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Create Account - JobConnect</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<!-- NAVIGATION -->

<div class="navbar">

    <div class="logo">
        JobConnect
    </div>

    <div class="nav-links">

        <a href="index.jsp">Home</a>
        <a href="login.jsp">Login</a>

    </div>

</div>


<!-- REGISTRATION FORM -->

<div class="form-container">

    <h2>Create Your Account</h2>

    <p style="text-align:center;">
        Join JobConnect and start your career journey
    </p>

    <br>

    <form action="RegisterServlet" method="post">

        <div class="form-group">

            <label>Full Name</label>

            <input
                type="text"
                name="name"
                placeholder="Enter your full name"
                required>

        </div>


        <div class="form-group">

            <label>Email Address</label>

            <input
                type="email"
                name="email"
                placeholder="Enter your email"
                required>

        </div>


        <div class="form-group">

            <label>Password</label>

            <input
                type="password"
                name="password"
                placeholder="Create a password"
                required>

        </div>


        <div class="form-group">

            <label>Account Type</label>

            <select name="role" required>

                <option value="">
                    -- Select Account Type --
                </option>

                <option value="Job Seeker">
                    Job Seeker
                </option>

                <option value="Employer">
                    Employer
                </option>

            </select>

        </div>


        <div style="text-align:center;">

            <input
                type="submit"
                value="Create Account"
                class="btn btn-primary">

        </div>

    </form>

    <hr>

    <p style="text-align:center;">

        Already have an account?

        <a href="login.jsp">
            Login here
        </a>

    </p>

    <p style="text-align:center;">

        <a href="index.jsp">
            ← Back to Home
        </a>

    </p>

</div>


<!-- FOOTER -->

<div class="footer">

    <p>
        © 2026 JobConnect - Online Job Portal
    </p>

</div>

</body>
</html>