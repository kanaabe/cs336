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
		int iruid = (int) session.getAttribute("ruid");
		
		java.sql.Connection con;			
		Statement stmt;			
		ResultSet rs;			

		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
		con = ds.getConnection();
		stmt = con.createStatement();
				
		rs = stmt.executeQuery("SELECT priority,scomments,status,cid,title,required	 from request where ind='"+ind+"' AND iruid='"+iruid+"'AND sruid='"+sruid+"'");		
		rs.next();
		int priority = rs.getInt(1);
		String scomments = rs.getString(2);
		String status = rs.getString(3);
		int cid = rs.getInt(4);
		String title = rs.getString(5);
		boolean required = rs.getBoolean(6);				
		
		rs = stmt.executeQuery("SELECT name,gradyear,gpa,major,credits,email	 from student where sruid='"+sruid+"'");		
		rs.next();
		String name = rs.getString(1);
		int gradyear = rs.getInt(2);
		float gpa = rs.getFloat(3);
		String major = rs.getString(4);
		int credits = rs.getInt(5);
		String email = rs.getString(6);			
		
		out.println("Course Title: " + title);
		out.println("Course ID: " + cid);
		out.println("Index #: " + ind);
		out.println();
		out.println("Student Name: " + name);
		out.println("ID: " + sruid);
		out.println("Email: " + email);
		out.println("Major: " + major);
		if (required) { out.println("This course is required for major.");
		} else { out.println("This course is not required for major."); }
		out.println("Graduation Year: " + gradyear);
		out.println("GPA: " + gpa);
		out.println("Total Credits: " + credits);
		out.println();
		
		rs = stmt.executeQuery("SELECT pid	 from prereqs where cid='"+cid+"'");
		while (rs.next()) {
			String preid = rs.getString(1);
			ResultSet rs2;
			rs2 = stmt.executeQuery("SELECT title from Course where cid='"+cid+"'");
			rs2.next();
			out.print("Grade in " + rs.getString(1) + " is: ");
			rs2 = stmt.executeQuery("SELECT grade from studentCourses where cid='"+cid+"' and sruid='"+sruid+"'");
			if (rs2.next()) {
				out.println(rs.getFloat(1));
			} else {
				out.println("CURRENTLY ENROLLED");
			}
			rs2.close();
		}
		out.println();
		out.println("Priority #: " + priority);
		out.println("Student Comments: " + scomments);
						
		rs.close();
		stmt.close();
		con.close();
		
		%>
					
		<br><form name="form" method="post" action="submitrequest.jsp">
		Leave Comments for Student: <br><textarea name="comments" rows="5" cols="40"></textarea><br>
		<%
		out.println("<input type=\"hidden\" value=" + ind + " name=\"index\">"); 
		out.println("<input type=\"hidden\" value=" + sruid + " name=\"sruid\">");
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