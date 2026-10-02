package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CompanyProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String companyName = request.getParameter("company_name");
        String companyDescription = request.getParameter("company_description");
        String companyLocation = request.getParameter("company_location");

        HttpSession session = request.getSession();

        int userId = (Integer) session.getAttribute("user_id");

        try {

            Connection con = DBConnection.getConnection();

            // Check whether company profile already exists
            String checkSql =
                    "SELECT employer_id FROM employers WHERE user_id = ?";

            PreparedStatement checkPs =
                    con.prepareStatement(checkSql);

            checkPs.setInt(1, userId);

            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {

                // Update existing company profile
                int employerId = rs.getInt("employer_id");

                String updateSql =
                        "UPDATE employers SET company_name = ?, "
                        + "company_description = ?, company_location = ? "
                        + "WHERE employer_id = ?";

                PreparedStatement updatePs =
                        con.prepareStatement(updateSql);

                updatePs.setString(1, companyName);
                updatePs.setString(2, companyDescription);
                updatePs.setString(3, companyLocation);
                updatePs.setInt(4, employerId);

                updatePs.executeUpdate();

                updatePs.close();

            } else {

                // Generate next employer ID
                String idSql =
                        "SELECT COALESCE(MAX(employer_id), 0) + 1 "
                        + "AS next_id FROM employers";

                PreparedStatement idPs =
                        con.prepareStatement(idSql);

                ResultSet idRs = idPs.executeQuery();

                int employerId = 1;

                if (idRs.next()) {
                    employerId = idRs.getInt("next_id");
                }

                idRs.close();
                idPs.close();

                // Insert new company profile
                String insertSql =
                        "INSERT INTO employers "
                        + "(employer_id, user_id, company_name, "
                        + "company_description, company_location) "
                        + "VALUES (?, ?, ?, ?, ?)";

                PreparedStatement insertPs =
                        con.prepareStatement(insertSql);

                insertPs.setInt(1, employerId);
                insertPs.setInt(2, userId);
                insertPs.setString(3, companyName);
                insertPs.setString(4, companyDescription);
                insertPs.setString(5, companyLocation);

                insertPs.executeUpdate();

                insertPs.close();
            }

            rs.close();
            checkPs.close();
            con.close();

            response.sendRedirect("employerDashboard.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Error: " + e.getMessage() + "</h2>"
            );
        }
    }
}