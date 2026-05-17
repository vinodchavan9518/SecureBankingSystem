<%@ page language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Profile</title>
<style>
body{
font-family: Arial;
background:#f4f4f4;
}

.container{
width:400px;
margin:100px auto;
background:white;
padding:20px;
border-radius:10px;
box-shadow:0 0 10px gray;
}

input{
width:100%;
padding:10px;
margin:8px 0;
}

button{
width:100%;
padding:10px;
background:#1e4fa3;
color:white;
border:none;
}
</style>
<script>
window.onload = function() {
    document.querySelector("input[name='fullname']").value="";
    document.querySelector("input[name='email']").value="";
    document.querySelector("input[name='password']").value="";
};
</script>
</head>

<body>

<div class="container">

<h2>Edit User Profile</h2>

<form action="UpdateProfileServlet" method="post"  autocomplete="off">

Full Name
<input type="text" name="fullname" >

Email
<input type="email" name="email" autocomplete="new email">

Password
<input type="password" name="password" autocomplete="password">

<button type="submit">Update  Profile</button>

</form>

</div>

</body>
</html>