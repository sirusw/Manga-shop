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
		
	</style>
<center><title>My order</title></center>
</head>
<body>
    <%
    if((String)session.getAttribute("authcid")!=null){
        String custId = (String)session.getAttribute("authcid");
        String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
        String uid = "SA";
        String pw = "YourStrong@Passw0rd";

        Locale locale = new Locale("en","US");
        NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);

        try(Connection con = DriverManager.getConnection(url, uid, pw)){
            String sql = "select orderId, orderDate, firstname, lastname, totalAmount\n " + 
            "from ordersummary join customer on ordersummary.customerId = customer.customerId\n " + 
            "where ordersummary.customerId=? \n"+
            "order by orderId asc";
            String subsql = "select productId, quantity, price from orderproduct where orderId = ?";
            
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, custId);
            ResultSet rst = pstmt.executeQuery();
            out.println("<table class = \"out-table\" border = \"1\" style=\"margin: 0 auto 0 auto;\"><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
            boolean hasOrder = false;
            while(rst.next()){                          //in every order
                String orderId = rst.getString(1);
                hasOrder = true;

                out.println("</br><tr style=\"background-color:#c9c4c3\"><td>" + rst.getString(1) + "</td><td>" + rst.getString(2) + "</td><td>" + custId + "</td><td>" + rst.getString(3) + " " + rst.getString(4) + "</td><td>" + currFormat.format(rst.getDouble(5))+ "</td></tr>");
		
                pstmt = con.prepareStatement(subsql);
                pstmt.setString(1, orderId);
                
                ResultSet rst2 = pstmt.executeQuery();
                out.println("<tr style=\"height:10px;align:right;background-color:#e6e2e1\"><td></td><td></td><td></td><td></td><td height=\"5px\"><table border = \"1\" style=\"width:100%;border-collapse:collapse;margin-top:0;overflow:scroll;\"><tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");
                while(rst2.next()){
                    out.println("<br><tr><td>"+ rst2.getString(1)+ "</td><td>" + rst2.getInt(2) + "</td><td>" + currFormat.format(rst2.getDouble(3)) + "</td></tr>");
                }
                out.println("</table></td></tr>");
                
            }
            out.println("</table>");
            
            if(!hasOrder){
                out.println("<center><h2>No order found!</h2></center>");
            }
        
        }
        catch(Exception e){out.println(e);}
    }
    else{
        out.println("<center><h2>Not Logged In!</h2></center>");
    }
    

    %>



</body>
</html> 