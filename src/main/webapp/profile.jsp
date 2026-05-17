<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@page import="com.vinod.pack.User"%>

<%
User user = (User) session.getAttribute("user");


if(user == null){
response.sendRedirect("index.jsp");
return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<title>User Profile | SecureBank</title>

<link rel="stylesheet" href="style.css">

<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

</head>

<body class="bg-gray-100 font-sans">

<!-- NAVBAR -->

<header class="navbar">
<div class="container">

<h1 class="logo">User Profile|💳 SecureBank</h1>

<nav>
<ul>

<li><a href="dashboard.jsp">Dashboard</a></li>

<li><a href="Transaction.jsp">Transactions</a></li>

<li><a href="profile.jsp" class="active">Profile</a></li>

<li><a href="SendMoney.jsp">Send Money</a></li>

<li><a href="ApplyLoan.jsp">Apply Loan</a></li>

<li><a href="logout" class="logout-btn">Logout</a></li>

</ul>
</nav>

</div>
</header>

<!-- PROFILE CARD -->

<div class="max-w-3xl mx-auto mt-10 bg-white shadow-xl rounded-xl p-8">

<h2 class="text-3xl font-semibold text-blue-900 mb-6 border-b pb-2">
👤 Your Profile
</h2>

<div class="grid grid-cols-2 gap-6 text-lg">

<div>
<p class="font-semibold text-gray-600">Full Name</p>
<p class="text-gray-800"><%=user.getFullName()%></p>
</div>

<div>
<p class="font-semibold text-gray-600">Username</p>
<p class="text-gray-800"><%=user.getUsername()%></p>
</div>

<div>
<p class="font-semibold text-gray-600">Email</p>
<p class="text-gray-800"><%=user.getEmail()%></p>
</div>

<div>
<p class="font-semibold text-gray-600">Phone</p>
<p class="text-gray-800"><%=user.getPhoneNo()%></p>
</div>

<div>
<p class="font-semibold text-gray-600">Account Number</p>
<p class="text-gray-800 font-mono"><%=user.getAccountNumber()%></p>
</div>

<div>
<p class="font-semibold text-gray-600">Available Balance</p>
<p class="text-green-600 font-bold text-xl">
₹ <%=user.getBalance()%>
</p>
</div>

</div>

<!-- BUTTONS -->

<div class="mt-8 flex justify-center space-x-4">

<a href="dashboard.jsp"
class="bg-blue-700 text-white px-6 py-2 rounded-lg hover:bg-blue-600 transition">

<a href="dashboard.jsp">⬅ Back to Dashboard</a>

</a>

<a href="edit.jsp"
class="bg-green-600 text-white px-6 py-2 rounded-lg hover:bg-green-500 transition">

✏ Edit Profile

</a>

</div>

</div>

</body>
</html>