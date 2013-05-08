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
		
<h2>Submit SPN Request</h2>
	
		<%
			try {		
				
				int ind = Integer.parseInt(request.getParameter("index"));
				int cid = Integer.parseInt(request.getParameter("cid"));
				int sruid = Integer.parseInt(request.getParameter("sruid"));
				String icomments = request.getParameter("comments");
				String command = request.getParameter("action");
				int iruid = (Integer) session.getAttribute("ruid");

				java.sql.Connection con;			
				Statement stmt;			
				//ResultSet rs;
				int rs = 0;

				Context ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/flylo");	
				con = ds.getConnection();
				stmt = con.createStatement();
				
				try {
					if(command.equals("Accept")) {
						Statement stmt2 = con.createStatement();
						ResultSet rs2;
						//Check Capacity
						rs2 = stmt2.executeQuery("select enrolled,capacity from courseOffering where ind='"+ind+"' AND iruid='"+iruid+"' AND cid='"+cid+"'");
						rs2.next();
						int enrolled = rs2.getInt(1);
						int capacity = rs2.getInt(2);
						if(enrolled >= capacity) response.sendRedirect("viewrequest.jsp?msg=Course is already at capacity!&index="+ind+"&sruid="+sruid+"&cid="+cid);
						
						//Get SPN	
						rs2 = stmt2.executeQuery("select number from spn where ind='"+ind+"' AND iruid='"+iruid+"'");
						if(rs2.next()) {
							String spn = rs2.getString(1);
							
							//Get Expiring Timestamp
							Timestamp expires = new java.sql.Timestamp(new java.util.Date().getTime());
							long oneMinute = 60 * 1000;
							expires.setTime(expires.getTime() + oneMinute);
							
							rs = stmt.executeUpdate("update request set icomments='"+icomments+"',status='"+spn+"',expires='"+expires+"' where ind='"+ind+"' AND iruid='"+iruid+"' AND sruid='"+sruid+"'");
							rs = stmt.executeUpdate("delete from spn where ind='"+ind+"' AND iruid='"+iruid+"'AND number='"+Integer.parseInt(spn)+"'");
							
						} else response.sendRedirect("viewrequest.jsp?msg=No Special Permission Numbers Available!&index="+ind+"&sruid="+sruid+"&cid="+cid);						
						rs2.close();
						stmt2.close();
					} else if(command.equals("Deny")){
						rs = stmt.executeUpdate("update request set icomments='"+icomments+"',status='"+"Denied"+"' where ind='"+ind+"' AND iruid='"+iruid+"' AND sruid='"+sruid+"'");
					} else {
						%> Buttons not working. Please return to the <a href="instructor.jsp"><b>Instructor Page</b></a> to continue. <%
					}
				}  catch (Exception e) {
					response.sendRedirect("viewrequest.jsp?msg=Error Occured. Please try again!&index="+ind+"&sruid="+sruid+"&cid="+cid);
				}
				
				if(rs>0) {
                	response.sendRedirect("viewcourse.jsp?index=" + ind);
				}

				
				//rs.close();
				stmt.close();
				con.close();
				
			} catch (Exception e) {
				out.println(e.getMessage());
			}
		%>
		
	</body>
</html>