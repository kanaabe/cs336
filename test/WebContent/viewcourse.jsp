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
		
<h2>View Course</h2>
		
	<form name="input" method="post" action="logout.jsp">
		<input type="submit" value="Logout" />
	</form>

<br>
	Students Requesting Special Permission Numbers:
	<% 
	try {
		
		String ruid = (String) session.getAttribute("ruid");
		
		java.sql.Connection con;			
		Statement stmt;			
		ResultSet rs;			

		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
		con = ds.getConnection();
		stmt = con.createStatement();
				
		rs = stmt.executeQuery("SELECT title,index,status	 from request");
		
		out.println("Table is not implemented yet.");
		out.println("<table border=1 width=400>");
		out.println("<tr><td>    Course Name" + "</td><td>    Index#" + "</td><td>    Status" + "</td></tr>");
		while (rs.next()) {
			String title = rs.getString(1);
			String index = rs.getString(2);
			String status = rs.getString(3);
			out.println("<tr><td>" + title + "</td><td>" + index + "</td><td>" + status + "</td></tr>");
		} 
		out.println("</table>");
		
		rs.close();
		stmt.close();
		con.close();
		
		
		
	} catch (Exception e) {
		out.println(e.getMessage());
	}
	
	%>
	
	<br>
	This is as far as I got.  Need to implement pages for these buttons.
	<form name="input" method="post" action="addcourseform.jsp">
	To add a SPN to this course: <input type="submit" value="Add Course" />
	</form>
	
	<form name="form" method="post" action="viewcourse.jsp">
	To view a students specific request (using index#): <input type="text" name="index"> <input type="submit" value="View Requests" />
	</form>
	
   		
	</body>
</html>