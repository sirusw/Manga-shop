<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>MANGAdealer Shipment Processing</title>
<style>
	    body{
            background-color:#fff9d4; 
            width:70%;
            margin: 0 auto 0 auto;
    }
</style>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
	String orderId = session.getAttribute("orderId").toString(); 
	//out.println("orderid: " + orderId);
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";
	
    try(Connection con = DriverManager.getConnection(url, uid, pw);){

// NEED FIX

		String sql = "select orderId from orderproduct";
		PreparedStatement pstmt = con.prepareStatement(sql);
		ResultSet rst = pstmt.executeQuery();
		boolean valid = false;
		try{
			while(rst.next()){
				if(rst.getString(1).equals(orderId)) {
					valid = true;
					break;
				}
			}
		}catch(Exception e){out.println("0");}
		
		if(!valid){
			out.println("The order ID doesn't exist! Please try order again!");
			throw new Exception();
		}
		else{
			con.setAutoCommit(false);
			
			
			pstmt = con.prepareStatement("select productId, quantity from orderproduct where orderId = ?");
			pstmt.setString(1,orderId);
			
			rst = pstmt.executeQuery();
			Savepoint savePoint = con.setSavepoint();
			ResultSet rst1 = null;
			String productId = "";
			int quantity = -1;
			boolean shipped=true;
			while(rst.next()){							// for each product in order
				
				productId = rst.getString(1);				// get productId
				//out.println("productid : " + productId);
				quantity = rst.getInt(2);					// get quantity
				pstmt = con.prepareStatement("select orderDate from ordersummary where orderId = ?");
				pstmt.setString(1,orderId);
				rst1 = pstmt.executeQuery();
				rst1.next();
				Object date = rst1.getObject(1);				// get date

// get key from pstmt.executeUpdate();

				pstmt = con.prepareStatement("select max(shipmentId) from shipment");
				int shipmentId = -1;
				rst1 = pstmt.executeQuery();
				if(!rst1.next())shipmentId=1;
				else {shipmentId = rst1.getInt(1)+1;}
				//out.println("<h1>"+shipmentId+"</h1>");

				//out.println("second check prodID: " + productId);

				pstmt = con.prepareStatement("select quantity from productInventory where warehouseId = 1 and productId = ?;");
				pstmt.setString(1,productId);
				ResultSet rst2 = pstmt.executeQuery();				// get quantity from warehouse 1 for the product
				
				if(rst2.next()){               // to the first row
					
					int oldQty = rst2.getInt(1);
				
					if(oldQty>=quantity){
	
						int newQty = rst2.getInt(1)-quantity;
						pstmt = con.prepareStatement("set identity_insert shipment on; insert into shipment(shipmentId, shipmentDate, warehouseId) values(?,?,1);");
						pstmt.setString(1,""+shipmentId);
						pstmt.setObject(2,date);
						pstmt.executeUpdate();
						//con.commit();
		
						pstmt = con.prepareStatement("update productinventory set quantity = ? where productId = ?");
						pstmt.setInt(1,newQty);
						pstmt.setString(2,productId);
						pstmt.executeUpdate();
						//con.commit();
						
						out.println("Ordered Product: " + productId + " Quantity: " + quantity + " Previous inventory: " + oldQty + " New inventory: " + newQty+"</br>");
						
					}
					else{
						shipped = false;
						Savepoint sp = savePoint;
						con.rollback();
						out.println("Shipment not done. Insufficient inventory for product ID: " + productId);
						
						break;
					}
					
				}
					else{
						shipped=false;
						Savepoint sp = savePoint;
						con.rollback();
						out.println("Shipment not done. Insufficient inventory for product ID: " + productId);
						
						break;
					}
					
										
				
				
				

			}
			if(shipped) out.println("Your order has been shipped!");
			
		}
		con.commit();
		con.setAutoCommit(true);
	}
	catch(Exception e){
		out.println(e);
	}
	   
	// TODO: Check if valid order id
	
	// TODO: Start a transaction (turn-off auto-commit)
	
	// TODO: Retrieve all items in order with given id
	// TODO: Create a new shipment record.
	// TODO: For each item verify sufficient quantity available in warehouse 1.
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	
	// TODO: Auto-commit should be turned back on
%>                       				

<h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>
