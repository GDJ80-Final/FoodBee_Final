<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>��� ���</title>
</head>
<body>
    <h1>���� ���</h1>
    <form id="dateForm" method="get" action="${pageContext.request.contextPath}/roomRsvList">
        <input type="date" id="dateInput" name="date" value="${rsvDate}">
    </form>
    <table border="1">
        <tr>   
            <th>ȸ�ǽ�</th>
            <th>���� ��¥</th>
            <th>����ð�</th>
            <th>������</th>
        </tr>
        <c:forEach var="rsv" items="${rsvListByDate}">
            <tr>
                <td>${rsv.roomName}</td>
                <td>${rsv.rsvDate}</td>
                <td>${rsv.startDateTime} ~ ${rsv.endDateTime}</td>
                <td>${rsv.empName}</td>
            </tr>
        </c:forEach>
    </table>
    <script>
        // �������� �ε�� �� ����� �Լ�
        window.onload = function() {
            var today = new Date();
            var year = today.getFullYear();
            var month = ('0' + (today.getMonth() + 1)).slice(-2);
            var day = ('0' + today.getDate()).slice(-2);
            var dateString = year + '-' + month + '-' + day;
            document.getElementById('dateInput').value = dateString; // �⺻�� ����
        }

        // ��¥ �Է� ���� �� �� ����
        document.getElementById('dateInput').addEventListener('change', function() {
            document.getElementById('dateForm').submit();
        });
    </script>
</body>
</html>