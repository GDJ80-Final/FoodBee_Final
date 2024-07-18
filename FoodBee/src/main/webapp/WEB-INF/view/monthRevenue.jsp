<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>���� ���� ��Ʈ</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
</head>
<body>
<h1>���� ���</h1><hr>
<canvas id="donutChart" style="max-width: 500px;"></canvas>
<div id="monthlyTotal"></div>
<div id="previousMonthTotal"></div><br>
<div>
    <label for="monthSelect">�� ����:</label>
    <select id="monthSelect">
        <option value="1">1��</option>
        <option value="2">2��</option>
        <option value="3">3��</option>
        <option value="4">4��</option>
        <option value="5">5��</option>
        <option value="6">6��</option>
        <option value="7">7��</option>
        <option value="8">8��</option>
        <option value="9">9��</option>
        <option value="10">10��</option>
        <option value="11">11��</option>
        <option value="12">12��</option>
    </select>
</div>
<canvas id="totalChart" style="width:100%;max-width:700px"></canvas>

<script>
$(document).ready(function() {
    const categoryName = [];
    const revenue = [];
    const barColors = ["red", "orange", "yellow", "green", "blue"];
    
    // ��Ʈ ����(������ �� ��Ʈ)
	function createBarChart(year, month) {
	    new Chart("totalChart", {
	        type: "bar",
	        data: {
	            labels: categoryName,
	            datasets: [{
	                backgroundColor: barColors,
	                data: revenue
	            }]
	        },
	        options: {
	            animation: false, // �ִϸ��̼� ��Ȱ��ȭ
	            legend: {
	                display: false, // ���� �����
	            },
	            title: {
	                display: true,
	                text: year + '�� ' + month + '�� ����'
	            },
	            scales: {
	                yAxes: [{
	                    ticks: {
	                        beginAtZero: true
	                    }
	                }]
	            }
	        }
	    });
	}
    
    // ��Ʈ ����(���� ��Ʈ)
    function createDonutChart() {
    	let ctx = document.getElementById('donutChart').getContext('2d');
        let myDonutChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: categoryName,
                datasets: [{
                    backgroundColor: barColors,
                    data: revenue
                }]
            },
            options: {
            	animation: false, // �ִϸ��̼� ��Ȱ��ȭ
                title: {
                    display: true,
                    text: 'ī�װ��� ���� ����(%)'
                },
                legend: {
                    display: true,
                    position: 'right'
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {
                            let dataset = data.datasets[tooltipItem.datasetIndex];
                            let total = dataset.data.reduce(function(previousValue, currentValue, currentIndex, array) {
                                return previousValue + currentValue;
                            });
                            let currentValue = dataset.data[tooltipItem.index];
                            let percentage = Math.round((currentValue / total) * 100); // ����� ���, �Ҽ��� �ݿø�
                            return categoryName[tooltipItem.index] + ': ' + percentage + '%';
                        }
                    }
                }
            }
        });

        // ���� ��Ʈ ���� ����
        let legendHtml = '';
        categoryName.forEach(function(label, index) {
            legendHtml += '<div><span style="display:inline-block;width:20px;height:10px;background-color:' + barColors[index] + ';margin-right:5px;"></span>' + label + '</div>';
        });
        $('#donutChartLegend').html(legendHtml);
    }
	// (���õ� ��)�� (���õ� �� - 1) ���� ���� �����͸� �����κ��� ������ ��Ʈ�� ������Ʈ
    function fetchData(year, month) {		
        let formattedMonth = year + '-' + ('0' + month).slice(-2); // ���õ� �� yyyy-mm �������� ����
        let formattedPreviousMonth = year + '-' + ('0' + (month - 1 === 0 ? 12 : month - 1)).slice(-2); // (���õ� �� - 1) yyyy-mm �������� ���� / ex) 1 - 1 = 0 �϶� 12 ��ȯ
        
        console.log("���(yyyy-mm): " + formattedMonth + " and " + formattedPreviousMonth);
        
        // �� ���� ������ ��Ʈ�� ���������� ������ ���ÿ� �ݿ��� �� ����(�̹��� �ѱݾ�, ������ �ѱݾ��� ���ϱ� ����)
        $.ajax({
            url: "${pageContext.request.contextPath}/getMonthRevenue",
            method: 'POST',
            data: { month: formattedMonth }, // ������ ������ ������(���õ� ��)
            
            success: function(json) {
                console.log("�������� �޾ƿ�(���õ� ��) ������: ", json);
                
                categoryName.length = 0; // �迭 �ʱ�ȭ
                revenue.length = 0; // �迭 �ʱ�ȭ
                // �޾ƿ°��� for�� ������ �ʱ�ȭ�� �Ű������� ����
                json.forEach(function(item) {
                    categoryName.push(item.categoryName);
                    revenue.push(item.revenue);
                });
                
                console.log(categoryName);
                console.log(revenue);

                // (���õ� �� - 1) ������ ��û
                $.ajax({
                    url: "${pageContext.request.contextPath}/getMonthRevenue",
                    method: 'POST',
                    data: { month: formattedPreviousMonth }, // ������ ������ ������(���õ� �� - 1)
                    success: function(preJson) {
                        console.log("�������� �޾ƿ�(���õ� �� - 1) ������: ", preJson);
                        
                        preRevenue.length = 0; // �迭 �ʱ�ȭ
                     	// �޾ƿ°��� for�� ������ �ʱ�ȭ�� �Ű������� ����
                        preJson.forEach(function(item) {
                            preRevenue.push(item.revenue);
                        });

                        // ��Ʈ ����
                        createBarChart(year, month); // ������ �� ��Ʈ ����
                        createDonutChart(); // ���� ��Ʈ ����

                        // ���õ� ���� ���� �հ� ������Ʈ
                        updateMonthlyTotal(revenue.reduce((acc, val) => acc + val, 0), preRevenue.reduce((acc, val) => acc + val, 0));
                    },
                    error: function(xhr, status, error) {
                        console.error('(���õ� �� - 1) AJAX ����:', error);
                    }
                });
            },
            
            error: function(xhr, status, error) {
                console.error('(���õ� ��) AJAX ����:', error);
            }
        });
    }
    // �ʱ� ������ ȣ�� (���� �� ���� ���� ������)
    const currentDate = new Date();
    let currentYear = currentDate.getFullYear(); // �⵵ ��������
    let currentMonth = currentDate.getMonth(); // ���� �� ������ ��������
    let preRevenue = []; // ���� �� ���� ������ �迭
    
    // ���� ���� ���� �⺻ ���ð����� ����
    currentMonth = currentMonth === 0 ? 12 : currentMonth; // 1���� ��� 12���� ����
    $('#monthSelect').val(currentMonth);
    
    // �� ���� �� ������ �ٽ� �ҷ�����
    $('#monthSelect').on('change', function() {
        let selectedMonth = $(this).val();
        fetchData(currentYear, selectedMonth); // ���õ� �⵵�� ���� ���� ������ ��û
    });

    // ������ �ε� �� �ʱ� ������ ȣ��
    fetchData(currentYear, currentMonth); // ���� ���� ������ ��û
    
    // ���� ���� �հ踦 ������Ʈ�ϴ� �Լ�
    function updateMonthlyTotal(currentMonthTotal, previousMonthTotal) {
    // ������ ���� ���� ī�װ��� ���� ���� ī�װ��� ã�� ���� �迭�� �����Ͽ� ����
    let sortedRevenue = [...revenue].sort((a, b) => a - b);
    let highestRevenue = sortedRevenue[sortedRevenue.length - 1];
    let lowestRevenue = sortedRevenue[0];

    let highestCategory = categoryName[revenue.indexOf(highestRevenue)];
    let lowestCategory = categoryName[revenue.indexOf(lowestRevenue)];

    // ���� ���� �հ踦 div�� ǥ��
    let totalHtml = '�̹��� �� ����: ' + currentMonthTotal + '��<br>' +
                    '������ �� ����: ' + previousMonthTotal + '��<br>' +
                    '������ ��� ������: ' + (currentMonthTotal - previousMonthTotal) + '��<br><br>';

    totalHtml += '���� ��� ǰ��: ' + highestCategory + ' (' + highestRevenue + '��)<br>';
    totalHtml += '���� ���� ǰ��: ' + lowestCategory + ' (' + lowestRevenue + '��)<br>';

    $('#monthlyTotal').html(totalHtml);
}
});
</script>
</body>
</html>