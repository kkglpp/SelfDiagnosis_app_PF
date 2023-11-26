<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	request.setCharacterEncoding("utf-8");
	String uid = request.getParameter("uid");

//------
	String url_mysql = "jdbc:mysql://localhost/self_diagnosis?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
		String A = "update user set udeleted = 1, udeletedate = now() where uid = ?";
	
	    ps = conn_mysql.prepareStatement(A);
		ps.setString(1, uid);

	    
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

