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
				
				int sruid = (Integer) session.getAttribute("ruid");
				int ind = Integer.parseInt(request.getParameter("ind"));
				int required = 1;
				if (request.getParameter("required") == null) required = 0;
				String scomments = request.getParameter("comments");
				int numprereq = 0;
				float sumprereq = 0;

				java.sql.Connection con;			
				Statement stmt;			
				ResultSet rs;		

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();

				rs = stmt.executeQuery("SELECT cid,iruid	 from courseOffering where ind='"+ind+"'");
				rs.next();
				int cid = rs.getInt(1);
				int iruid = rs.getInt(2);

				rs = stmt.executeQuery("SELECT title	 from course where cid='"+cid+"'");	
				rs.next();
				String title = rs.getString(1);

				rs = stmt.executeQuery("SELECT pid	 from prereqs where cid='"+cid+"'");

				while (rs.next()) {
					int preid = rs.getInt(1);
					boolean taken = false;
					
					Statement stmt2 = con.createStatement();
					ResultSet rs2;

					rs2 = stmt2.executeQuery("SELECT cid,grade from studentCourses where sruid='"+sruid+"'");
					while(rs2.next()) {
						int tempcid = rs2.getInt(1);
						float grade = rs2.getFloat(2);
						if (tempcid == preid) {
							if (grade >= 1) { 
								taken = true;
								numprereq++;
								sumprereq += grade;
							} else response.sendRedirect("addreqform.jsp?msg=Need a grade of D or better to request this class.");
						}
					}
					rs2 = stmt2.executeQuery("SELECT cid from studentEnrolled where sruid='"+sruid+"'");
					while(rs2.next()) {
						int tempcid = rs2.getInt(1);
						if (tempcid == preid) taken = true;
					}
					if (!taken) response.sendRedirect("addreqform.jsp?msg=You do not have the required prereqs.");					

					rs2.close();
					stmt2.close();
				}

				//Get Weights
				rs = stmt.executeQuery("SELECT required,gpa,preqgrade,credits,gradyear	 from weights where iruid='"+iruid+"'");
				rs.next();
				int wrequired = rs.getInt(1);
				int wgpa = rs.getInt(2);
				int wpreqgrade = rs.getInt(3);
				int wcredits = rs.getInt(4);
				int wgradyear = rs.getInt(5);

				//Calculate Priority
				rs = stmt.executeQuery("SELECT gradyear,gpa,credits	 from student where sruid='"+sruid+"'");
				rs.next();
				int gradyear = rs.getInt(1);
				float gpa = rs.getFloat(2);
				int credits = rs.getInt(3);
				float sum = 0;
				
				if (required == 1) sum += wrequired;
				sum += ((gpa/4.0)*wgpa);
				if(numprereq != 0) sum += ((sumprereq/numprereq)/4.0)*wpreqgrade;
				sum += (credits/120.0)*wcredits;
				sum += ((float) wgradyear)/((gradyear - 2013) + 1);			
				int priority = (int) sum;
				
				//Get Timestamp
				Timestamp timestamp = new java.sql.Timestamp(new java.util.Date().getTime());

				out.println(sruid+ "<br>");
				out.println(iruid+ "<br>");
				out.println(ind+ "<br>");
				out.println(cid+ "<br>");
				out.println(title+ "<br>");
				out.println(scomments+ "<br>");
				out.println(priority+ "<br>");
				out.println(required+ "<br>");
				out.println(timestamp+ "<br>");
				
				int rs3 = stmt.executeUpdate("insert into request set sruid='"+sruid+"',iruid='"+iruid+"',ind='"+ind+"',cid='"+cid+"',title='"+title+"',scomments='"+scomments+"',icomments='"+"None"+"',priority='"+priority+"',status='"+"Pending"+"',required='"+required+"',timestamp='"+timestamp+"'");
	
		        if(rs3>0) {
		         	%> Request Successful. Please return to the <a href="student.jsp"><b>Student</b></a> page to continue. <%
		      	} else {
		          	response.sendRedirect("addreqform.jsp?msg=Request could not be added.  Please try again.");
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