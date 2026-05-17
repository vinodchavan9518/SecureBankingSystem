<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>SecureBank | Login</title>

<style>

/* ===== Page Style ===== */

body{
font-family: Arial, sans-serif;
background: linear-gradient(to right,#4facfe,#00f2fe);
height:100vh;
display:flex;
justify-content:center;
align-items:center;
margin:0;
}

/* ===== Login Box ===== */

.login-box{
background:white;
padding:40px;
border-radius:12px;
width:350px;
box-shadow:0 0 20px rgba(0,0,0,0.2);
}

/* ===== Title ===== */

.login-box h2{
text-align:center;
margin-bottom:20px;
color:#333;
}

/* ===== Input Fields ===== */

input{
width:100%;
padding:10px;
margin:10px 0;
border:1px solid #ccc;
border-radius:5px;
font-size:14px;
}

/* ===== Login Button ===== */

button{
width:100%;
padding:10px;
background:#007BFF;
color:white;
border:none;
border-radius:5px;
cursor:pointer;
font-size:16px;
}

button:hover{
background:#0056b3;
}

/* ===== Message Styles ===== */

.error{
color:red;
text-align:center;
margin-bottom:10px;
font-size:14px;
}

.success{
color:green;
text-align:center;
margin-bottom:10px;
font-size:14px;
}

/* ===== Links ===== */

.links{
display:flex;
justify-content:space-between;
margin-top:10px;
font-size:14px;
}

.links a{
text-decoration:none;
color:#007BFF;
}

.links a:hover{
text-decoration:underline;
}

</style>

</head>

<body>

<div class="login-box">

<h2>💳 SecureBank Login</h2>

<%
/* ===== Message Logic ===== */

String error = request.getParameter("error");
String msg = request.getParameter("msg");

/* Show error ONLY when error=1 */

if("1".equals(error)){
%>

<p class="error">Invalid Username or Password</p>

<%
}

/* Show success message (example after registration) */

if(msg!=null){
%>

<p class="success"><%=msg%></p>

<%
}
%>

<!-- ===== Login Form ===== -->

<form action="login" method="post" autocomplete="off">

<label>Username</label>
<input type="text" name="username" placeholder="Enter username" required autocomplete="off">

<label>Password</label>
<input type="password" name="password" placeholder="Enter password" required autocomplete="new-password">

<button type="submit">Login</button>

<div class="links">
<a href="#">Forgot Password?</a>
<a href="register.jsp">Register</a>
</div>

</form>

</div>

</body>

</html>