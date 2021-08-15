<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
<title>MANGAdealer Order List</title>
<style>
h1{
	text-align: center;
	padding:0;
	margin:0;
}
.out-table {
  width: 80%;
  height: 100%;
  border-collapse: collapse;
  padding:"0"; border:"0";
  text-align: center;
  margin-left:10%;
  margin-right:10%;
}
td {
  border: 1px solid black;
  vertical-align: top;
  padding:0;margin:0;height:100%;
}
body{
	margin:0;
	height:100%;
}
html{
		background-color: #e5e6dc;
	}
	head, body{
		width: 80%;
		margin: 0 10% 0 10%;
		background-color: #f2f5d7;
	}

</style>
</head>
<body>

<h1>MANGAdealer Order List</h1>

<%

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

Locale locale = new Locale("en","US");
NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);


//Note: Forces loading of SQL Server driver
try(Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement())
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String sql = "select orderId, orderDate, ordersummary.customerId, firstname, lastname, totalAmount\n " + 
	"from ordersummary join customer on ordersummary.customerId = customer.customerId\n " + 
	"order by orderId asc";
	String subsql = "select productId, quantity, price from orderproduct where orderId = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	ResultSet rst = pstmt.executeQuery();
	ResultSet rst2;

	out.println("<table class = \"out-table\" border = \"1\" style=\"height:100%;margin-top:0;\"><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
	while(rst.next()){
		String oid = rst.getString(1);
		out.println("</br><tr style=\"background-color:#c9c4c3\"><td>" + rst.getString(1) + "</td><td>" + rst.getObject(2) + "</td><td>" + rst.getString(3) + "</td><td>" + rst.getString(4) + " " + rst.getString(5) + "</td><td>" + currFormat.format(rst.getDouble(6))+ "</td></tr>");
		
		pstmt = con.prepareStatement(subsql);
		pstmt.setString(1, oid);
		rst2 = pstmt.executeQuery();
		out.println("<tr style=\"height:10px;align:right;background-color:#e6e2e1\"><td></td><td></td><td></td><td></td><td height=\"5px\"><table border = \"1\" style=\"height:100%;width:100%;border-collapse:collapse;margin-top:0;overflow:scroll;\"><tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");
		while(rst2.next()){
			out.println("<br><tr><td>"+ rst2.getString(1)+ "</td><td>" + rst2.getInt(2) + "</td><td>" + currFormat.format(rst2.getDouble(3)) + "</td></tr>");
		}
		out.println("</table></td></tr>");
		
	}
	out.println("</table>");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>

</body>
</html>
