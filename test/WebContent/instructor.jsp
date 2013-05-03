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
		
<h2>Welcome Instructor</h2>
		
	<form name="input" method="post" action="logout.jsp">
		<input type="submit" value="Logout" />
	</form>

<br>
	Your Current Courses:
	<% 
	try {
		
		int ruid = (Integer) session.getAttribute("ruid");
		
		java.sql.Connection con;			
		Statement stmt;			
		ResultSet rs;		

		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
		con = ds.getConnection();
		stmt = con.createStatement();
				
		rs = stmt.executeQuery("SELECT ind,cid,semester,year	 from courseOffering where iruid='"+ruid+"'");
		
		out.println("<table border=1 width=400>");
		out.println("<tr><td>    Course Name" + "</td><td>    Index#" + "</td><td>    # of Requests" + "</td><td>    Semester" + "</td><td>    Year" + "</td></tr>");
		while (rs.next()) {
			int ind = rs.getInt(1);
			int cid = rs.getInt(2);
			String semester = rs.getString(3);
			int year = rs.getInt(4);			
			
			ResultSet rs2;
			rs2 = stmt.executeQuery("SELECT title	 from course where cid='"+cid+"'");
			String title = "Error: Default";
			while (rs2.next()) {
				title = rs2.getString(1);
			}
			rs2 = stmt.executeQuery("SELECT count(*)	 from requests where iruid='"+ruid+"' and ind='"+ind+"'");
			int numreq = 999;
			while (rs2.next()) {
				numreq = rs2.getInt(1);
			}
			rs2.close();
			
			out.println("<tr><td>" + title + "</td><td>" + ind + "</td><td>" + numreq + "</td><td>" + semester + "</td><td>" + year + "</td></tr>");
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
	<form name="input" method="post" action="addcourseform.jsp">
	To add a course: <input type="submit" value="Add Course" />
	</form>
	
	<form name="form" method="post" action="viewcourse.jsp">
	To view requests for a course (using index#): <input type="text" name="index"> <input type="submit" value="View Requests" />
	</form>
	
	<form name="form" method="post" action="delcourse.jsp">
	To delete a current course offering (using index#): <input type="text" name="index"> <input type="submit" value="Delete Course" />
	</form>
   		
	</body>
</html>