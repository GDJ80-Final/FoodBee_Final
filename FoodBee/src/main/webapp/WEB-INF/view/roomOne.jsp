<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>ȸ�ǽ� ���� �� ����</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
	<h1>ȸ�ǽ� ����</h1>
	<form method="post" action="${pageContext.request.contextPath}/roomRsv">		
		<input type="hidden" value="${roomNo}" name="roomNo">
		<input type="date" value="${rsvDate}" name="rsvDate" readonly="readonly">
		<div>����� �ð� : </div>
		<c:forEach var="m" items="${reservedTimes}">
		    <input type="hidden" value="${m.startDateTime}" id="startDateTime_${m.index}">
		    <input type="hidden" value="${m.endDateTime}" id="endDateTime_${m.index}">
		    <div>${m.startDateTime}~${m.endDateTime}</div>
		</c:forEach>
		
		<label for="start-time">���� �ð�:</label>
	    <select id="start-time" name="startTime">
	        <option selected="selected">:::����:::</option>        
	    </select>
	
	    <label for="end-time">���� �ð�:</label>
	    <select id="end-time" name="endTime">
	        <option selected="selected">:::����:::</option>       
	    </select>
	
	    <label for="selected-times">���õ� �ð�:</label>
	    <select id="selected-times" name="selectedTimes" multiple>
	    </select>
	    
	    <label for="all-day">����:</label>
		<input type="checkbox" id="all-day">
		<br>
		<label for="type">���� :</label>
	    <input type="radio" name="type" id="type" value="team"> ��
	    <input type="radio" name="type" id="type" value="personal"> ���ο빫
	    
	    
		<table border="1">
			<tr>
				<td style="width:300px; height:50px;">ȸ�ǽ� ��</td>
				<td style="width:25%; height:50px;">�̹���</td>
				<td style="width:25%; height:50px;">��ġ</td>
				<td style="width:25%; height:50px;">�����ο�</td>
				<td style="width:25%; height:50px;">��ǰ</td>
			</tr>
		
			<tr>
				<td style="height:200px;">${roomInfo.roomName}</td>				
				<td style="height:200px;">gd
					<!-- <img src="FoodBee/img/${roomInfo.originalFiles}" width="100px"></td>  -->
				<td style="height:200px;">${roomInfo.roomPlace}</td>
				<td style="height:200px;">�ִ� ${roomInfo.roomMax}��</td>
				<td style="height:200px;">${roomInfo.info}</td>
				
			</tr>
			<tr>
				<td>����</td>
				<td colspan="4"><textarea style="width: 100%; height: 300px;"></textarea></td>
			</tr>
		</table>
			<button type="submit">����</button>
			<button type="button"><a href="${pageContext.request.contextPath}/roomList">���</a></button>
			
	</form>	
<script>
	const startTimeSelect = document.getElementById('start-time');
	const endTimeSelect = document.getElementById('end-time');
	const selectedTimesSelect = document.getElementById('selected-times');
	const allDayCheckbox = document.getElementById('all-day');		
	const availableTimes = [
	    { value: '09:00', label: '09:00' },
	    { value: '09:30', label: '09:30' },
	    { value: '10:00', label: '10:00' },
	    { value: '10:30', label: '10:30' },
	    { value: '11:00', label: '11:00' },
	    { value: '11:30', label: '11:30' },
	    { value: '12:00', label: '12:00' },
	    { value: '12:30', label: '12:30' },		    
	    { value: '13:00', label: '13:00' },
	    { value: '13:30', label: '13:30' },
	    { value: '14:00', label: '14:00' },
	    { value: '14:30', label: '14:30' },
	    { value: '15:00', label: '15:00' },
	    { value: '15:30', label: '15:30' },
	    { value: '16:00', label: '16:00' },
	    { value: '16:30', label: '16:30' },
	    { value: '17:00', label: '17:00' },
	    { value: '17:30', label: '17:30' },
	    { value: '18:00', label: '18:00' }
	];

	const reservedTimes = [
	    { start: '09:00', end: '10:00' } // ����� �ð� ����
	    
	];

	// �ð� �ɼ� ����
	function populateTimeOptions() {
	    availableTimes.forEach(time => {
	        const option = new Option(time.label, time.value);
	        // ����� �ð� ���� Ȯ��
	        const isReserved = reservedTimes.some(reserved => {
	            const reservedStart = reserved.start;
	            const reservedEnd = reserved.end;
	            return time.value >= reservedStart && time.value < reservedEnd;
	        });
	        if (isReserved) {
	            option.disabled = true; // ����� �ð� ��Ȱ��ȭ
	        }
	        startTimeSelect.add(option);
	        endTimeSelect.add(option.cloneNode(true)); // ���� �ð����� ���� �ɼ� �߰�
	    });
	}

	populateTimeOptions();

	// ���õ� �ð��� ������Ʈ
	updateSelectedTimes();

	// ���� �ð� ���� �� ���� �ð� �ɼ� ������Ʈ
	startTimeSelect.addEventListener('change', function() {
	    const startTimeValue = startTimeSelect.value;
	    const filteredTimes = availableTimes.filter(time => time.value > startTimeValue && !reservedTimes.some(reserved => time.value >= reserved.start && time.value < reserved.end));
	    updateSelectOptions(endTimeSelect, filteredTimes);
	    updateSelectedTimes();
	});

	// ���� �ð� ���� �� ���õ� �ð��� ������Ʈ
	endTimeSelect.addEventListener('change', updateSelectedTimes);
	
	// ���� üũ�ڽ� ó��
	allDayCheckbox.addEventListener('change', function() {
	    if (allDayCheckbox.checked) {
	        startTimeSelect.value = '09:00';
	        endTimeSelect.value = '18:00';
	    }
	    updateSelectedTimes();
	});
	
	// ���õ� �ð��� ������Ʈ �Լ�
	function updateSelectedTimes() {
	    selectedTimesSelect.innerHTML = '';
	    const startTime = startTimeSelect.value;
	    const endTime = endTimeSelect.value;

	    if (!startTime || !endTime) return;

	    const startHour = parseInt(startTime.split(':')[0]);
	    const startMinute = parseInt(startTime.split(':')[1]);
	    const endHour = parseInt(endTime.split(':')[0]);
	    const endMinute = parseInt(endTime.split(':')[1]);
	
	    let currentHour = startHour;
	    let currentMinute = startMinute;
	
	    while (currentHour < endHour || (currentHour === endHour && currentMinute <= endMinute)) {
	        const time = ('0' + currentHour).slice(-2) + ':' + ('0' + currentMinute).slice(-2);
	        const option = new Option(time, time);
	        selectedTimesSelect.add(option);
	        currentMinute += 30;
	        if (currentMinute >= 60) {
	            currentHour++;
	            currentMinute -= 60;
	        }
	    }
	}
	
	// ����Ʈ �ڽ� �ɼ� ������Ʈ �Լ�
	function updateSelectOptions(selectElement, options) {
	    selectElement.innerHTML = '';
	    options.forEach(option => {
	        const opt = new Option(option.label, option.value);
	        selectElement.add(opt);
	    });
	} 
</script>
</body>
</html>