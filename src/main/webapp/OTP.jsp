<%@page import="com.vinod.pack.User"%>
<%
User user=(User)session.getAttribute("user");
if(user==null){
response.sendRedirect("index.jsp");
return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>OTP Verification</title>
</head>

<body>

<h2>Enter OTP</h2>

<form action="VerifyOTPServlet" method="post">

<input type="text" name="otp" placeholder="Enter OTP" required><br><br>

<input type="submit" value="Verify OTP">

</form>

</body>
</html>