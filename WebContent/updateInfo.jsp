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
        
    </style>
</head>

<body>
<%
    if((String)session.getAttribute("authcid")!=null){
        String custId = (String)session.getAttribute("authcid");
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

        String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
        String uid = "SA";
        String pw = "YourStrong@Passw0rd";
        
        try(Connection con = DriverManager.getConnection(url, uid, pw)){
            
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
            out.println("</br></br></br></br></br></br></br></br></br></br><center><h2>Successfully Updated!</h2></center>");
            out.println("</br><center><a href=\"myaccount.jsp\">My account</a></center>");
                
        }
        catch(Exception e){
        
        }
           
    
    }
    
    
%>

</body>
</html>