<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <center><h2>Update Product</h2></center>
    <style>
        body{
            margin: 0 auto 0 auto;
            background-color:#fff9d4; 
            width:70%;
		}
        table{
            text-align: center;
            margin: 0 auto 0 auto;
        }
        
    </style>
</head>

<body>

    
<%

        String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
        String uid = "SA";
        String pw = "YourStrong@Passw0rd";
        
        try(Connection con = DriverManager.getConnection(url, uid, pw)){

            if(request.getParameter("Delete")!=null){
                String prodId = request.getParameter("prodId");
                String sql = "delete from product where productId = ?";
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1,prodId);
                int key = pstmt.executeUpdate();
                out.println("</br><center><h2>Product Deleted!</h2></center>");
            }
            else if(request.getParameter("prodId")!=null){
                String prodId = request.getParameter("prodId");
                String prodName = request.getParameter("prodName");
                Double price = Double.parseDouble(request.getParameter("price"));
                String imgurl = request.getParameter("imgurl");
                String desc = request.getParameter("description");
                int ctgid = Integer.parseInt(request.getParameter("ctgid"));
                
                String sql = "update product set productName=?, productPrice=?, productImageURL=?, productDesc=?, categoryId=? where productId = ?";
                PreparedStatement pstmt = con.prepareStatement(sql);
                
                pstmt.setString(1,prodName);
                pstmt.setDouble(2,price);
                pstmt.setString(3,imgurl);
                pstmt.setString(4,desc);
                pstmt.setInt(5,ctgid);
                pstmt.setString(6,prodId);
                pstmt.executeUpdate();
                out.println("</br><center><h2>Successfully Updated!</h2></center>");
                
            }
            String sql = "select * from product";
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rst = pstmt.executeQuery();
            out.println("<table border='1'>");
            while(rst.next()){
                out.println("<tr><td><form name='updateProduct"+rst.getInt(1)+"' action='updateProduct.jsp' method='get'>");
                out.println("<div>");
                out.println("<table border='1'><tr style='display:none;'><td>Product ID:</td><td><input type='text' name='prodId' value='"+rst.getInt(1)+"'/></td></tr></br>");
                out.println("<tr><td>Name:</td><td><input type='text' name='prodName' value='"+rst.getString(2)+"'/></td></tr></br>");
                out.println("<tr><td>Price:</td><td><input type='text' name='price' value='"+rst.getDouble(3)+"'/></td></tr></br>");
                out.println("<tr><td>Image URL:</td><td><input type='text' name='imgurl' value='"+rst.getString(4)+"'/></td></tr></br>");
                out.println("<tr><td>Description:</td><td><input type='text' name='description' value='"+rst.getString(6)+"'/></td></tr></br>");
                out.println("<tr><td>Category ID:</td><td><input type='text' name='ctgid' value='"+rst.getString(7)+"'/></td></tr>");
                out.println("</br></table><input type='submit' value='Submit'><input type = 'submit' name = 'Delete' value = 'Delete'/></div></form></td></tr>");
                 
            }
            out.println("</table>");




             
       

        }
        catch(Exception e){
            out.println(e);
        }
           
    
    
    
    
%>

</body>
</html>