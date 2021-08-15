<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
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

// TODO: Write SQL query that prints out total order amount by day
//String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_swang;";
//String uid = "swang";
//String pw = "74248428";
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

Locale locale = new Locale("en","US");
NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);
try(Connection con = DriverManager.getConnection(url, uid, pw);){
    if(session.getAttribute("admin").equals("1")){

        // -----------------  Sales and Orders  ------------------- //
        String sql = "select convert(varchar(10),orderDate,111), sum(totalAmount) from ordersummary group by convert(varchar(10),orderDate,111);";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rst = pstmt.executeQuery();
        out.println("<center><h2>Total Sales and Orders</h2></center>");
        out.println("<table border=\"1\" style='margin:0 auto 0 auto;'><tr><th>Order Date</th><th>Total Amount</th></tr>");
        while(rst.next()){
            out.println("<tr><td>" + rst.getObject(1) + "</td><td>" + currFormat.format(rst.getDouble(2)) + "</td></tr>");
        }
        out.println("</table>");


        // -----------------  All Customers ------------------- //

        sql = "select customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, admin from customer";
        pstmt = con.prepareStatement(sql);
        rst = pstmt.executeQuery();
        out.println("<center><h2>Customer Info</h2></center>");
        out.println("<table border='1'><tr><th>ID</th><th>firstName</th><th>lastName</th><th>email</th><th>phonenum</th><th>address</th><th>city</th><th>state</th><th>postalCode</th><th>country</th><th> userid</th><th>admin</th></tr>");
        while(rst.next()){
            out.println("<tr><td>"+rst.getString(1)+"</td><td>"+rst.getString(2)+"</td><td>"+rst.getString(3)+"</td><td>"+rst.getString(4)+"</td><td>"+rst.getString(5)+"</td><td>"+rst.getString(6)+"</td><td>"+rst.getString(7)+"</td><td>"+rst.getString(8)+"</td><td>"+rst.getString(9)+"</td><td>"+rst.getString(10)+"</td><td>"+rst.getString(11)+"</td><td>"+rst.getString(12)+"</td></tr>");
        }
        out.println("</table>");

        // -----------------  Add product ------------------- //
        out.println("</br><center><a href='addProduct.jsp'>Add New Product</a></center>");
        out.println("</br><center><a href='updateProduct.jsp'>Update Product</a></center>");
        out.println("</br><center><a href='addWare.jsp'>Add/Update Inventory</a></center>");
        out.println("</br><center><a href='register.jsp'>Add Customer</a></center>");
        out.println("</br><center><a href='updateCustomer.jsp'>Update Customer</a></center>");
        out.println("</br><center><a href='loaddata.jsp' class='restore'>Restore Database</a></center>");
    }
    else out.println("<center><h2>No Access!</h2></center>");

    
   
}
catch(Exception e){
    out.println(e);
}


%>

</body>
</html>

