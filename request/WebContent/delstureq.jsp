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
		
<h2>Delete Student Request</h2>
	
		<%
			try {		
				
				int ind = Integer.parseInt(request.getParameter("index"));
				int sruid = (Integer) session.getAttribute("ruid");

				java.sql.Connection con;			
				Statement stmt;			
				//ResultSet rs;
				int rs = 0;

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				try {
					rs = stmt.executeUpdate("delete from request where ind='"+ind+"' AND sruid='"+sruid+"'");
				}  catch (Exception e) {
					%> Error in deleting request. Make sure the index# is correct.<br>Please return to the <a href="student.jsp"><b>Student Page</b></a> to continue. <%
				}
				
				if(rs>0) {
                	%> Deleting Request Successful. Please return to the <a href="student.jsp"><b>Student Page</b></a> to continue. <%
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