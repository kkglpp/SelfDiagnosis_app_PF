<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String uid = request.getParameter("uid");

	//------

	String url_mysql = "jdbc:mysql://localhost/self_diagnosis?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	Connection conn_mysql = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	String result = "ERROR"; // Default response value

	try {
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
	    String sql = "SELECT count(uid) AS count FROM user WHERE uid = ?";
	    ps = conn_mysql.prepareStatement(sql);
		ps.setString(1, uid);
	    rs = ps.executeQuery();

	    if (rs.next()) {
	        int rowCount = rs.getInt("count");
	        if (rowCount == 1) {
	            result = "OK";
	        }
	    }
	} catch (Exception e) {
	    e.printStackTrace();
	} finally {
	    try {
	        if (rs != null) rs.close();
	        if (ps != null) ps.close();
	        if (conn_mysql != null) conn_mysql.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	// Generate JSON response
	out.println("{\"result\":\"" + result + "\"}");
%>