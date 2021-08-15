<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>  
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>

<head style="opacity:1;">
        <title>MANGAdealer Main Page</title>
        
        <h1 align="center">Welcome to MANGAdealer</h1>
        <span align="left" id="time">Loading time...</span>
        <div style="float:right;">
        <span align="right"><a href="login.jsp">Login</a></span>

        <span align="right"><a href="listprod.jsp">Begin Shopping</a></span>

        <span align="right"><a href="listorder.jsp">List All Orders</a></span>

        <span align="right"><a href="admin.jsp">Administrators</a></span>

        <span align="right"><a href="logout.jsp">Log out</a></span>

        <span align="right"><a href="myaccount.jsp">My account</a></span>

        
        </div>
        </br>
        <style>
                body::before{
                        background-image:url('img/bg_img.jpg'); 
                        content: "";
                        opacity: 0.12;
                        top: 0;
                        left: 0;
                        bottom: 0;
                        right: 0;
                        position: absolute;
                        z-index: -1;  
                }
                
        </style>
        <script type="text/javascript" src="jquery-3.4.1.min.js"></script>
        <script>
                $(document).ready(function(){

                    setInterval("$('#time').load('time.jsp')",1000);
    
                });
    
    
        </script>
            
</head>
<body>


<%
// TODO: Display user name that is logged in (or nothing if not logged in)
        
        if((String)session.getAttribute("authenticatedUser")!=null){
                out.println("<center><b>Logged in as: " + (String)session.getAttribute("authenticatedUser") + "</b></center>");
                if(session.getAttribute("admin").equals("1")){out.println("<center><b>Admin Logging In</b></center>");}
                
        }

        String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
        String uid = "SA";
        String pw = "YourStrong@Passw0rd";

        try(Connection con = DriverManager.getConnection(url, uid, pw)){
                String sql = "select productName, sum(orderproduct.quantity) from orderproduct join product on product.productId = orderproduct.productId group by productName order by sum(orderproduct.quantity) desc;";
                PreparedStatement pstmt = con.prepareStatement(sql);
                ResultSet rst = pstmt.executeQuery();
                out.println("<center><div style=\"text-align:center;width: 30%; margin: 50px auto 0 auto;opacity:1;\">Our Top Sale Items:</br></br><table border=1 style=\"margin: 0 0 0 27%;opacity:1;\"><tr><th>Product Name</th><th>Sale</th></tr>");
                int counter = 0;
                while(rst.next() && counter<5){
                        out.println("<tr><td>"+rst.getString(1)+ "</td><td>" + rst.getInt(2) + "</td></tr>");
                        counter++;
                }
                out.println("</table></div></center>");
        }


%>
</body>
</head>


