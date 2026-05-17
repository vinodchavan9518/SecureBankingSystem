<%@page import="com.vinod.pack.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	User user = (User) session.getAttribute("user");
	if (user == null) {
    		response.sendRedirect("index.html");
    		return;
	}
%>

<h2>Make a Payment</h2>
<form action="TransferServlet" method="post">
    <label>Sender Account:</label>
    <input type="text" value="<%= user.getAccountNumber() %>" readonly /><br><br>

    <label>Receiver Account:</label>
    <input type="text" name="receiverAccount" placeholder="Receiver Account No" required /><br><br>

    <label>Amount:</label>
    <input type="number" step="0.01" name="amount" required /><br><br>

    <button type="submit">Transfer</button>
</form>
