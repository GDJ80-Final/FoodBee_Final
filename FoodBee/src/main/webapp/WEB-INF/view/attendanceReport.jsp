<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<h1>���� ���º���</h1>
<form method="post" action="${pageContext.request.contextPath}/">
<table border="1">
	<tr>
		<td>Ȯ������</td>
		<td>${attendanceDTO.date}</td>
	</tr>
	<tr>
		<td>��� �ð�</td>
		<td>${attendanceDTO.startTime}</td>
	</tr>
	<tr>
		<td>��� �ð�</td>
		<td>${attendanceDTO.endTime}</td>
	</tr>
	<tr>
		<td>������</td>
		<td>${map.rankName} ${map.empName}</td>
	</tr>

</table>
	<a href="${pageContext.request.contextPath}/">����</a>
	<button type="submit">Ȯ��</button>
</form>
</body>
</html>