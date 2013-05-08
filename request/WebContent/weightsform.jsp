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
		
<h2>Customize Weights</h2>

		Current Weights for each attribute:<br>
		<%
			try {		
				int iruid = (Integer) session.getAttribute("ruid");

				java.sql.Connection con;			
				Statement stmt;			
				ResultSet rs;		

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				//Get Weights
				rs = stmt.executeQuery("SELECT required,gpa,preqgrade,credits,gradyear	 from weights where iruid='"+iruid+"'");
				rs.next();
				int wrequired = rs.getInt(1);
				int wgpa = rs.getInt(2);
				int wpreqgrade = rs.getInt(3);
				int wcredits = rs.getInt(4);
				int wgradyear = rs.getInt(5);
				
				
				out.println(wrequired + " : Weight if class is required for your major.<br>");
				out.println(wgpa + " : Weight of GPA.<br>");
				out.println(wpreqgrade + " : Weight of average pre-requisite grade.<br>");
				out.println(wcredits + " : Weight of total credits.<br>");		
				out.println(wgradyear + " : Weight of graduation year.<br><br>");
				
				out.println("Priority of Required is: if (required is true) priority += weightRequired<br>");
				out.println("Priority of GPA is: priority += ((gpa/4.0)*weightGPA)<br>");
				out.println("Priority of Pre-Requisite Grade is: priority += ((avgPreRequisiteGrade)/4.0)*weightPreRequisiteGrade<br>");
				out.println("Priority of Credits is: priority += (totalCredits/120.0)*weightCredits<br>");
				out.println("Priority of Graduation Year is: priority += weightGradYear/((gradyear - 2013) + 1)<br>");				
				
				rs.close();
				stmt.close();
				con.close();
				
			} catch (Exception e) {
				out.println(e.getMessage());
			}
		%>

	<br> To change the current weight of each attribute:
	<form name="form" method="post" action="changeweights.jsp">
	<table>
		<tr><td>Weight of Required:</td><td><input type="text" name="wrequired"></td></tr>
		<tr><td>Weight of GPA:</td><td><input type="text" name="wgpa"></td></tr>
		<tr><td>Weight of Pre-Requisite Grade:</td><td><input type="text" name="wpreqgrade"></td></tr>
		<tr><td>Weight of Credits:</td><td><input type="text" name="wcredits"></td></tr>
		<tr><td>Weight of Graduation Year:</td><td><input type="text" name="wgradyear"></td></tr>
		<tr><td></td><td><input type="submit" value="Change Weights"></td></tr>
	</table>
	</form>
	
		<%
		String msg=request.getParameter("msg");
		if(msg!=null){
    	%>
			<label><font color="red"><%=msg%></font></label> 
		<%
		}
   		%>
   		
	</body>
</html>
		