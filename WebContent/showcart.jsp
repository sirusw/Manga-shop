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
				background-color:#fff9d4; 
				width:70%;
				margin: 0 auto 0 auto;
		}
		table{
			margin: 0 auto 0 auto;
		}
	</style>
<center><title>Your Shopping Cart</title></center>
</head>
<body>
<form name="input" action="addcart.jsp">
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");


if(request.getParameter("clear")==null){}
else if(request.getParameter("clear").equals("1")) {productList.clear();}
if (productList == null || productList.isEmpty())
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	Locale locale = new Locale("en","US");
	NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);

	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<table border=\"1\"><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th><th colspan=\"2\"></th></tr>");

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
		
		out.print("<form action=\"addcart.jsp\" method = \"get\"><tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");
		
		out.print("<td align=\"center\">"+"<input type=\"text\" name=\"qt\" size=\"3\" value=\""+product.get(3)+"\">"+"</td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		String strqty="";
		
		//if((newQty!="" || newQty != null) && !itemqty.toString().equals(newQty)) strqty = newQty;
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
			
			if(strqty == "" || strqty == null) qty = Integer.parseInt(itemqty.toString());
			else qty = Integer.parseInt(strqty);
			
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		
		out.println("<input style = \"display:none;\" type=\"text\" name = \"prodId\" value=\"" + product.get(0) + "\">");
		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td><td><input type=\"submit\" value=\"Update Quantity\"></td></form><td><a href=\"addcart.jsp?delete=" + product.get(0) + "\">Delete</a></td></tr>");
		out.println("<input style = \"display:none;\" type=\"text\" name = \"prodId\" value=\"" + product.get(0) + "\">");
		out.println("</tr>");
		total = total +pr*qty;
	}
	out.println("<tr><td colspan=\"4\" align=\"center\"><b>Order Total</b></td>"
			+"<td align=\"center\" colspan=\"3\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");
	out.println("<h2 style=\"text-align:center\"><a href=\"showcart.jsp?clear=1\">Empty Cart</a></h2>");
	out.println("<h2 style=\"text-align:center\"><a href=\"checkout.jsp\">Check Out</a></h2>");
}
%>
<h2 style="text-align:center"><a href="listprod.jsp">Continue Shopping</a></h2>

</form>
</body>
</html> 

