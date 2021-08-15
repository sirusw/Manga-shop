<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
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
    </head>
    <body>
<% 
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
    String pw = request.getParameter("pw");

    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pass = "YourStrong@Passw0rd";

try(Connection con = DriverManager.getConnection(url, uid, pass)){
    String sq = "select * from customer where userid = ?";
    PreparedStatement pstm = con.prepareStatement(sq);
    pstm.setString(1,uname);
    ResultSet rst = pstm.executeQuery();
    if(!rst.next()){
        String sql = "insert into customer(firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password, admin) values(?,?,?,?,?,?,?,?,?,?,?,?)";
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
        pstmt.setString(11,pw);
        pstmt.setString(12,"false");
        pstmt.executeUpdate();
        out.println("<h2 style=\"margin:30% auto 0 30%;\">Successfully registered!</h2>");
        out.println("</br><center><a href=\"login.jsp\">Log In</a></center>");
    }
    else{
        out.println("<h2 style=\"margin:30% auto 0 30%;\">This username is already taken!</h2>");
        out.println("</br><center><a href=\"register.jsp\">Try again</a></center>");
    }
    
}
catch(Exception e){
    
}
%>
    </body>
</html>
