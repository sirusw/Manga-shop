<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.Locale" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <style>
        body{
            margin: 0 0 0 10%;
            background-color:#fff9d4; 
            width:70%;
		}
        input{
            float:right;
        }
    </style>
</head>

<body>
<h2>Change my information</h2>
<%
    String custId = (String)session.getAttribute("authcid");
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pass = "YourStrong@Passw0rd";

    Connection con = DriverManager.getConnection(url, uid, pass);
    String sql = "select * from customer where customerId=?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1,custId);
    ResultSet rst = pstmt.executeQuery();
    rst.next();

out.println("<form name='changeInfo' action='updateInfo.jsp' method='get'>");
out.println("<div style='width:30%'>");
out.println("First Name: <input type='text' name='fn' value='"+rst.getString(2)+"'/></input></br>");
out.println("Last Name: <input type='text' name='ln' value='"+rst.getString(3)+"'/></br>");
out.println("Email: <input type='email' name='email' value='"+rst.getString(4)+"'/></br>");
out.println("Phone Number:<input type='tel' name='tel' value='"+rst.getString(5)+"'/></br>");
out.println("Address: <input type='text' name='addr' value='"+rst.getString(6)+"'/></br>");
out.println("City: <input type='text' name='ct' value='"+rst.getString(7)+"'/></br>");
out.println("State: <input type='text' name='st' value='"+rst.getString(8)+"'/></br>");
out.println("Postal Code<input type='text' name='pc' value='"+rst.getString(9)+"'/></br>");
out.println("Country: <input type='text' name='ctr' value='"+rst.getString(10)+"'/></br>");
out.println("<input style='display:none;' type='text' name='uname' value='"+rst.getString(11)+"'/>");
out.println("Password:<input type='text' name='pw' value='"+rst.getString(12)+"'/></br></br>");  
out.println("<input type='submit' name='Submit'></div></form>");      
    con.close();
%>
</body>
</html>
