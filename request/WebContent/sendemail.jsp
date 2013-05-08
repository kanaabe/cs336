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
		
<h2>Send Email</h2>

	<%
			try {		
				
				int iruid = (Integer) session.getAttribute("ruid");
				int ind = Integer.parseInt(request.getParameter("index"));
				String message = request.getParameter("message");
				String subject = request.getParameter("subject");

				java.sql.Connection con;			
				Statement stmt;			
				ResultSet rs;		

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				rs = stmt.executeQuery("SELECT sruid	 from request where ind='"+ind+"' and iruid='"+iruid+"'");
				while(rs.next()) {
					int sruid = rs.getInt(1);
					
					Statement stmt2 = con.createStatement();
					ResultSet rs2;										
					rs2 = stmt2.executeQuery("SELECT email	 from student where sruid='"+sruid+"'");
					rs2.next();
					String email = rs2.getString(1);
					int rs3 = stmt2.executeUpdate("insert into email set email='"+email+"',sender='"+iruid+"',subject='"+subject+"',message='"+message+"'");
					rs2.close();
					stmt2.close();
				}															
				
				rs.close();
				stmt.close();
				con.close();
				
				response.sendRedirect("viewcourse.jsp?index="+ind);
				
			} catch (Exception e) {
				out.println(e.getMessage());
			}
		%>
		
	</body>
</html>