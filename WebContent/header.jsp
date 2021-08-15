<H1 align="center" ><font face="cursive" color="#3399FF"><a href="index.jsp">MANGAdealer</a></font></H1>   
<%
// TODO: Display user name that is logged in (or nothing if not logged in)
        
        if((String)session.getAttribute("authenticatedUser")!=null){
                out.println("<center><b>Logged in as: " + (String)session.getAttribute("authenticatedUser") + "</b></center>");
                if(session.getAttribute("admin").equals("1")){out.println("<center><b>Admin Logging In</b></center>");}
        }
%>   
<hr>
