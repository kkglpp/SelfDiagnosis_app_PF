<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	request.setCharacterEncoding("utf-8");
	String uid = request.getParameter("uid");
	int sSeq = Integer.parseInt(request.getParameter("sSeq"));
	int category = Integer.parseInt(request.getParameter("category"));
	String answer = request.getParameter("answer");
	int a_result = Integer.parseInt(request.getParameter("aResult"));
		
//------
	String url_mysql = "jdbc:mysql://localhost/self_diagnosis?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
	    String A = "insert into answer (a_uid, a_sSeq, a_category, a_answer, a_insertdate, a_deleted, a_result";
	    String B = ") values (?, ?, ?, ?, now(), 0, ?)";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, uid);
	    ps.setInt(2, sSeq);
	    ps.setInt(3, category);
	    ps.setString(4, answer);
		ps.setInt(5, a_result);
	    
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
	

