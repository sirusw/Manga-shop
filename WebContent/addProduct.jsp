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
   
    
</style>
</head>
<body>
    <div class='form'>
    <center><h2>Add New Product</h2></center>
    
        <form method='get' action='addProduct.jsp'>
            Name:<input type='text' name='name'/></br>
            Price: <input type='text' name='price'/></br>
            Image URL: <input type='text' name='url'/></br>
            Description: <input type='text' name='desc'/></br>
            Category ID: <input type='text' name='ctgid'/>
            </br><input type='submit'/>
        </form>
    </div>


<%

   
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";


    try(Connection con = DriverManager.getConnection(url, uid, pw)){
        if((request.getParameter("name")!=null || request.getParameter("name")!="") && (request.getParameter("price")!=null || request.getParameter("price")!="")){
            String name = request.getParameter("name");
            Double price = Double.parseDouble(request.getParameter("price"));
            String imgurl = request.getParameter("url");
            String bi = request.getParameter("bi");
            String desc = request.getParameter("desc");
            String ctgid = request.getParameter("ctgid");

            String sql = "insert into product(productName, productPrice, productImageURL, productDesc, categoryId) values(?,?,?,?,?)";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1,name);
            pstmt.setDouble(2,price);
            pstmt.setString(3,imgurl);
            pstmt.setString(4,desc);
            pstmt.setString(5,ctgid);
            int key = pstmt.executeUpdate();
            out.println("</br><center style='margin-left:35%;'>New Product Added!</center>");

        }


    
    }
    catch(Exception e){
        
    }


%>

</body>
</html>

