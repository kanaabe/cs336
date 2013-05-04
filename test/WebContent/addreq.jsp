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
		
<h2>Add Request</h2>
	
		<%
			try {		
				
				int ruid = (Integer) session.getAttribute("ruid");
				int ind = Integer.parseInt(request.getParameter("ind"));
				boolean required = false;
				if (request.getParameter("required").equals("true")) required = true;
				String comments = request.getParameter("comments");
				int cid = 0;
				String title = "";
				int iruid = 0;


				java.sql.Connection con;			
				Statement stmt;			
				ResultSet rs;		

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				rs = stmt.executeQuery("SELECT cid,iruid	 from courseOffering where ind='"+ind+"'");
				int count=0;
				while (rs.next()) {
					count++;
					cid = rs.getInt(1);
					iruid = rs.getInt(2);
				}
				if(count>0) {
					rs = stmt.executeQuery("SELECT title	 from course where cid='"+cid+"'");	
					count=0;
					while (rs.next()) {
						count++;
						title = rs.getString(1);
					}
					if(count>0) {
						int rs2 = stmt.executeUpdate("insert into request set sruid='"+ruid+"',iruid='"+iruid+"',ind='"+ind+"',cid='"+cid+"',title='"+title+"',comments='"+comments+"',priority='"+99+"',status='"+"Pending"+"',required='"+required+"'");
						
		                if(rs2>0) {
		                	%> Request Successful. Please return to the <a href="student.jsp"><b>Student</b></a> page to continue. <%
		      			} else {
		              		response.sendRedirect("addreqform.jsp?msg=Request could not be added.  Please try again.");
		      			}
					} else {
						response.sendRedirect("addreqform.jsp?msg=Course ID does not exist.");
					}
      			} else {
      				response.sendRedirect("addreqform.jsp?msg=The requested Index# does not exist");
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