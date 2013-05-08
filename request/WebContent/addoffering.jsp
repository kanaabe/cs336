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
		
<h2>Add Course Offering</h2>
	
		<%
			try {		
				int iruid = (Integer) session.getAttribute("ruid");
				int cid = Integer.parseInt(request.getParameter("cid"));
				int ind = Integer.parseInt(request.getParameter("index"));
				int room = Integer.parseInt(request.getParameter("room"));
				int capacity = Integer.parseInt(request.getParameter("capacity"));
				String semester = request.getParameter("semester");
				int year = Integer.parseInt(request.getParameter("year"));


				java.sql.Connection con;			
				Statement stmt;			
				//ResultSet rs;		

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				int rs = stmt.executeUpdate("insert into courseOffering set iruid='"+iruid+"',cid='"+cid+"',room='"+room+"',capacity='"+capacity+"',enrolled='"+0+"',ind='"+ind+"',semester='"+semester+"',year='"+year+"'");				

		        if(rs>0) {
		        	%> Add Course Offering Successful. Please return to the <a href="instructor.jsp"><b>Instructor</b></a> page to continue. <%
		      	} else {
		         	response.sendRedirect("addofferingform.jsp?msg=Course Offering could not be added.  Please try again.");
		      	}																				
				
				//rs.close();
				stmt.close();
				con.close();
				
			} catch (Exception e) {
				out.println(e.getMessage());
			}
		%>
		
	</body>
</html>