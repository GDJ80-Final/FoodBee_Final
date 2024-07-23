<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>일정 상세보기</h1>
	<a href="schedule">돌아가기</a>
		<table border="1">
			<tr>
				<th>작성자</th>
				<td>
					<input type="text" value="<c:out value="${one.empName}"></c:out>"readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>시작일시</th>
				<td>
					<input type="datetime-local" name="startDatetime" value="<c:out value="${one.startDatetime}"></c:out>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>종료일시</th>
				<td>
					<input type="datetime-local" name="endDatetime" value="<c:out value="${one.endDatetime}"></c:out>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>유형</th>
				<td>
					<input type="text" value="<c:out value="${one.type}"></c:out>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="text" name="title" value="<c:out value="${one.title}"></c:out>" readonly="readonly"></td>
			</tr>
			<tr>
				<th>메모</th>
				<td>
					<textarea rows="3" cols="30" name="content" readonly="readonly"><c:out value="${one.content}"></c:out></textarea>
				</td>
			</tr>
		</table>
	<a href="modifySchedule?scheduleNo=<c:out value='${one.scheduleNo}'/>">수정하기</a>
	<a href="deleteSchedule?scheduleNo=<c:out value='${one.scheduleNo}'/>">삭제</a>
</body>
</html>