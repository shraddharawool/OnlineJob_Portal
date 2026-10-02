<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Company Profile - JobConnect</title>

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


<div class="form-container">

    <h2>
        🏢 Company Profile
    </h2>

    <p style="text-align:center;">
        Build your company profile and help candidates
        learn more about your organization.
    </p>

    <hr>


<%

    java.sql.Connection con = null;
    java.sql.PreparedStatement ps = null;
    java.sql.ResultSet rs = null;

    String companyName = "";
    String companyDescription = "";
    String companyLocation = "";

    try {

        Integer userId =
            (Integer) session.getAttribute("user_id");


        con =
            com.jobportal.DBConnection.getConnection();


        String sql =
            "SELECT company_name, "
            + "company_description, "
            + "company_location "
            + "FROM employers "
            + "WHERE user_id = ?";


        ps =
            con.prepareStatement(sql);


        ps.setInt(
            1,
            userId
        );


        rs =
            ps.executeQuery();


        if (rs.next()) {

            companyName =
                rs.getString("company_name");

            companyDescription =
                rs.getString("company_description");

            companyLocation =
                rs.getString("company_location");

        }


    } catch (Exception e) {

        out.println(
            "<p style='color:red;'>"
            + "Error loading profile: "
            + e.getMessage()
            + "</p>"
        );

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


    <!-- COMPANY NAME -->

    <form action="CompanyProfileServlet"
          method="post">


        <div class="form-group">

            <label>
                🏢 Company Name
            </label>

            <input type="text"
                   name="company_name"
                   value="<%= companyName != null
                           ? companyName : "" %>"
                   placeholder="Enter company name"
                   required>

        </div>


        <!-- COMPANY LOCATION -->

        <div class="form-group">

            <label>
                📍 Company Location
            </label>

            <input type="text"
                   name="company_location"
                   value="<%= companyLocation != null
                           ? companyLocation : "" %>"
                   placeholder="e.g. Mumbai, Maharashtra"
                   required>

        </div>


        <!-- COMPANY DESCRIPTION -->

        <div class="form-group">

            <label>
                📝 Company Description
            </label>

            <textarea name="company_description"
                      rows="6"
                      placeholder="Describe your company, services and work culture..."
                      required><%= companyDescription != null
                              ? companyDescription : "" %></textarea>

        </div>


        <!-- PROFILE INFORMATION -->

        <div class="card"
             style="width:100%;
                    margin-bottom:20px;">

            <h3>
                💡 Profile Tips
            </h3>

            <p>
                A complete company profile helps job seekers
                understand your organization before applying.
            </p>

            <p>
                ✓ Add your company name
            </p>

            <p>
                ✓ Mention your location
            </p>

            <p>
                ✓ Describe your services and organization
            </p>

        </div>


        <!-- BUTTONS -->

        <div style="text-align:center;">

            <input type="submit"
                   value="Save Company Profile"
                   class="btn btn-primary">


            <a href="employerDashboard.jsp"
               class="btn btn-light">

                Cancel

            </a>

        </div>


    </form>

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