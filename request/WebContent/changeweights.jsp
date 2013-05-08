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
				int required = Integer.parseInt(request.getParameter("wrequire"));
				int gpa = Integer.parseInt(request.getParameter("wgpa"));
				int preqgrade = Integer.parseInt(request.getParameter("wpreqgrade"));
				int credits = Integer.parseInt(request.getParameter("wcredits"));
				int gradyear = Integer.parseInt(request.getParameter("wgradyear"));

				java.sql.Connection con;			
				Statement stmt;			
				//ResultSet rs;		

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				int rs = stmt.executeUpdate("update weights set required='"+required+"',gpa='"+gpa+"',preqgrade='"+preqgrade+"',credits='"+credits+"',gradyear='"+gradyear+"' where iruid='"+iruid+"'");				

		        if(rs>0) {
		        	%> Changing Weights Successful. Please return to the <a href="instructor.jsp"><b>Instructor</b></a> page to continue. <%
		      	} else {
		         	response.sendRedirect("weightsform.jsp?msg=Error when changing weights.  Please try again.");
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