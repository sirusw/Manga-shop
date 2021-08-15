<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>  
<%@ page import="java.time.LocalDateTime" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>MANGAdealer - Product Information</title>
<style>

    body{
    background-color:#fff9d4; 
    width:70%;
    margin: 0 auto 0 auto;
    }
    table,img,h2{
        margin: 0 auto 0 auto;
        text-align: center;
    }
    img{
            width:  175px;
            height: 250px;
            object-fit: cover;
    }

	
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<%

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";




// Get product name to search for

String pName = request.getParameter("name");
// TODO: Retrieve and display info for the product
try(Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement())
{
    boolean reviewReq = false;
    boolean loggedIn = false;
    boolean dupliRev = false;
    String review = "";
    int rate = -1;
    if(session.getAttribute("authcid")!=null){
        loggedIn = true;
    }
    if(request.getParameter("review")!=null && request.getParameter("rate")!=null){
        if(session.getAttribute("authcid")!=null){
            loggedIn = true;
            String currCust = session.getAttribute("authcid").toString();
            String checkDupli = "select * from review where productId = ? and customerId = ?";
            PreparedStatement pst = con.prepareStatement(checkDupli);
            pst.setString(1,request.getParameter("id"));
            pst.setString(2,currCust);
            ResultSet rst = pst.executeQuery();
            if(rst.next())dupliRev = true;

            else{

                String checkPurchase = "select * from orderproduct join ordersummary on orderproduct.orderId=ordersummary.orderId where productId=? and customerId = ?";
                pst = con.prepareStatement(checkPurchase);
                pst.setString(1,request.getParameter("id"));
                pst.setString(2,currCust);
                rst = pst.executeQuery();
                if(rst.next()){
                    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                    LocalDateTime now = LocalDateTime.now();
                    String timeStr = fmt.format(now);
                    java.sql.Timestamp sqldate = java.sql.Timestamp.valueOf(timeStr);
    
                    review = request.getParameter("review");
                    rate = Integer.parseInt(request.getParameter("rate"));
                    String updateRev = "insert into review(reviewRating, reviewDate, customerId, productId, reviewComment) values(?,?,?,?,?)";
                    pst = con.prepareStatement(updateRev);
                    pst.setInt(1,rate);
                    pst.setObject(2,sqldate);
                    pst.setString(3,currCust);
                    pst.setString(4,request.getParameter("id"));
                    pst.setString(5,review);
                    int key = pst.executeUpdate();
                    reviewReq = true;
                }


            }


        }
        
        
    }

    String sql = "SELECT productId, productName, productPrice, productImageURL,productImage from product where productName like ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, "%"+pName+"%");
    ResultSet rst = pstmt.executeQuery();
    String productId = null;
    String productName = null;
    Double productPrice = -1.0;
    while(rst.next()){
        productId = rst.getString(1);
        productName = rst.getString(2);
        productPrice = rst.getDouble(3);
        out.println("<table><tr><th>Product ID: "+productId+ "</th></tr>");
        out.println("<tr><th>Product Name: "+productName+"</th></tr>");
        out.println("<tr><th>Price "+productPrice+"</th></tr></table>");
    
        // String productId = request.getParameter("id");

         // TODO: If there is a productImageURL, display using IMG tag
        String pImageURL = rst.getString(4);
       
        if (pImageURL != null ){
            out.println("<center><img src=\""+pImageURL+"\"/></center></br>");
        }
        if(rst.getObject(5)!=null){
            out.println("<center><img src=\"displayImage.jsp?id=" + productId +"\"/></center></br>");
            
        }
        
    }   
    // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.

    //out.println(request.getParameter("id").displayImage.jsp);

    // DONE: Add links to Add to Cart and Continue Shopping
    
    out.println("<h2><a href=\"addcart.jsp?id=" + request.getParameter("id") + "&name=" + request.getParameter("name") + "&price=" + request.getParameter("price")+"\">Add to Cart</a></h2></br>");
    out.println("<h2><a href=\"listprod.jsp\">Continue Shopping</a></h2>");
    out.println("<center></br><b>Review:</b></center></br>");
    
    sql = "select firstName, reviewRating, reviewDate, reviewComment from review join customer on review.customerId = customer.customerId where productId=?";
    pstmt = con.prepareStatement(sql);
    pstmt.setString(1,productId);
    rst = pstmt.executeQuery();
    out.println("<table border='1'><tr><th>Customer Name</th><th>Rating</th><th>Date</th><th>Comment</th></tr>");
    boolean hasReview = false;
    while(rst.next()){
        hasReview = true;
        out.println("<tr><td>"+rst.getString(1)+"</td><td>"+rst.getInt(2)+"/5</td><td>"+rst.getObject(3)+"</td><td>"+rst.getString(4)+"</td></tr>");
    }
    out.println("</table>");
    if(!hasReview)out.println("</br><center>No review for this product!</center>");
    out.println("<center></br>Enter your review:</center>");
    out.println("</br><form method='get' action = 'product.jsp'><input style = 'display:none' name='id' value='"+productId+"'><input style = 'display:none' name='name' value='"+productName+"'><input style = 'display:none' name='price' value='"+productPrice+"'><center>Rate(1-5):</center></br><center><input type='range' name='rate' min='1' max='5'/></center></br><input type='text' name='review' style='height:200px; width:500px;margin:0 auto 0 24%'/></br></br><center><input type='submit'/></center></form>");

    if(!loggedIn)out.println("<center>Please log in!</center>");
    else if(!reviewReq)out.println("<center>Please do not leave any field blank!</center>");
    else if(dupliRev)out.println("<center>You have already written a review!</center>");
    else out.println("<center>Success!</center>");

    if(session.getAttribute("admin").equals("1")){
        if(request.getParameter("prodId")!=null){
            String prodId = request.getParameter("prodId");
            String wareId = request.getParameter("wareId");
            int qty = Integer.parseInt(request.getParameter("qty"));
            double price = Double.parseDouble(request.getParameter("price"));

            String updateInv = "update productinventory set warehouseId = ?, quantity = ?, price = ? where productId = ?";
            PreparedStatement pstm = con.prepareStatement(updateInv);
            pstm.setString(1,wareId);
            pstm.setInt(2,qty);
            pstm.setDouble(3,price);
            pstm.setString(4,prodId);
            int key = pstm.executeUpdate();
            out.println("<center>Updated!</center>");
        }
        String getInv = "select * from productinventory where productId = ?";
        PreparedStatement pst = con.prepareStatement(getInv);
        pst.setString(1,request.getParameter("id"));
      
        ResultSet rs = pst.executeQuery();
        out.println("</br><center><h2>Admin access</h2></center>");
        out.println("<table border='1' width='60%'><tr><th>Product ID</th><th>Warehouse ID</th><th>Quantity</th><th>Price</th><th></th></tr>");
        while(rs.next()){
            out.println("<center><form><input style = 'display:none'type='text' name='id' value='"+request.getParameter("id")+"'/><input style = 'display:none'type='text' name='name' value='"+request.getParameter("name")+"'/><input style = 'display:none'type='text' name='price' value='"+request.getParameter("price")+"'/><input style = 'display:none;' type='text' name='prodId' value='"+rs.getString(1)+"'/><tr><td>"+rs.getString(1)+"</td><td><input type='text' name='wareId' value='"+rs.getString(2)+"'/></td><td><input type='text' name = 'qty' value='"+rs.getInt(3)+"'/></td><td><input type='text' name='price' value='"+rs.getDouble(4)+"'/></td><td><input type='submit' value='submit'/></td></tr></form></center>");
        }
        out.println("</table>");
    }




}
    catch(Exception e){
		
	}

%>

</body>
</html>

