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
		
<h2>User Login</h2>

	<a href="regform.jsp"><b>Instructor Registration</b></a>
	<a href="regformstu.jsp"><b>Student Registration</b></a>
	<form name="form" method="post" action="login.jsp">
	<table>
		<tr><td>RUID:</td><td><input type="text" name="ruid"></td></tr>
		<tr><td>Password:</td><td><input type="password" name="pass"></td></tr>
		<tr><td></td><td><input type="submit" value="Login"></td></tr>
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