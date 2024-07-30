<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>FoodBee:보낸 쪽지함</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
	<div id="main-wrapper">
		<jsp:include page="/WEB-INF/view/header.jsp"></jsp:include>
		
		<jsp:include page="/WEB-INF/view/sidebar.jsp"></jsp:include>
	        <!--**********************************
	            Content body start
	        ***********************************-->
	  	<div class="content-body">
			<button type="button" name="readYN" id="all" value="all">전체</button>
			<button type="button" name="readYN" id="Y" value="Y">읽음</button>
			<button type="button" name="readYN" id="N" value="N">안 읽음</button>
			
			<button type="button" name="toTrash" id="toTrash">휴지통</button>
			<a href="${pageContext.request.contextPath}/msg/trashMsgBox">휴지통으로 이동</a>
			<table border="1">
				<thead>
					<tr>
						<td><input type="checkbox" id="selectAll"></td>
						<td>쪽지번호</td>
						<td>받는이</td>
						<td>제목</td>
						<td>보낸일시</td>
						<td>읽음여부</td>
					</tr>
				</thead>
				<tbody id="msgTableBody">
				
				</tbody>
			</table>
			
			<div id="page">
		        <button type="button" id="first">First</button>
		        <button type="button" id="pre">◁</button>
		        <button type="button" id="next">▶</button>
		        <button type="button" id="last">Last</button>
			</div>
		</div>
	 	<!--**********************************
	            Content body end
	    ***********************************-->
 	</div>
 	<jsp:include page="/WEB-INF/view/footer.jsp"></jsp:include>
 	



<script>

	let currentPage = 1;
	let lastPage = 1;
	
	   $(document).ready(function(){
		   //읽음/안읽음 여부에 따라 받은 쪽지함 분기 + 페이징 추가 
		   let readYN = 'all';
	
	       function loadMsg(readYN, page){
	           $.ajax({
	               url : '${pageContext.request.contextPath}/msg/sentMsgBox',
	               method: 'post',
	               data : {
	                   readYN : readYN,
	                   currentPage : page
	               },
	               success:function(json){
	                   console.log(json);
	
	                   lastPage = json.lastPage;
	                   console.log('Current Page =>', currentPage, 'Last Page =>', lastPage);
	
	                   $('#msgTableBody').empty();
	                   json.msgList.forEach(function(item){
	                       console.log(item);
	                       $('#msgTableBody').append('<tr>' +
	                           '<td><input type="checkbox" name="msgNo" value="'+ item.msgNo +'"></td>'+
	                           '<td>'+ item.msgOrder + '</td>'+
	                           '<td>'+ item.empName + '</td>'+
	                           '<td><a href="${pageContext.request.contextPath}/msg/msgOne?msgNo='+
	                                   item.msgNo +'">'+ item.title + '</a></td>'+
	                           '<td>'+ item.createDatetime + '</td>'+
	                           '<td id="readYN">'+ item.readYN + '</td>'+
	                           '</tr>'
	                       );
	                   });
					
	               		// 페이지 변경 시 전체선택 체크박스는 초기화 
	                   $('#selectAll').prop('checked', false);
	               		
	                   updateBtnState();
	               }
	           });
	       }
			//페이징 버튼 활성화
	       function updateBtnState() {
	           console.log("update");
	           $('#pre').prop('disabled', currentPage === 1);
	           $('#next').prop('disabled', currentPage === lastPage);
	           $('#first').prop('disabled', currentPage === 1);
	           $('#last').prop('disabled', currentPage === lastPage);
	       }
			//이전 
	       $('#pre').click(function() {
	           if (currentPage > 1) {
	               currentPage -= 1;
	               loadMsg(readYN, currentPage);
	           }
	       });
			//다음 
	       $('#next').click(function() {
	           if (currentPage < lastPage) {
	               currentPage += 1;
	               loadMsg(readYN, currentPage);
	           }
	       });
			//첫페이지 이동 
	       $('#first').click(function() {
	           if (currentPage > 1) {
	               currentPage = 1;
	               loadMsg(readYN, currentPage);
	           }
	       });
			//마지막 페이지 
	       $('#last').click(function() {
	           if (currentPage < lastPage) {
	               currentPage = lastPage;
	               loadMsg(readYN, currentPage);
	           }
	       });
		   
		   
	     	//카데고리 분기
	       $('#all').click(function(){
	           readYN = 'all';
	           currentPage = 1;
	           loadMsg(readYN, currentPage); // 전체목록
	       });
	
	       $('#Y').click(function(){
	           readYN = 'Y';
	           currentPage = 1;
	           loadMsg(readYN, currentPage); // 읽은 쪽지
	       });
	
	       $('#N').click(function(){
	           readYN = 'N';
	           currentPage = 1;
	           loadMsg(readYN, currentPage); // 안읽은 쪽지
	       });
	
	       // 페이지 첫 로드 시 전체 목록 불러오기
	       loadMsg(readYN, currentPage);
			
			// 쪽지 전체 선택 
			$('#selectAll').click(function(){
				// 전체 선택 체크 여부 확인
				let checked = $('#selectAll').is(':checked');
				// 전체 선택 여부 true => checked 속성 true 즉 추가 
				if(checked){
					$('input:checkbox').prop('checked',true);
				}else{
					// 전체 선택 여부 false => checked 속성 false 즉 제거
					$('input:checkbox').prop('checked',false);
				}
			
			});
			
			// 체크박스 클릭 시 전체체크박스 수 와 체크된 값을 비교 
			// 일치하지 않다면 전체체크 checked, false
			// 일치하다면 전체체크되었다는 말이므로 checked,true 
			
			// 리스트가 동적으로 생성되고 있기 때문에 document.on을 쓰는 게 더 적합
			$(document).on('click', 'input[name="msgNo"]', function() {
				let total = $('input[name="msgNo"]').length;
				let checked = $('input[name="msgNo"]:checked').length;

				if(total != checked) {
					$("#selectAll").prop("checked", false);
				}else{
					$("#selectAll").prop("checked", true); 
				}
			});
	        
	       
	       
	       
	     	//휴지통 이동
		   $('#toTrash').click(function(){
			   let selectedMsgNos = [];
			  //name이  msgNo+체크된 값만 가져오기 => 배열에 하나씩 넣기 
			  $('[name="msgNo"]:checked').each(function() {
				  selectedMsgNos.push($(this).val());
	        	});
			  console.log(selectedMsgNos[0]);
			   if(selectedMsgNos.length > 0){
				   $.ajax({
					   url: '${pageContext.request.contextPath}/msg/toTrash',
					   method: 'post',
					   traditional:true, 
					   data:{
						   msgNos:selectedMsgNos
					   },
					   success:function(){
						   alert('쪽지가 휴지통으로 이동하였습니다.')
						   loadMsg("all"); // 이동 후 전체 목록 새로고침
					   }
			   })
			   }else {
				   alert('휴지통으로 이동할 쪽지를 선택해주세요.');
			   }
			   
		   });
		
		   
	   })
</script>
</body>
</html>