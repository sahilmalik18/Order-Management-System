<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.sql.*" %>
    <%@page import="com.highradius.internship.*" %>
   
<!DOCTYPE html>
<html>

<head>
<meta charset="ISO-8859-1">
<title>Highradius Winter Recruitment</title>
<link rel="stylesheet" href="css/index.css">
<style>
.human-machine-hand-logo{
background-image: url("images/human-machine-hand-homepage.jpg");
background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
    position:relative;
    height:300px;

}
input[type=button], input[type=submit], input[type=reset] {
  background-color: grey;
  border: none;
  color: white;
  padding: 10px 10px;
  text-align: center;
  font-size: 16px;
  position:absolute;
  top:150px;
  font-size:12px;
  width:100px;
  right:0px;
  border-radius:10px;
}
</style>
</head>

<body>

<section class="header">

	<div class="header-logo-div">
		<img src="images/hrc-logo.svg" alt="highradius-logo" class="hrc-logo">
	</div>

	<div class="human-machine-hand-logo">

	<div class="order-manage">
	ORDER MANAGEMENT APPLICATION
	</div>

	<div class="login-screen">
	<b>Sign In</b>

<form class="login-form" action="Login_Servlet" method="post">
Username<br><br>
<input type="text" id="name" name="name" required><br><br>
Password<br><br>
<input type="password" id="pass" name="pass" required>
<input type="submit" value="Sign In">
</form>

</div>

<p style="color:red"><%
    if(null!=request.getAttribute("errorMessage"))
    {
        out.println(request.getAttribute("errorMessage"));
    }
%></p>
</div>


</section>

</body>

</html>