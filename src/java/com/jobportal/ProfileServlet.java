package com.jobportal;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class ProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer userId =
                (Integer) session.getAttribute("user_id");

        if (userId == null) {

            response.sendRedirect("login.jsp");

            return;
        }

        String phone =
                request.getParameter("phone");

        String qualification =
                request.getParameter("qualification");

        String skills =
                request.getParameter("skills");


        Part resumePart =
                request.getPart("resume");


        String fileName = null;


        try {

            /*
             * Check that a file was selected
             */

            if (resumePart == null ||
                resumePart.getSize() == 0) {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>Please select a PDF resume.</h2>"
                );

                response.getWriter().println(
                        "<a href='profile.jsp'>Back to Profile</a>"
                );

                return;
            }


            /*
             * Get original file name
             */

            String submittedFileName =
                    resumePart.getSubmittedFileName();


            if (submittedFileName == null ||
                submittedFileName.trim().isEmpty()) {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>Please select a resume file.</h2>"
                );

                response.getWriter().println(
                        "<a href='profile.jsp'>Back to Profile</a>"
                );

                return;
            }


            /*
             * Check PDF extension
             */

            String lowerFileName =
                    submittedFileName.toLowerCase();

            if (!lowerFileName.endsWith(".pdf")) {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>Only PDF files are allowed.</h2>"
                );

                response.getWriter().println(
                        "<a href='profile.jsp'>Back to Profile</a>"
                );

                return;
            }


            /*
             * Create a unique file name.
             * This prevents two users from
             * overwriting each other's resumes.
             */

            fileName =
                    "resume_" + userId + "_"
                    + System.currentTimeMillis()
                    + ".pdf";


            /*
             * Create uploads folder
             * inside the web application.
             */

            String uploadPath =
                    getServletContext().getRealPath("")
                    + File.separator
                    + "uploads";


            File uploadDirectory =
                    new File(uploadPath);


            if (!uploadDirectory.exists()) {

                uploadDirectory.mkdirs();

            }


            /*
             * Save uploaded PDF
             */

            File savedFile =
                    new File(
                            uploadDirectory,
                            fileName
                    );


            InputStream inputStream =
                    resumePart.getInputStream();


            Files.copy(
                    inputStream,
                    savedFile.toPath(),
                    StandardCopyOption.REPLACE_EXISTING
            );


            inputStream.close();


            /*
             * Connect to database
             */

            Connection con =
                    DBConnection.getConnection();


            /*
             * Check whether profile already exists
             */

            String checkSql =
                    "SELECT seeker_id "
                    + "FROM job_seekers "
                    + "WHERE user_id = ?";


            PreparedStatement checkPs =
                    con.prepareStatement(checkSql);


            checkPs.setInt(1, userId);


            ResultSet rs =
                    checkPs.executeQuery();


            if (rs.next()) {

                /*
                 * Existing profile
                 * Update it.
                 */

                String updateSql =
                        "UPDATE job_seekers "
                        + "SET phone = ?, "
                        + "qualification = ?, "
                        + "skills = ?, "
                        + "resume = ? "
                        + "WHERE user_id = ?";


                PreparedStatement updatePs =
                        con.prepareStatement(updateSql);


                updatePs.setString(
                        1,
                        phone
                );

                updatePs.setString(
                        2,
                        qualification
                );

                updatePs.setString(
                        3,
                        skills
                );

                updatePs.setString(
                        4,
                        fileName
                );

                updatePs.setInt(
                        5,
                        userId
                );


                updatePs.executeUpdate();

                updatePs.close();


            } else {

                /*
                 * New profile
                 * Generate seeker ID.
                 */

                String idSql =
                        "SELECT COALESCE(MAX(seeker_id), 0) + 1 "
                        + "AS next_id "
                        + "FROM job_seekers";


                PreparedStatement idPs =
                        con.prepareStatement(idSql);


                ResultSet idRs =
                        idPs.executeQuery();


                int seekerId = 1;


                if (idRs.next()) {

                    seekerId =
                            idRs.getInt("next_id");

                }


                idRs.close();

                idPs.close();


                /*
                 * Insert new profile
                 */

                String insertSql =
                        "INSERT INTO job_seekers "
                        + "(seeker_id, user_id, phone, "
                        + "qualification, skills, resume) "
                        + "VALUES (?, ?, ?, ?, ?, ?)";


                PreparedStatement insertPs =
                        con.prepareStatement(insertSql);


                insertPs.setInt(
                        1,
                        seekerId
                );

                insertPs.setInt(
                        2,
                        userId
                );

                insertPs.setString(
                        3,
                        phone
                );

                insertPs.setString(
                        4,
                        qualification
                );

                insertPs.setString(
                        5,
                        skills
                );

                insertPs.setString(
                        6,
                        fileName
                );


                insertPs.executeUpdate();

                insertPs.close();

            }


            rs.close();

            checkPs.close();

            con.close();


            /*
             * Profile saved successfully.
             */

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Profile saved successfully!</h2>"
            );

            response.getWriter().println(
                    "<p>Your PDF resume has been uploaded.</p>"
            );

            response.getWriter().println(
                    "<p>File: " + fileName + "</p>"
            );

            response.getWriter().println(
                    "<br>"
            );

            response.getWriter().println(
                    "<a href='seekerDashboard.jsp'>"
                    + "Go to Dashboard"
                    + "</a>"
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Error uploading resume</h2>"
            );

            response.getWriter().println(
                    "<p>"
                    + e.getMessage()
                    + "</p>"
            );

            response.getWriter().println(
                    "<a href='profile.jsp'>"
                    + "Back to Profile"
                    + "</a>"
            );

        }

    }

}