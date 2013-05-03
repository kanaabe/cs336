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
		
<h2>User Login</h2>

		<%
			try {		
				
				String ruid = request.getParameter("ruid");
				String pass = request.getParameter("pass");
				
				if (ruid.equals("admin") && pass.equals("admin")) {
					response.sendRedirect("admin.jsp");
				}
				
				java.sql.Connection con;			
				Statement stmt;			
				ResultSet rs;			

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				rs = stmt.executeQuery("select * from instructor where ruid='"+ruid+"' and password='"+pass+"'");				
				int count=0;

				while (rs.next()) {
					count++;
				}
				
                if(count>0) {
                	session.setAttribute("ruid", ruid);
     			 	response.sendRedirect("instructor.jsp");     			 	
      			} else {
      				rs = stmt.executeQuery("select * from student where ruid='"+ruid+"' and password='"+pass+"'");				
    				count=0;

    				while (rs.next()) {
    					count++;
    				}
    				
                    if(count>0) {
                    	session.setAttribute("ruid", ruid);
         			 	response.sendRedirect("student.jsp");
          			} else {          				
                  		response.sendRedirect("index.jsp?msg=Invalid Username or Password");
          			}
      			}

				
				rs.close();
				stmt.close();
				con.close();
				
			} catch (Exception e) {
				out.println(e.getMessage());
			}
		%>
		
	</body>
</html>