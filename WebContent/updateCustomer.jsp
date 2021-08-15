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
    <style>
        body{
            margin: 0 auto 0 auto;
            background-color:#fff9d4; 
            width:70%;
		}
        input{
            float:right;
        }
        
    </style>
</head>

<body>
<%
out.println("<center><h2>Update Customer</h2></center>");
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try(Connection con = DriverManager.getConnection(url, uid, pw)){
    if((String)request.getParameter("id")!=null){
        String custId = (String)request.getParameter("id");
        String fname = request.getParameter("fn");
        String lname = request.getParameter("ln");
        String email = request.getParameter("email");
        String tel = request.getParameter("tel");
        String addr = request.getParameter("addr");
        String city = request.getParameter("ct");
        String state = request.getParameter("st");
        String postal = request.getParameter("pc");
        String country = request.getParameter("ctr");
        String uname = request.getParameter("uname");
        String pass = request.getParameter("pw");
        
            
            String sql = "update customer set firstName=?, lastName=?, email=?, phonenum=?, address=?, city=?, state=?, postalCode=?, country=?, userid=?, password=? where customerId = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1,fname);
            pstmt.setString(2,lname);
            pstmt.setString(3,email);
            pstmt.setString(4,tel);
            pstmt.setString(5,addr);
            pstmt.setString(6,city);
            pstmt.setString(7,state);
            pstmt.setString(8,postal);
            pstmt.setString(9,country);
            pstmt.setString(10,uname);
            pstmt.setString(11,pass);
            pstmt.setString(12,custId);
            pstmt.executeUpdate();
            out.println("<center><h2>Successfully Updated!</h2></center>");

        
        
        }
        
        String s = "select * from customer";
        PreparedStatement p = con.prepareStatement(s);
        ResultSet rst = p.executeQuery();
        while(rst.next()){
            out.println("<form name='changeInfo' action='updateCustomer.jsp' method='get'>");
            out.println("<div style='width:30%'>");
            out.println("<input type='text' name = 'id' value='"+rst.getString(1)+"' style = 'display:none;'/>");
            out.println("First Name: <input type='text' name='fn' value='"+rst.getString(2)+"'/></input></br>");
            out.println("Last Name: <input type='text' name='ln' value='"+rst.getString(3)+"'/></br>");
            out.println("Email: <input type='email' name='email' value='"+rst.getString(4)+"'/></br>");
            out.println("Phone Number:<input type='tel' name='tel' value='"+rst.getString(5)+"'/></br>");
            out.println("Address: <input type='text' name='addr' value='"+rst.getString(6)+"'/></br>");
            out.println("City: <input type='text' name='ct' value='"+rst.getString(7)+"'/></br>");
            out.println("State: <input type='text' name='st' value='"+rst.getString(8)+"'/></br>");
            out.println("Postal Code<input type='text' name='pc' value='"+rst.getString(9)+"'/></br>");
            out.println("Country: <input type='text' name='ctr' value='"+rst.getString(10)+"'/></br>");
            out.println("<input style='display:none;' type='text' name='uname' value='"+rst.getString(11)+"'/>");
            out.println("Password:<input type='text' name='pw' value='"+rst.getString(12)+"'/></br></br>");  
            out.println("<input type='submit' name='Submit'></div></form></br></br>");      
        }



}
catch(Exception e){
    out.println(e);
}
    
           
    
    
    
    
%>

</body>
</html>