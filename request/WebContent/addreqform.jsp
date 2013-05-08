<%@ page language="java" import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title>My JSP 'index.jsp' starting page</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	</head>

	<body>
		
<h2>New SPN Request</h2>

	<form name="form" method="post" action="addreq.jsp">
	<table>
		<tr><td>Course Index#:</td><td><input type="text" name="ind"></td></tr>
		<tr><td>Is this course required for your major?:</td><td><input type="checkbox" name="required" value="true"></td></tr>
		<tr><td>Comments:</td><td><textarea name="comments" rows="5" cols="40"></textarea></td></tr>
		<tr><td></td><td><input type="submit" value="Submit"></td></tr>
	</table>
	</form>
	
	
		<%
		String msg=request.getParameter("msg");
		if(msg!=null){
    	%>
			<label><font color="red"><%=msg%></font></label> 
		<%
		}
   		%>
   		
	</body>
</html>
		