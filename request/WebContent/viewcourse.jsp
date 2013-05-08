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
	
	<% 
	try {
		int ind = Integer.parseInt(request.getParameter("index"));
		int iruid = (Integer) session.getAttribute("ruid");
		
		%>
		<form name="input" method="post" action="addspn.jsp">
		To add a SPN to this course: <input type="text" name="spn">
		
		<% out.println("<input type=\"hidden\" value=" + ind + " name=\"index\">"); %>
		
		<input type="submit" value="Add SPN" />
		</form>	
		<%
		
		java.sql.Connection con;			
		Statement stmt;			
		ResultSet rs;			

		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
		con = ds.getConnection();
		stmt = con.createStatement();
		
		rs = stmt.executeQuery("SELECT count(*)	 from spn where iruid='"+iruid+"' and ind='"+ind+"'");
		rs.next();
		int total = rs.getInt(1);
		out.println("Total Available SPN's: " + total +"<br>");
		
		rs = stmt.executeQuery("SELECT sruid,status,priority,timestamp	 from request where ind='"+ind+"' AND iruid='"+iruid+"'");
		out.println("Students Requesting Special Permission Numbers:");
		out.println("<table border=1>");
		out.println("<tr><td>    Student Name" + "</td><td>    RUID#" + "</td><td>    Status" + "</td><td>    Priority" +"</td><td>    Timestamp" + "</td><td>    View Student Request" + "</td></tr>");
		while (rs.next()) {
			int sruid = rs.getInt(1);
			String status = rs.getString(2);
			int priority = rs.getInt(3);
			Timestamp timestamp = rs.getTimestamp(4);
			
			Statement stmt2 = con.createStatement();
			ResultSet rs2;
			rs2 = stmt2.executeQuery("SELECT name	 from student where sruid='"+sruid+"'");
			rs2.next();
			String name = rs2.getString(1);
				
			rs2.close();
			stmt2.close();
			out.println("<tr><td>" + name + "</td><td>" + sruid + "</td><td>" + status + "</td><td>" + priority + "</td><td>" + timestamp + "</td><td>" +
					"<form name=\"form\" method=\"post\" action=\"viewrequest.jsp\"><input type=\"hidden\" value=\"" + ind + "\" name=\"index\"><input type=\"hidden\" value=\"" + sruid + "\" name=\"sruid\"><input type=\"submit\" value=\"View Request\" /></form>"
					+ "</td></tr>");
		} 
		out.println("</table>");
		
		rs.close();
		stmt.close();
		con.close();
		
		%>
		<br>
		Send Email to All Students:
		<br>
		<form name="form" method="post" action="sendemail.jsp">
		Subject:<input type="text" name="subject"><br>
		Message:<textarea name="message" rows="5" cols="40"></textarea><br>
		<%
			out.println("<input type=\"hidden\" value=" + ind + " name=\"index\">");
		%>
		<input type="submit" value="Send Email">
		</form>
		<%
		
		
		
	} catch (Exception e) {
		out.println(e.getMessage());
	}
	
	%>
	 
	   		
	</body>
</html>