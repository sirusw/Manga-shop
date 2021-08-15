<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Add Product Page</title>
<style>
    body{
            background-color:#fff9d4; 
            width:70%;
            margin: 0 auto 0 auto;
    }
    form{
        text-align:center;
        
    }

    input{
        float:right;
    }
    .form{
        width: 30%;
        margin-left: 33%;
        margin-top: 27%;
    }
    table{
        text-align:center;
        margin: 0 auto 0 auto;
    }
   
    
</style>
</head>
<body>
  
<center><h2>Edit Item Inventory</h2></center>

<%

   
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";

    /////////////////////////////////////////
    // warehouseId         INT IDENTITY,   //
    // warehouseName       VARCHAR(30),    //    
    /////////////////////////////////////////

    try(Connection con = DriverManager.getConnection(url, uid, pw)){
        if(request.getParameter("update")!=null){
            String pid = request.getParameter("pid");
            int wareid = Integer.parseInt(request.getParameter("wareid"));
            int qty = Integer.parseInt(request.getParameter("qty"));
            Double price = Double.parseDouble(request.getParameter("price"));

            String sql = "update productinventory set quantity = ?, price = ? where productId = ? and warehouseId = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            
            pstmt.setInt(1,qty);
            pstmt.setDouble(2,price);
            pstmt.setString(3,pid);
            pstmt.setInt(4,wareid);
            int key = pstmt.executeUpdate();
            out.println("<br><center>Updated Successfully!</center>");
        }

        
        String sql = "select * from productinventory";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rst = pstmt.executeQuery();
        out.println("<table border='1'><tr><th>Product ID</th><th>Warehouse ID</th><th>Quantity</th><th>Price</th></tr>");
        while(rst.next()){
            out.println("<form method='get' action='addWare.jsp'><tr><td style = 'display:none;'><input type='text' name='pid' value='"+rst.getString(1)+"'/></td><td>"+rst.getString(1)+"</td><td style = 'display:none;'><input type='text' name='wareid' value='"+rst.getString(2)+"'/></td><td>"+rst.getString(2)+"</td><td><input type='text' name='qty' value='"+rst.getInt(3)+"'/></td><td><input type ='text' name='price' value='"+rst.getDouble(4)+"'/></td><td><center><input type='submit' name='update' value='update'/></center></td></tr></form>");
        }
        out.println("</table>");




    
    }
    catch(Exception e){
        out.println(e);
    }


%>

</body>
</html>

