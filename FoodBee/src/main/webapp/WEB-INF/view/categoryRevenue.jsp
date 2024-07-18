<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
</head>
<body>
<h1>2024�� ������Ȳ</h1>
<!-- ���� ������ ���� ����Ʈ �ڽ� -->
<select id="selectYear" onchange="fetchTotalData()">
    <option value="2022">2022��</option>
    <option value="2023">2023��</option>
    <option value="2024" selected>2024��</option>
</select>

<div id="categoryButtons">
    <button onclick="fetchTotalData()">��ü</button>
    <button onclick="fetchCategoryData('�����')">�����</button>
    <button onclick="fetchCategoryData('��/�')">��/�</button>
    <button onclick="fetchCategoryData('��/����')">��/����</button>
    <button onclick="fetchCategoryData('����/�ַ�')">����/�ַ�</button>
    <button onclick="fetchCategoryData('û��')">û��</button>
</div>
<canvas id="lineChart" style="width:100%;max-width:700px"></canvas>
<script>
//��ü �����͸� ���� ����
let allData = [];

// ��ü �����͸� �������� �Լ�
function fetchTotalData() {
    const selectedYear = document.getElementById('selectYear').value;

    $.ajax({
        url: "${pageContext.request.contextPath}/getTotalRevenue",
        method: 'POST',
        dataType: 'json',
        data: { year: selectedYear },
        success: function(data) {
            console.log(selectedYear + " ��ü ������:", data);
            allData = data;
            updateChart(allData);
        },
        error: function(xhr, status, error) {
            console.error(selectedYear + " ��ü ������ AJAX ����:", error);
        }
    });
}

// ī�װ��� �����͸� �������� �Լ�
function fetchCategoryData(category) {
    const selectedYear = document.getElementById('selectYear').value;

    $.ajax({
        url: "${pageContext.request.contextPath}/getCategoryRevenue",
        method: 'POST',
        dataType: 'json',
        data: { year: selectedYear, category: category },
        success: function(data) {
            console.log(category + " ī�װ� ������:", data);
            updateChart(data);
        },
        error: function(xhr, status, error) {
            console.error(category + " ī�װ� ������ AJAX ����:", error);
        }
    });
}

// ��Ʈ ������Ʈ �Լ�
function updateChart(data) {
    if (data && data.length > 0) {
        // �����͸� �����Ͽ� ī�װ����� ���� ������ �и�
        const categories = [...new Set(data.map(item => item.categoryName))];
        const months = [...new Set(data.map(item => item.referenceMonth))].sort();
        const revenueData = categories.map(category => {
            return months.map(month => {
                const record = data.find(item => item.categoryName === category && item.referenceMonth === month);
                return record ? record.revenue : 0;
            });
        });

        console.log("Categories:", categories);
        console.log("Revenue Data:", revenueData);
        console.log("Months:", months);

        // ��Ʈ ���� �ڵ�
        const ctx = document.getElementById('lineChart').getContext('2d');
        const lineChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: months,
                datasets: categories.map((category, index) => ({
                    label: category,
                    data: revenueData[index],
                    fill: false,
                    borderColor: getRandomColor(),
                    tension: 0.1
                }))
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                },
                scales: {
                    x: {
                        title: {
                            display: true,
                            text: '��'
                        }
                    },
                    y: {
                        title: {
                            display: true,
                            text: '�����'
                        }
                    }
                }
            }
        });
    } else {
        console.error('�����Ͱ� ��� �ֽ��ϴ�.');
    }
}

// ���� ���� ���� �Լ�
function getRandomColor() {
    const letters = '0123456789ABCDEF';
    let color = '#';
    for (let i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

// ������ �ε� �� �ʱ� ������ ȣ�� (��ü ī�װ� �����ͷ�)
$(document).ready(function() {
    fetchTotalData(); // ������ �ε� �� ���õ� ������ ��ü ī�װ� �����͸� ���� �޾ƿ�
});
</script>
</body>
</html>