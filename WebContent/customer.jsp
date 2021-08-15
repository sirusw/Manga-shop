<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<style>
	body{
			background-color:#fff9d4; 
			width:70%;
			margin: 0 auto 0 auto;
	}

	table{
		margin: 0 auto 0 auto;
	}

</style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// TODO: Print Customer information
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

String sql = "select * from customer where userid = ?";
try(Connection con = DriverManager.getConnection(url,uid,pw);){
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1,userName);
	ResultSet rst = pstmt.executeQuery();
	out.println("<center><h2>Customer Profile</h2></center><table border=\"1\">");
	String[] metadata = {"ID","First Name","Last Name", "Email","Phone","Address","City","State","Postal Code","Country","User ID"};
	int counter = 0;
	rst.next();
	while(counter<11){
		out.println("<tr><td>" + metadata[counter] + "</td><td>" + rst.getObject(counter+1) + "</td></tr>");
		counter++;
	}
	out.println("</table>");
}
catch(Exception e){out.println(e);}

// Make sure to close connection
%>

</body>
</html>

