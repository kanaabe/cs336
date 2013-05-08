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
		
<h2>Enroll in a Course</h2>
	
		<%
			try {		
				int sruid = (Integer) session.getAttribute("ruid");
				int cid = Integer.parseInt(request.getParameter("cid"));
				int ind = Integer.parseInt(request.getParameter("index"));


				java.sql.Connection con;			
				Statement stmt;			
				ResultSet rs;		

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				//Check if SPN has expired;
				rs = stmt.executeQuery("select expires,status,iruid from request where ind='"+ind+"' AND cid='"+cid+"'");
				rs.next();
				Timestamp expires = rs.getTimestamp(1);
				Timestamp timestamp = new java.sql.Timestamp(new java.util.Date().getTime());
				
				String status = rs.getString(2);
				int iruid = rs.getInt(3);
				if(status.equals("Pending")) throw new Exception("Your request is still pending. Please return to the <a href=\"student.jsp\"><b>Student</b></a> page to continue.");
				if(status.equals("Denied")) throw new Exception("Your request has been denied, you cannot add this course. Please return to the <a href=\"student.jsp\"><b>Student</b></a> page to continue.");
				if(status.equals("Enrolled")) throw new Exception("You are already enrolled for this course. Please return to the <a href=\"student.jsp\"><b>Student</b></a> page to continue.");
				if(status.equals("Expired")) throw new Exception("Your SPN for this request has already expired. Please return to the <a href=\"student.jsp\"><b>Student</b></a> page to continue.");
				int spn = Integer.parseInt(status);
				
				if(timestamp.after(expires)) {
					int rs3 = stmt.executeUpdate("update request set status='"+"Expired"+"' where ind='"+ind+"' AND cid='"+cid+"' AND sruid='"+sruid+"'");
					rs3 = stmt.executeUpdate("insert into spn set number='"+spn+"',iruid='"+iruid+"',ind='"+ind+"'");		
					throw new Exception("Sorry, the SPN has already expired. Please return to the <a href=\"student.jsp\"><b>Student</b></a> page to continue.");
				}
				
				//Check for Capacity
				rs = stmt.executeQuery("select enrolled,capacity from courseOffering where ind='"+ind+"' AND cid='"+cid+"'");
				rs.next();
				int enrolled = rs.getInt(1);
				int capacity = rs.getInt(2);
				if(enrolled >= capacity) {
					throw new Exception("Sorry, the class is already at maximum capacity. Please return to the <a href=\"student.jsp\"><b>Student</b></a> page to continue.");
				}
				
				int rs2 = stmt.executeUpdate("insert into studentEnrolled set sruid='"+sruid+"',ind='"+ind+"',cid='"+cid+"'");
		       
				if(rs2>0) {
					rs2 = stmt.executeUpdate("update request set status='"+"Enrolled"+"' where ind='"+ind+"' AND cid='"+cid+"' AND sruid='"+sruid+"'");
		        	%> Congratulation! Enrollment Successful. Please return to the <a href="student.jsp"><b>Student</b></a> page to continue. <%
		      	} else {
		      		%> Could not process enrollment. Please return to the <a href="student.jsp"><b>Student</b></a> page to continue. <%
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