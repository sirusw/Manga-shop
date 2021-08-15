<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
<title>MANGAdealer</title>
<style>
	html{
		background-color: #e5e6dc;
	}
	head, body{
		width: 80%;
		margin: 0 10% 0 10%;
		background-color: #f2f5d7;
	}
	.search{
		text-align:center;
		margin-top:10px;
		padding-top: 10px;
		padding-bottom: 10px;
		width:70%;
		margin: 0 10% 0 16%;
	}
	.tbl{
		margin: 0 10% 0 33%;
	}
	body{
		width: 100%;
	}
	
</style>
</head>
<body>

<div class="search">
<p style="display:inline">Search:</p>

<form method="get" action="listprod.jsp" style="display:inline">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> 

</form>
</div>

<% // Get product name to search for
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

String name = request.getParameter("productName");
if(name==null || name==""){	
	//Note: Forces loading of SQL Server driver
	try(Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement())
	{	// Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		String sql = "select productId, productName, productPrice from product";
		PreparedStatement pstmt = con.prepareStatement(sql);
		ResultSet rst = pstmt.executeQuery();
		Locale locale = new Locale("en","US");
		NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);
		out.println("<div class=\"tbl\">");
		out.println("<h1 style = \"margin-bottom:0;\">All Products</h1><table><tr><th>Product Name</th><th>Price</th></tr>");
		while(rst.next()){
			String productId = rst.getString(1);
			String productName = rst.getString(2);
			Double productPrice = rst.getDouble(3);
			out.println("<tr><td><a href=\"addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice+"\">Add to Cart</a></td><td>" + rst.getString(2) + "</td><td>" + currFormat.format(rst.getDouble(3))+"</td></tr>");
		}
		out.println("</table>");
		out.println("</div>");
		out.println("<h2><a href=\"showcart.jsp\">Shopping Cart</a></h2>");
		out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
	}
	catch (java.lang.ClassNotFoundException e)
	{
		out.println("ClassNotFoundException: " +e);
	}
}
else{
	try(Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement())
	{	
		String sql = "select productId, productName, productPrice from product where productName like ?";
		PreparedStatement pst = con.prepareStatement(sql);
		pst.setString(1,"%"+ name + "%");
		ResultSet r = pst.executeQuery();
		Locale locale = new Locale("en","US");
		NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);
		out.println("<div class=\"tbl\">");
		out.println("<h1 style = \"margin-bottom:0;\">All Products</h1><table><tr><th>Product Name</th><th>Price</th></tr>");
		while(r.next()){
			String productId = r.getString(1);
			String productName = r.getString(2);
			Double productPrice = r.getDouble(3);
			out.println("<tr><td><a href=\"addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice+"\">Add to Cart</a></td><td>" + r.getString(2) + "</td><td>" + currFormat.format(r.getDouble(3))+"</td></tr>");
		}
		out.println("</table>");
		out.println("</div>");
		out.println("<h2><a href=\"listprod.jsp\">All products</a></h2>");
		out.println("<h2><a href=\"showcart.jsp\">Shopping Cart</a></h2>");
		out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
	
	}
	catch(Exception e){
		out.println(e);
	}
}





// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection

// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>