<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Login - JobConnect</title>

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
        <a href="register.jsp">Register</a>

    </div>

</div>


<!-- LOGIN FORM -->

<div class="form-container">

    <h2>Welcome Back</h2>

    <p style="text-align:center;">
        Login to your JobConnect account
    </p>

    <br>

    <form action="LoginServlet" method="post">

        <div class="form-group">

            <label>Email</label>

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
                placeholder="Enter your password"
                required>

        </div>


        <div style="text-align:center;">

            <input
                type="submit"
                value="Login"
                class="btn btn-primary">

        </div>

    </form>

    <hr>

    <p style="text-align:center;">

        Don't have an account?

        <a href="register.jsp">
            Create Account
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