<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>MANGAdealer</title>
<style>

	body{
			background-color:#fff9d4; 
			width:70%;
			margin: 0 auto 0 auto;
	}
	
	.search{
		text-align:center;
		margin-top:10px;
		padding-top: 10px;
		padding-bottom: 10px;
		width:70%;
		margin: 0 auto 0 auto;
	}
	.tbl{
		padding-right:5%;
		float:right;
	}
	.topsales{
		float:left;
		
	}
	.rec{
		float:left;
		text-align: center;
		margin: 40px auto 0 50px;
	}
	
	
</style>
</head>
<body>
<center>
<form method='get' action = 'listprod.jsp'>
<label for="ct">Choose a Genre</label>

<select name="category" id="ct">
  <option value="" selected disabled hidden>Choose here</option>
  <option value="1">Horror</option>
  <option value="2">Romance</option>
  <option value="3">Action</option>
  <option value="4">Comedy</option>
  <option value="5">Sci-fi</option>
  <option value="6">Mystery</option>
</select>
<input type="submit" value="Go">
</form>
</center>

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
		PreparedStatement pstmt = null;
		if(request.getParameter("category")!=null){
			String sql = "select productId, productName, productPrice from product where categoryId=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1,Integer.parseInt(request.getParameter("category")));
		}
		else{
			String sql = "select productId, productName, productPrice from product";
			pstmt = con.prepareStatement(sql);
		}

		ResultSet rst = pstmt.executeQuery();
		Locale locale = new Locale("en","US");
		NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);
		out.println("<div class=\"tbl\">");
		out.println("<h1 style = \"margin-bottom:0;\">All Products</h1><table><tr><th>Product Name</th><th>Price</th></tr>");
		while(rst.next()){
			String productId = rst.getString(1);
			String productName = rst.getString(2);
			Double productPrice = rst.getDouble(3);
			out.println("<tr><td><a href=\"addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice+"\">Add to Cart</a></td><td><a href=\"product.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice+"\">"+rst.getString(2)+"</a></td><td>" + currFormat.format(rst.getDouble(3))+ "</td></tr>");
		}
		out.println("</table>");
		out.println("</div>");
		out.println("<h2><a href=\"showcart.jsp\">Shopping Cart</a></h2>");
		out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");

		String sq = "select productName, sum(orderproduct.quantity) from orderproduct join product on product.productId = orderproduct.productId group by productName order by sum(orderproduct.quantity) desc;";
		PreparedStatement pstmt1 = con.prepareStatement(sq);
		ResultSet rst1 = pstmt1.executeQuery();
		out.println("<div class = \"topsales\" style=\"text-align:center;width: 30%; margin: 50px auto 0 auto;opacity:1;\">Our Top Sale Items:</br></br><table border=1 style=\"margin: 0 0 0 17%;opacity:1;\"><tr><th>Product Name</th><th>Sale</th></tr>");
		int counter = 0;
		while(rst1.next() && counter<5){
				out.println("<tr><td>"+rst1.getString(1)+ "</td><td>" + rst1.getInt(2) + "</td></tr>");
				counter++;
		}
		out.println("</table></div>");

		
	//gets genre of last ordered by customer
		String currCustId = (String)session.getAttribute("authcid");

		sq = "select p.productId, p.categoryId from orderproduct op \n"+ 
		"join ordersummary os on op.orderId = os.orderID \n"+ 
		"join customer c on c.customerId = os.customerId \n"+
		"join product p on op.productId = p.productId \n"+
		"where c.customerId=?";

		PreparedStatement ps = con.prepareStatement(sq);
		ps.setString(1,currCustId);
		ResultSet r = ps.executeQuery();
		if(r.next()){
			String pid = r.getString(1);
			String catid = r.getString(2);
	
			sq = "select productName from product join category on product.categoryId = category.categoryId where product.categoryId=? and product.productId != ?";
			ps = con.prepareStatement(sq);
			ps.setString(1,pid);
			ps.setInt(2, Integer.parseInt(catid));
			r = ps.executeQuery();
			out.println("<br><div class='rec'>Recommendation for you:<br><table border='1'>");
			while(r.next()){
			out.println("<tr><td>"+r.getString(1)+"</td></tr>");
			}
			out.println("</table></div>");
		}



	}
	catch (java.lang.ClassNotFoundException e)
	{
		out.println("ClassNotFoundException: " +e);
	}
}
else{
	try(Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement())
	{	
		PreparedStatement pst = null;
		if(request.getParameter("category")!=null){
			String sql = "select productId, productName, productPrice from product where productName like ? and categoryId=?";
			pst = con.prepareStatement(sql);
			pst.setString(1,"%"+ name + "%");
			pst.setInt(2,Integer.parseInt(request.getParameter("category")));
		}
		else{
			String sql = "select productId, productName, productPrice from product where productName like ?";
			pst = con.prepareStatement(sql);
			pst.setString(1,"%"+ name + "%");
		}

		ResultSet r = pst.executeQuery();
		Locale locale = new Locale("en","US");
		NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);
		out.println("<div class=\"tbl\">");
		out.println("<h1 style = \"margin-bottom:0;\">All Products</h1><table><tr><th>Product Name</th><th>Price</th></tr>");
		while(r.next()){
			String productId = r.getString(1);
			String productName = r.getString(2);
			Double productPrice = r.getDouble(3);
			
			out.println("<tr><td><a href=\"addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice+"\">Add to Cart</a></td><td><a href=\"product.jsp\">"+r.getString(2)+"</a></td><td>" + currFormat.format(r.getDouble(3))+ "</td></tr>");
            
		}
		out.println("</table>");
		out.println("</div>");
		out.println("<h2><a href=\"listprod.jsp\">All products</a></h2>");
		out.println("<h2><a href=\"showcart.jsp\">Shopping Cart</a></h2>");
		out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
	
		

		String sq = "select productName, sum(orderproduct.quantity) from orderproduct join product on product.productId = orderproduct.productId group by productName order by sum(orderproduct.quantity) desc;";
		PreparedStatement p = con.prepareStatement(sq);
		ResultSet r1 = p.executeQuery();
		out.println("<div style=\"text-align:center;width: 30%; margin: 50px auto 0 auto;opacity:1;\">Our Top Sale Items:</br></br><table border=1 style=\"margin: 0 0 0 17%;opacity:1;\"><tr><th>Product Name</th><th>Sale</th></tr>");
		int counter = 0;
		while(r1.next() && counter<5){
				out.println("<tr><td>"+r1.getString(1)+ "</td><td>" + r1.getInt(2) + "</td></tr>");
				counter++;
		}
		out.println("</table></div>");


//gets genre of last ordered by customer
		String currCustId = (String)session.getAttribute("authcid");

		sq = "select p.productId, p.categoryId from orderproduct op \n"+ 
		"join ordersummary os on op.orderId = os.orderID \n"+ 
		"join customer c on c.customerId = os.customerId \n"+
		"join product p on op.productId = p.productId \n"+
		"where c.customerId=?";

		PreparedStatement ps = con.prepareStatement(sq);
		ps.setString(1,currCustId);
		r = ps.executeQuery();
		if(r.next()){
			String pid = r.getString(1);
			String catid = r.getString(2);
	
			sq = "select productName from product join category on product.categoryId = category.categoryId where product.categoryId=? and product.productId != ?";
			ps = con.prepareStatement(sq);
			ps.setString(1,pid);
			ps.setInt(2, Integer.parseInt(catid));
			r = ps.executeQuery();
			out.println("<br><div class='rec'>Recommendation for you:<br><table border='1'>");
			while(r.next()){
			out.println("<tr><td>"+r.getString(1)+"</td></tr>");
			}
			out.println("</table></div>");
		}


       
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