package com.jobportal;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig)
            throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpServletResponse res =
                (HttpServletResponse) response;

        String uri = req.getRequestURI();

        String contextPath =
                req.getContextPath();

        String page =
                uri.substring(contextPath.length());


        // Allow public pages

        if (page.equals("/")
                || page.equals("")
                || page.equals("/index.jsp")
                || page.equals("/login.jsp")
                || page.equals("/register.jsp")
                || page.equals("/LoginServlet")
                || page.equals("/RegisterServlet")
                || page.equals("/style.css")) {

            chain.doFilter(request, response);

            return;
        }


        HttpSession session =
                req.getSession(false);


        // User is not logged in

        if (session == null ||
            session.getAttribute("user_id") == null) {

            res.sendRedirect(
                    contextPath + "/login.jsp"
            );

            return;
        }


        String role =
                (String) session.getAttribute("role");


        // ADMIN PAGES

        if (page.startsWith("/admin")) {

            if (!"Admin".equals(role)) {

                res.sendRedirect(
                        contextPath + "/index.jsp"
                );

                return;
            }
        }


        // EMPLOYER PAGES

        if (page.equals("/employerDashboard.jsp")
                || page.equals("/companyProfile.jsp")
                || page.equals("/postJob.jsp")
                || page.equals("/manageJobs.jsp")
                || page.equals("/editJob.jsp")
                || page.equals("/viewApplicants.jsp")
                || page.equals("/updateApplication.jsp")
                || page.equals("/PostJobServlet")
                || page.equals("/CompanyProfileServlet")
                || page.equals("/EditJobServlet")
                || page.equals("/DeleteJobServlet")
                || page.equals("/UpdateApplicationServlet")) {

            if (!"Employer".equals(role)) {

                res.sendRedirect(
                        contextPath + "/index.jsp"
                );

                return;
            }
        }


        // JOB SEEKER PAGES

        if (page.equals("/seekerDashboard.jsp")
                || page.equals("/profile.jsp")
                || page.equals("/searchJobs.jsp")
                || page.equals("/myApplications.jsp")
                || page.equals("/applyJob.jsp")
                || page.equals("/printApplication.jsp")
                || page.equals("/DownloadResumeServlet")
                || page.equals("/ApplyJobServlet")
                || page.equals("/ProfileServlet")) {

            if (!"Job Seeker".equals(role)) {

                res.sendRedirect(
                        contextPath + "/index.jsp"
                );

                return;
            }
        }


        // Logout should always be allowed

        if (page.equals("/LogoutServlet")) {

            chain.doFilter(request, response);

            return;
        }


        // Continue request

        chain.doFilter(request, response);
    }


    @Override
    public void destroy() {
    }
}