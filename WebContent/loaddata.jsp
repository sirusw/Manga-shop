<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Load Data</title>
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
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

out.print("<center><h1>Connecting to database</h1></center><br><br>");

Connection con = DriverManager.getConnection(url, uid, pw);
        
String fileName = "/usr/local/tomcat/webapps/shop/orderdb_sql.ddl";

try
{
    // Create statement
    Statement stmt = con.createStatement();
    
    Scanner scanner = new Scanner(new File(fileName));
    // Read commands separated by ;
    scanner.useDelimiter(";");
    while (scanner.hasNext())
    {
        String command = scanner.next();
        if (command.trim().equals(""))
            continue;
        // out.print(command);        // Uncomment if want to see commands executed
        try
        {
            stmt.execute(command);
        }
        catch (Exception e)
        {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
            out.print(e);
        }
    }	 
    scanner.close();
    
    out.print("<br><br><center><h1>Database loaded</h1></center>");
}
catch (Exception e)
{
    out.print(e);
}  
%>
</body>
</html> 
