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
		
<h2>View Student Request</h2>
		
	<form name="input" method="post" action="logout.jsp">
		<input type="submit" value="Logout" />
	</form>

<br>
	<% 
	try {
		int ind = Integer.parseInt(request.getParameter("index"));
		int sruid = Integer.parseInt(request.getParameter("sruid"));
		int iruid = (Integer) session.getAttribute("ruid");
		
		java.sql.Connection con;			
		Statement stmt;			
		ResultSet rs;			

		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
		con = ds.getConnection();
		stmt = con.createStatement();
				
		rs = stmt.executeQuery("SELECT priority,scomments,status,cid,title,required,timestamp	 from request where ind='"+ind+"' AND iruid='"+iruid+"'AND sruid='"+sruid+"'");		
		rs.next();
		int priority = rs.getInt(1);
		String scomments = rs.getString(2);
		String status = rs.getString(3);
		int cid = rs.getInt(4);
		String title = rs.getString(5);
		int required = rs.getInt(6);
		Timestamp timestamp = rs.getTimestamp(7);
		
		rs = stmt.executeQuery("SELECT name,gradyear,gpa,major,credits,email	 from student where sruid='"+sruid+"'");		
		rs.next();
		String name = rs.getString(1);
		int gradyear = rs.getInt(2);
		float gpa = rs.getFloat(3);
		String major = rs.getString(4);
		int credits = rs.getInt(5);
		String email = rs.getString(6);			
		
		out.println("Course Title: " + title);
		out.println("<br>Course ID: " + cid);
		out.println("<br>Index #: " + ind);
		out.println("<br>");
		out.println("<br>Student Name: " + name);
		out.println("<br>ID: " + sruid);
		out.println("<br>Email: " + email);
		out.println("<br>Major: " + major);
		if (required==1) { out.println("<br>This course is required for major.");
		} else { out.println("<br>This course is not required for major."); }
		out.println("<br>Graduation Year: " + gradyear);
		out.println("<br>GPA: " + gpa);
		out.println("<br>Total Credits: " + credits);
		out.println("<br>");
		
		rs = stmt.executeQuery("SELECT pid	 from prereqs where cid='"+cid+"'");
		while (rs.next()) {
			int preid = rs.getInt(1);
			
			Statement stmt2 = con.createStatement();
			ResultSet rs2;
			rs2 = stmt2.executeQuery("SELECT title from course where cid='"+preid+"'");
			rs2.next();
			out.print("<br>Grade in " + rs2.getString(1) + " is: ");
			rs2 = stmt2.executeQuery("SELECT grade from studentCourses where cid='"+preid+"' and sruid='"+sruid+"'");
			if (rs2.next()) {
				out.println(rs2.getFloat(1));
			} else {
				out.println("<br>CURRENTLY ENROLLED");
			}
			
			rs2.close();
			stmt2.close();
		}
		out.println("<br>");
		out.println("<br>Priority #: " + priority);
		out.println("<br>Timestamp: " + timestamp);
		out.println("<br>Student Comments: " + scomments);
						
		rs.close();
		stmt.close();
		con.close();
		
		%>
					
		<br><form name="form" method="post" action="submitrequest.jsp">
		Leave Comments for Student: <br><textarea name="comments" rows="5" cols="40"></textarea><br>
		<%
		out.println("<input type=\"hidden\" value=" + ind + " name=\"index\">"); 
		out.println("<input type=\"hidden\" value=" + sruid + " name=\"sruid\">");
		out.println("<input type=\"hidden\" value=" + cid + " name=\"cid\">");
		%>
		<input type="submit" name="action" value="Accept" /><input type="submit" name="action" value="Deny" />
		</form>		
		<%				
			
		String msg=request.getParameter("msg");
		if(msg!=null){
    	%>
			<label><font color="red"><%=msg%></font></label> 
		<%
		}	
		
	} catch (Exception e) {
		out.println(e.getMessage());
	}
	
	%>

	   		
	</body>
</html>