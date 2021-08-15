<%@ page import="java.util.*" %>
<%
    String date = new SimpleDateFormat("HH:mm:ss").format(Calendar.getInstance().getTime());
    out.println(date);
%>