<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<title>SecureBank | Register</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>

/* PAGE STYLE */

body{
font-family:"Segoe UI",Tahoma;
margin:0;
background:#f5f6fa;
color:#333;
}

/* HEADER */

header{
background:#0a3d62;
color:white;
padding:15px 0;
}

.container{
width:90%;
max-width:1100px;
margin:auto;
display:flex;
justify-content:space-between;
align-items:center;
}

.logo{
font-size:22px;
font-weight:bold;
}

nav ul{
list-style:none;
display:flex;
margin:0;
padding:0;
}

nav ul li{
margin-left:20px;
}

nav ul li a{
color:white;
text-decoration:none;
font-weight:500;
}

/* REGISTER BOX */

.register-section{
display:flex;
justify-content:center;
align-items:center;
padding:60px 20px;
}

.register-box{
background:white;
width:100%;
max-width:450px;
padding:30px;
border-radius:12px;
box-shadow:0 4px 15px rgba(0,0,0,0.1);
}

.register-box h2{
text-align:center;
color:#0a3d62;
}

.form-group{
margin-bottom:15px;
}

.form-group label{
display:block;
margin-bottom:6px;
font-weight:600;
}

.form-group input{
width:100%;
padding:10px;
border-radius:6px;
border:1px solid #ccc;
}

.form-group input:focus{
border-color:#0a3d62;
outline:none;
}

/* BUTTON */

.btn-register{
width:100%;
background:#0a3d62;
color:white;
border:none;
padding:12px;
border-radius:8px;
font-size:16px;
cursor:pointer;
}

.btn-register:hover{
background:#1e3799;
}

/* MESSAGE */

.msg{
text-align:center;
color:green;
margin-bottom:10px;
}

.error{
text-align:center;
color:red;
margin-bottom:10px;
}

/* LOGIN LINK */

.login-link{
text-align:center;
margin-top:15px;
}

footer{
text-align:center;
background:#0a3d62;
color:white;
padding:12px;
position:fixed;
bottom:0;
width:100%;
}

</style>

<script>

/* PASSWORD MATCH CHECK */

function validateForm(){

var pass=document.getElementById("password").value;
var confirm=document.getElementById("confirmPassword").value;

if(pass!==confirm){

alert("Passwords do not match!");

return false;

}

return true;

}

</script>

</head>

<body>

<!-- HEADER -->

<header>

<div class="container">

<h1 class="logo">💳 SecureBank</h1>

<nav>

<ul>

<li><a href="index.html">Login</a></li>

<li><a href="#">Support</a></li>

</ul>

</nav>

</div>

</header>

<!-- REGISTER FORM -->

<section class="register-section">

<div class="register-box">

<h2>Create SecureBank Account</h2>

<%

String msg=request.getParameter("msg");

String error=request.getParameter("error");

if(msg!=null){
%>

<div class="msg"><%=msg%></div>

<%
}

if(error!=null){
%>

<div class="error"><%=error%></div>

<%
}
%>

<form action="RegisterServlet" method="post" onsubmit="return validateForm()" autocomplete="off">

<div class="form-group">

<label>Full Name</label>

<input type="text" name="fullName" required>

</div>

<div class="form-group">

<label>Email</label>

<input type="email" name="email" required>

</div>

<div class="form-group">

<label>Phone Number</label>

<input type="tel" name="phone" pattern="[0-9]{10}" placeholder="10 digit number" required>

</div>

<div class="form-group">

<label>Username</label>

<input type="text" name="username" required>

</div>

<div class="form-group">

<label>Password</label>

<input type="password" name="password" id="password" required>

</div>

<div class="form-group">

<label>Confirm Password</label>

<input type="password" name="confirmPassword" id="confirmPassword" required>

</div>

<label>

<input type="checkbox" required>

I agree to Terms & Conditions

</label>

<br><br>

<button class="btn-register">Register</button>

<p class="login-link">

Already have an account?

<a href="index.html">Login</a>

</p>

</form>

</div>

</section>

<footer>

© 2025 SecureBank

</footer>

</body>

</html>