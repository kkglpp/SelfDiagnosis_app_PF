<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	request.setCharacterEncoding("utf-8");
	String uid = request.getParameter("uid");
	String upassword = request.getParameter("upassword");
	String uname = request.getParameter("uname");
	String uemail = request.getParameter("uemail");
	String uphone = request.getParameter("uphone");
	int height = Integer.parseInt(request.getParameter("height"));
	int weight = Integer.parseInt(request.getParameter("weight"));

//------
	String url_mysql = "jdbc:mysql://localhost/self_diagnosis?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
		String A = "update user set upassword = ?, uname = ?, uphone = ?, uemail = ?, height =?, weight = ?, uupdatedate = now() where uid = ?";
	
	    ps = conn_mysql.prepareStatement(A);
	    ps.setString(1, upassword);
	    ps.setString(2, uname);
		ps.setString(3, uphone);
		ps.setString(4, uemail);
		ps.setInt(5, height);
		ps.setInt(6, weight);
		ps.setString(7, uid);

	    
	    ps.executeUpdate();
	
	    conn_mysql.close();
%>
		{"result":"OK"}	
<%			
	} 
	catch (Exception e){
%>		
		{"result":"ERROR"}	
<%		
	}
%>

