<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
	<style>
		body{
				background-color:#fff9d4; 
				width:70%;
				margin: 18% auto auto auto;

		}
		.register{
			text-align: center;
		}
	</style>
</head>
<body>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please Login to System</h3>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
if (session.getAttribute("authenticatedUser")!=null)
	out.println("<p>You are already logged in!</p><center><a href=\"index.jsp\">Return to main page</a></center>");
	
%>

<br>
<form name="MyForm" method=post action="validateLogin.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=10 maxlength="10"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Log In">
</form>

</div>
<div class="register">
	<p>Don't have an account? Register <a href="register.jsp">here</a></p>
</div>

</body>
</html>

