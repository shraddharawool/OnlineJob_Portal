package com.jobportal;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DownloadResumeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer userId =
                (Integer) session.getAttribute("user_id");

        if (userId == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String sql =
                    "SELECT resume "
                    + "FROM job_seekers "
                    + "WHERE user_id = ?";

            ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            rs = ps.executeQuery();

            if (rs.next()) {

                String fileName =
                        rs.getString("resume");

                if (fileName == null ||
                    fileName.trim().isEmpty()) {

                    response.setContentType("text/html");

                    response.getWriter().println(
                            "<h2>No resume uploaded.</h2>"
                    );

                    response.getWriter().println(
                            "<a href='profile.jsp'>"
                            + "Back to Profile"
                            + "</a>"
                    );

                    return;
                }

                String uploadPath =
                        getServletContext().getRealPath("")
                        + File.separator
                        + "uploads";

                File resumeFile =
                        new File(uploadPath, fileName);

                if (!resumeFile.exists()) {

                    response.setContentType("text/html");

                    response.getWriter().println(
                            "<h2>Resume file not found.</h2>"
                    );

                    response.getWriter().println(
                            "<a href='profile.jsp'>"
                            + "Back to Profile"
                            + "</a>"
                    );

                    return;
                }

                response.setContentType(
                        "application/pdf"
                );

                response.setHeader(
                        "Content-Disposition",
                        "inline; filename=\"" + fileName + "\""
                );

                response.setContentLengthLong(
                        resumeFile.length()
                );

                InputStream inputStream =
                        new java.io.FileInputStream(
                                resumeFile
                        );

                OutputStream outputStream =
                        response.getOutputStream();

                byte[] buffer = new byte[4096];

                int bytesRead;

                while ((bytesRead =
                        inputStream.read(buffer)) != -1) {

                    outputStream.write(
                            buffer,
                            0,
                            bytesRead
                    );
                }

                outputStream.flush();

                inputStream.close();

            } else {

                response.setContentType("text/html");

                response.getWriter().println(
                        "<h2>Profile not found.</h2>"
                );

                response.getWriter().println(
                        "<a href='profile.jsp'>"
                        + "Back to Profile"
                        + "</a>"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Error opening resume</h2>"
            );

            response.getWriter().println(
                    "<p>"
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
    }
}