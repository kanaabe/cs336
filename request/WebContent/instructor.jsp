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
		
		int iruid = (Integer) session.getAttribute("ruid");
		
		java.sql.Connection con;			
		Statement stmt;			
		ResultSet rs;

		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
		con = ds.getConnection();
		stmt = con.createStatement();
				
		rs = stmt.executeQuery("SELECT ind,cid,semester,year	 from courseOffering where iruid='"+iruid+"'");
		
		out.println("<table border=1>");
		out.println("<tr><td>    Course Name" + "</td><td>    Index#" + "</td><td>    # of Requests" + "</td><td>    Semester" + "</td><td>    Year" + "</td><td>    View Requests" + "</td><td>    Delete Course Offering" + "</td></tr>");
		while (rs.next()) {
			int ind = rs.getInt(1);
			int cid = rs.getInt(2);
			String semester = rs.getString(3);
			int year = rs.getInt(4);			
			
			Statement stmt2 = con.createStatement();
			ResultSet rs2;
			rs2 = stmt2.executeQuery("SELECT title	 from course where cid='"+cid+"'");
			rs2.next();
			String title = rs2.getString(1);
			rs2 = stmt2.executeQuery("SELECT count(*)	 from request where iruid='"+iruid+"' and ind='"+ind+"'");
			rs2.next();
			int numreq = rs2.getInt(1);	
			
			rs2.close();
			stmt2.close();
			
			out.println("<tr><td>" + title + "</td><td>" + ind + "</td><td>" + numreq + "</td><td>" + semester + "</td><td>" + year + "</td><td>" +
					"<form name=\"form\" method=\"post\" action=\"viewcourse.jsp\"><input type=\"hidden\" value=\"" + ind + "\" name=\"index\"><input type=\"submit\" value=\"View\" /></form>" + "</td><td>" +
					"<form name=\"form\" method=\"post\" action=\"delcourse.jsp\"><input type=\"hidden\" value=\"" + ind + "\" name=\"index\"><input type=\"submit\" value=\"Delete\" /></form>"
					+ "</td></tr>");
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
	<form name="input" method="post" action="weightsform.jsp">
	To customize the weights for calculating priority: <input type="submit" value="Customize Weights" />
	</form>
	
	<form name="input" method="post" action="addcourseform.jsp">
	To add a course: <input type="submit" value="Add Course" />
	</form>
	
	<form name="input" method="post" action="addofferingform.jsp">
	To add a course offering: <input type="submit" value="Add Course Offering" />
	</form>
	
	<form name="input" method="post" action="addprereq.jsp">
	To add a course prerequisite:<br>
	Make (Course ID) <input type="text" name="pid"> a prerequisite to (Course ID) <input type="text" name="cid"><br>
	<input type="submit" value="Assign Prerequisite" />
	</form>
   		
	</body>
</html>