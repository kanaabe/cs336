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
		
<h2>Add Course</h2>
	
		<%
			try {		
				
				String name = request.getParameter("name");
				String ruid = request.getParameter("ruid");
				String netid = request.getParameter("netid");
				String email = request.getParameter("email");
				String pass = request.getParameter("pass");

				java.sql.Connection con;			
				Statement stmt;			
				//ResultSet rs;		

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				int rs = stmt.executeUpdate("insert into instructor set name='"+name+"',ruid='"+ruid+"',netid='"+netid+"',email='"+email+"',password='"+pass+"'");
				
                if(rs>0) {
                	%> Adding Course Successful. Please return to the <a href="Instructor.jsp"><b>Instructor</b></a> page to continue. <%
      			} else {
              		response.sendRedirect("addcourseform.jsp?msg=Registration Failed.  Please try again.");
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