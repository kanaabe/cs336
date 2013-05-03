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
		
<h2>Admin Page</h2>
		
	<form name="input" method="post" action="logout.jsp">
		<input type="submit" value="Logout" />
	</form>

		<br>
		Here are all people currently registered. *Can show more info if needed*
		<br>
		<%
			try {				
				java.sql.Connection con;			
				Statement stmt;			
				ResultSet rs;			

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				//Instructors
				rs = stmt.executeQuery("SELECT name,iruid,password	 from instructor");
				
				out.println("<br>Instructors");
				out.println("<table border=1 width=400>");
				out.println("<tr><td>    Name"  + "</td><td>    RUID"  + "</td><td>    Password"  + "</td></tr>");
				while (rs.next()) {
					String name = rs.getString(1);
					int iruid = rs.getInt(2);
					String pass = rs.getString(3);
					out.println("<tr><td>" + name + "</td><td>" + iruid + "</td><td>" + pass + "</td></tr>");
				} 
				out.println("</table>");
				
				//Students
				rs = stmt.executeQuery("SELECT name,sruid,password	 from student");
				
				out.println("<br>Students");
				out.println("<table border=1 width=400>");
				out.println("<tr><td>    Name"  + "</td><td>    RUID"  + "</td><td>    Password"  + "</td></tr>");
				while (rs.next()) {
					String name = rs.getString(1);
					int sruid = rs.getInt(2);
					String pass = rs.getString(3);
					out.println("<tr><td>" + name + "</td><td>" + sruid + "</td><td>" + pass + "</td></tr>");
				} 
				out.println("</table>");
				
				//Courses
				rs = stmt.executeQuery("SELECT title,cid,deptNum	 from Course");
				
				out.println("<br>Current Courses");
				out.println("<table border=1 width=400>");
				out.println("<tr><td>    Course Name"  + "</td><td>    CID"  + "</td><td>    Department#"  + "</td></tr>");
				while (rs.next()) {
					String title = rs.getString(1);
					int cid = rs.getInt(2);
					int dept = rs.getInt(3);
					out.println("<tr><td>" + title + "</td><td>" + cid + "</td><td>" + dept + "</td></tr>");
				} 
				out.println("</table>");
				
				rs.close();
				stmt.close();
				con.close();
			} catch (Exception e) {
				out.println(e.getMessage());
			}
		%>
   		
	</body>
</html>