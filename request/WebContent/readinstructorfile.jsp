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
		
<h2>Upload Instructor .txt File</h2>
		
	<form name="input" method="post" action="logout.jsp">
		<input type="submit" value="Logout" />
	</form>

		<%
			try {
				//FILE FORMAT
				//name	iruid	netid	email	pass
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
					int iruid = in.nextInt();
					String netid = in.next();
					String email = in.next();
					String pass = in.next();
					
					Statement stmt2 = con.createStatement();
					ResultSet rs;
					rs = stmt2.executeQuery("SELECT iruid,pass	 from instructor where iruid='"+iruid+"'");
					if (rs.next()) {
						int iruid2 = rs.getInt(1);
						String pass2 = rs.getString(2);
						if (iruid==iruid2 && pass.equals(pass2)) {
							int rs2 = stmt2.executeUpdate("update instructor set name='"+name+"',netid='"+netid+"',email='"+email+"',password='"+pass+"' where iruid='"+iruid+"'");
							if(rs2>0) upcount++;
						}
					} else {
						int rs2 = stmt2.executeUpdate("insert into instructor set name='"+name+"',iruid='"+iruid+"',netid='"+netid+"',email='"+email+"',password='"+pass+"'");
						rs2 = stmt2.executeUpdate("insert into weights set iruid='"+iruid+"',required='"+10+"',gpa='"+10+"',preqgrade='"+10+"',credits='"+10+"',gradyear='"+10+"'");
						if(rs2>0) incount++;
					}
					
					
					rs.close();
					stmt2.close();
				}
				
				out.println("Successfully added "+incount+" instructors and updated "+upcount+". Please <a href=\"admin.jsp\"><b>Admin</b></a> to continue.");
				
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