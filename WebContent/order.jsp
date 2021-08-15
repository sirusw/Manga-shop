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

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>MANGAdealer Order Processing</title>
<style>
	body{
    background-color:#fff9d4; 
    width:70%;
    margin: 0 auto 0 auto;
    }
</style>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
String password = request.getParameter("password");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");


// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message


String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try(Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement())
{
	if(custId==null || custId.equals("") || password == null || password.equals("")){
		out.println("<h2>Customer ID or password cannot be null!</h2><h2><a href=\"checkout.jsp\">Try again</a></h2>");
		throw new Exception();
	}
	if(productList==null || productList.isEmpty()){
		out.println("<h2>Your shopping cart seems empty, please add items to your shopping cart.</h2><h2><a href=\"index.jsp\">Back to Shopping</a></h2>");
		throw new Exception();
	}
	String sql = "select password from customer where customerId = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1,custId);
	ResultSet rst = pstmt.executeQuery();
	boolean valid = false;
	while(rst.next()){
		if(rst.getString(1).equals(password)){
			valid = true;
			break;
		}
	}

	if(!valid){
		out.println("<h2>Invalid customer ID or password!</h2><h2><a href=\"checkout.jsp\">Try again</a></h2>");
		throw new Exception();
	}
	
	else if(!productList.isEmpty()){
		Locale locale = new Locale("en","US");
		NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);

		out.println("<h1>Your Order Summary</h1>");
		out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
		out.println("<th>Price</th><th>Subtotal</th></tr>");

		double total =0;
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext()) 
		{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			if (product.size() < 4)
			{
				out.println("Expected product with four entries. Got: "+product);
				continue;
			}
			
			out.print("<tr><td>"+product.get(0)+"</td>");
			out.print("<td>"+product.get(1)+"</td>");

			out.print("<td align=\"center\">"+product.get(3)+"</td>");
			Object price = product.get(2);
			Object itemqty = product.get(3);
			double pr = 0;
			int qty = 0;
			
			try
			{
				pr = Double.parseDouble(price.toString());
			}
			catch (Exception e)
			{
				out.println("Invalid price for product: "+product.get(0)+" price: "+price);
			}
			try
			{
				qty = Integer.parseInt(itemqty.toString());
			}
			catch (Exception e)
			{
				out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
			}		

			out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
			out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
			out.println("</tr>");
			total = total +pr*qty;
		}

			out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
				+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
			out.println("</table>");
			
		
			DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			LocalDateTime now = LocalDateTime.now();
			String timeStr = fmt.format(now);  
			
			java.sql.Timestamp sqldate = java.sql.Timestamp.valueOf(timeStr);


			String input = "DECLARE @orderId int; INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?,?,?); SELECT @orderId = @@IDENTITY; ";

			out.println("<h2>Your order time is: " + timeStr + "</h2>");

			/*
			DECLARE @orderId int
			INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
			SELECT @orderId = @@IDENTITY
			INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
			INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
			INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);
			*/
			Iterator<Map.Entry<String, ArrayList<Object>>> it = productList.entrySet().iterator();
			while(it.hasNext()){
				Map.Entry<String, ArrayList<Object>> entry = it.next();
					input += "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, ?,?,?);";
			}
			pstmt = con.prepareStatement(input);
			pstmt.setString(1, custId);
			pstmt.setObject(2, sqldate);
			pstmt.setDouble(3, total);

		int count = 3;
		it = productList.entrySet().iterator();
		while (it.hasNext())
		{ 
			
			Map.Entry<String, ArrayList<Object>> entry = it.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
			
			//input += "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, "+productId+","+qty+","+pr + ");";
			pstmt.setString(++count,productId);
			pstmt.setInt(++count, qty);
			pstmt.setDouble(++count, pr);

		}

		
		pstmt.executeUpdate();

		out.println("<h2>Order completed. Will be shipped soon...</h2></br>");
		PreparedStatement pstmt1 = con.prepareStatement("select orderId from ordersummary order by orderId desc");
		ResultSet rst1 = pstmt1.executeQuery();
		rst1.next();
		int currOrderNum = rst1.getInt(1);
		out.println("Your reference number is " + Integer.toString(currOrderNum));
		out.println("Check out your shipping status <a href=\"ship.jsp\">here</a>");
		productList.clear();
		out.println("<h2><a href=\"index.jsp\">Back to Shopping</a></h2>");
		session.setAttribute("orderId",currOrderNum);     
	}
	else if(productList.isEmpty() || productList == null){
		out.println("<h2>Please do not refresh the order page.</h2></br><h2><a href=\"index.jsp\">Back to shopping</a></h2>");
	}
	


}
catch(Exception e){
	out.println(e);
}
// Make connection

// Save order information to database


	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/

// Insert each item into OrderProduct table using OrderId from previous INSERT

// Update total amount for order record

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price





// Print out order summary

// Clear cart if order placed successfully
%>
</BODY>
</HTML>

