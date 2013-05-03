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
		<%
			try {				
				java.sql.Connection con;			
				Statement stmt;			
				ResultSet rs;			

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				rs = stmt.executeQuery("SELECT name,ruid	 from instructor,student");
				
				out.println("<table border=1 width=400>");
				out.println("<tr><td>    name"  + "</td><td>    ruid"  + "</td></tr>");
				while (rs.next()) {
					String name = rs.getString(1);
					String ruid = rs.getString(2);
					out.println("<tr><td>" + name + "</td><td>" + ruid+ "</td></tr>");
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