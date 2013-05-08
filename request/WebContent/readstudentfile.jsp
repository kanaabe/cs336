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
		
<h2>Upload Student .txt File</h2>
		
	<form name="input" method="post" action="logout.jsp">
		<input type="submit" value="Logout" />
	</form>

		<%
			try {
				//FILE FORMAT
				//name	sruid	netid	email	pass	gyear	major	gpa	credits
				String filename = request.getParameter("filename");
				int incount = 0;
				int upcount = 0;
				
				java.sql.Connection con;			
				Statement stmt;			
				//ResultSet rs;			

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				Scanner in = new Scanner(new FileReader("filename.txt"));
				while(in.hasNext()) {
					String name = in.next();
					int sruid = in.nextInt();
					String netid = in.next();
					String email = in.next();
					String pass = in.next();
					int gyear = in.nextInt();
					String major = in.next();
					float gpa = in.nextFloat();
					int credits = in.nextInt();
					
					Statement stmt2 = con.createStatement();
					ResultSet rs;
					rs = stmt2.executeQuery("SELECT sruid,pass	 from student where sruid='"+sruid+"'");
					if (rs.next()) {
						int sruid2 = rs.getInt(1);
						String pass2 = rs.getString(2);
						if (sruid==sruid2 && pass.equals(pass2)) {
							int rs2 = stmt2.executeUpdate("update student set name='"+name+"',netid='"+netid+"',email='"+email+"',password='"+pass+"',gradyear='"+gyear+"',major='"+major+"',gpa='"+gpa+"',credits='"+credits+"' where sruid='"+sruid+"'");
							if(rs2>0) upcount++;
						}
					} else {
						int rs2 = stmt2.executeUpdate("insert into student set name='"+name+"',sruid='"+sruid+"',netid='"+netid+"',email='"+email+"',password='"+pass+"',gradyear='"+gyear+"',major='"+major+"',gpa='"+gpa+"',credits='"+credits+"'");
						if(rs2>0) incount++;
					}
					
					
					rs.close();
					stmt2.close();
				}
				
				out.println("Successfully added "+incount+" students and updated "+upcount+". Please <a href=\"admin.jsp\"><b>Admin</b></a> to continue.");
				
				in.close();
				//rs.close();
				stmt.close();
				con.close();
			} catch (Exception e) {
				out.println(e.getMessage());
			}
		%>
   		
	</body>
</html>