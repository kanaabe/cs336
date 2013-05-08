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
		
<h2>Instructor Registration</h2>
	
		<%
			try {		
				
				String name = request.getParameter("name");
				int iruid = Integer.parseInt(request.getParameter("ruid"));
				String netid = request.getParameter("netid");
				String email = request.getParameter("email");
				String pass = request.getParameter("pass");

				java.sql.Connection con;			
				Statement stmt;			
				ResultSet rs;		

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				int rs2 = 0;
				rs = stmt.executeQuery("SELECT iruid,pass	 from instructor where iruid='"+iruid+"'");
				if (rs.next()) {
					int iruid2 = rs.getInt(1);
					String pass2 = rs.getString(2);
					if (iruid==iruid2 && pass.equals(pass2)) {
						rs2 = stmt.executeUpdate("update instructor set name='"+name+"',netid='"+netid+"',email='"+email+"',password='"+pass+"' where iruid='"+iruid+"'");
					}
				} else {
					rs2 = stmt.executeUpdate("insert into instructor set name='"+name+"',iruid='"+iruid+"',netid='"+netid+"',email='"+email+"',password='"+pass+"'");
					rs2 = stmt.executeUpdate("insert into weights set iruid='"+iruid+"',required='"+10+"',gpa='"+10+"',preqgrade='"+10+"',credits='"+10+"',gradyear='"+10+"'");
				}				
				
                if(rs2>0) {
                	%> Registration Successful. Please <a href="index.jsp"><b>Login</b></a> to continue. <%
      			} else {
              		response.sendRedirect("regform.jsp?msg=Registration Failed.  Please try again.");
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