<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>SecureBank Login</title>

<style>

body{
font-family: Arial;
background: linear-gradient(to right,#4facfe,#00f2fe);
height:100vh;
display:flex;
justify-content:center;
align-items:center;
margin:0;
}

.login-box{
background:white;
padding:40px;
border-radius:12px;
width:350px;
box-shadow:0 0 20px rgba(0,0,0,0.2);
}

.login-box h2{
text-align:center;
margin-bottom:20px;
color:#333;
}

input[type=text],input[type=password]{
width:100%;
padding:10px;
margin:10px 0;
border:1px solid #ccc;
border-radius:5px;
}

button{
width:100%;
padding:10px;
background:#007BFF;
color:white;
border:none;
border-radius:5px;
font-size:16px;
cursor:pointer;
}

button:hover{
background:#0056b3;
}

.links{
display:flex;
justify-content:space-between;
margin-top:10px;
font-size:14px;
}

.error{
color:red;
text-align:center;
margin-bottom:10px;
}

.success{
color:green;
text-align:center;
margin-bottom:10px;
}

</style>

</head>

<body>

<div class="login-box">

<h2>💳 SecureBank Login</h2>

<%
String error = request.getParameter("error");
String msg = request.getParameter("msg");

if(error!=null){
%>
<p class="error">Invalid Username or Password</p>
<%
}

if(msg!=null){
%>
<p class="success"><%=msg%></p>
<%
}
%>

<form action="login" method="post" autocomplete="off">

<label>Username</label>
<input type="text" name="username" placeholder="Enter username" required autocomplete="off">

<label>Password</label>
<input type="password" name="password" placeholder="Enter password" required autocomplete="new-password">

<label>
<input type="checkbox" name="remember"> Remember me
</label>

<button type="submit">Login</button>

<div class="links">
<a href="#">Forgot Password?</a>
<a href="register.jsp">Register</a>
</div>

</form>

</div>

</body>
</html>