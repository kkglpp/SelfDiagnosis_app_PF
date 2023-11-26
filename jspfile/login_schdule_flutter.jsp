<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%
	request.setCharacterEncoding("utf-8");
	String uid = request.getParameter("uid");
	String upassword = request.getParameter("upassword");

	//------

	String url_mysql = "jdbc:mysql://localhost/self_diagnosis?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	Connection conn_mysql = null;
	PreparedStatement ps = null;
	PreparedStatement ps2 = null;  // uname 가져오기
	ResultSet rs = null;
	ResultSet rs2 = null; // uname
	String result = "ERROR"; // Default response value


	// attribute를 리스트에 담기위함
	JSONObject jsonList = new JSONObject();
    JSONArray itemList = new JSONArray();


	int seq = 0;
	String uname = ""; // name 초기화
	int weight = 0;
	int height = 0;
	String uemail = "";
	String uphone = "";
	String uinsertdate = "";
	int udeleted = 0;

	try {
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
	    String sql = "SELECT count(*) AS count FROM user WHERE uid = ? and upassword = ? and udeleted =0 ";
	    ps = conn_mysql.prepareStatement(sql);
		ps.setString(1, uid);
		ps.setString(2, upassword);
	    rs = ps.executeQuery();
		
		
		// uname 가져오기
	    String sql2 = "SELECT uid,upassword,uname,weight,height,uemail,uphone,uinsertdate,udeleted FROM user WHERE uid = ? and upassword = ? ";
	    ps2 = conn_mysql.prepareStatement(sql2);
		
		ps2.setString(1, uid);
		ps2.setString(2, upassword);
	    rs2 = ps2.executeQuery();





		
	    if (rs.next()) {
	        int rowCount = rs.getInt("count");
			if(rs2.next()){
				uid = rs2.getString("uid");
				upassword = rs2.getString("upassword");
				uname = rs2.getString("uname");
				weight = rs2.getInt("weight");
				height = rs2.getInt("height");
				uemail = rs2.getString("uemail");
				uphone = rs2.getString("uphone");
				uinsertdate = rs2.getString("uinsertdate");
				udeleted = rs2.getInt("udeleted");

				JSONObject tempJson = new JSONObject();
				tempJson.put("uid", rs2.getString(1));
				tempJson.put("upassword", rs2.getString(2));
				tempJson.put("uname", rs2.getString(3));
				tempJson.put("weight", rs2.getInt(4));
				tempJson.put("height", rs2.getInt(5));
				tempJson.put("uemail", rs2.getString(6));
				tempJson.put("uphone", rs2.getString(7));
				tempJson.put("uinsertdate", rs2.getString(8));
				tempJson.put("udeleted", rs2.getInt(9));
				tempJson.put("count", rs.getInt("count"));
				itemList.add(tempJson);
			}
			jsonList.put("results",itemList);
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
	out.print(jsonList);
	// Generate JSON response
	//out.println("{\"result\":\"" + result + "\",\"uid\":\"" + uid + "\",\"upassword\":\"" + upassword + "\",\"uname\":\"" + uname + "\",\"weight\":\"" + weight + "\",\"height\":\"" + height + "\",\"uemail\":\"" + uemail + "\",\"uphone\":\"" + uphone + "\",\"uinsertdate\":\"" + uinsertdate + "\",\"udeleted\":\"" + udeleted + "\"}");
	
%>