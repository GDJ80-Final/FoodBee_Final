<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>월별 매출 차트</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
</head>
<body>
<h1>매출 통계</h1><hr>
<canvas id="donutChart" style="max-width: 500px;"></canvas>
<div id="monthlyTotal"></div>
<div id="previousMonthTotal"></div><br>
<div>
    <label for="monthSelect">월 선택:</label>
    <select id="monthSelect"></select>
</div>
<canvas id="totalChart" style="width:100%;max-width:700px"></canvas>

<script>
$(document).ready(function() {
    const categoryName = [];
    const revenue = [];
    const barColors = ["red", "orange", "yellow", "green", "blue"];
    let preRevenue = []; // 이전 달 매출 데이터 배열

    // 현재 날짜를 가져와 1월부터 현재 달의 이전 달까지 셀렉트 박스에 추가
    const currentDate = new Date();
    const currentYear = currentDate.getFullYear(); // 현재 년도
    const currentMonth = currentDate.getMonth() + 1; // 현재 월 (0부터 시작하므로 +1)

    const monthSelect = $('#monthSelect');
    for (let month = 1; month <= currentMonth - 1; month++) {
        monthSelect.append(new Option(month + '월', month));
    }

    // 초기 데이터 호출 (현재 월 기준 전월 데이터)
    const initialMonth = currentMonth - 1;
    monthSelect.val(initialMonth);

    // 차트 생성(막대형 바 차트)
    function createBarChart(year, month) {
        new Chart("totalChart", {
            type: "bar",
            data: {
                labels: categoryName,
                datasets: [{
                    backgroundColor: barColors,
                    data: revenue,
                    barThickness: 40, // 막대 두께 설정
                    maxBarThickness: 40 // 최대 막대 두께 설정
                }]
            },
            options: {
                animation: false, // 애니메이션 비활성화
                legend: {
                    display: false, // 범례 숨기기
                },
                title: {
                    display: true,
                    text: year + '년 ' + month + '월 매출'
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

    // 차트 생성(도넛 차트)
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
                animation: false, // 애니메이션 비활성화
                title: {
                    display: true,
                    text: '카테고리별 매출 비율(%)'
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
                            let percentage = Math.round((currentValue / total) * 100); // 백분율 계산, 소수점 반올림
                            return categoryName[tooltipItem.index] + ': ' + percentage + '%';
                        }
                    }
                }
            }
        });

        // 도넛 차트 범례 설정
        let legendHtml = '';
        categoryName.forEach(function(label, index) {
            legendHtml += '<div><span style="display:inline-block;width:20px;height:10px;background-color:' + barColors[index] + ';margin-right:5px;"></span>' + label + '</div>';
        });
        $('#donutChartLegend').html(legendHtml);
    }

    // (선택된 월)과 (선택된 월 - 1) 달의 매출 데이터를 서버로부터 가져와 차트를 업데이트
    function fetchData(year, month) {
        let formattedMonth = year + '-' + ('0' + month).slice(-2); // 선택된 월 yyyy-mm 형식으로 포맷
        let formattedPreviousMonth = year + '-' + ('0' + (month - 1 === 0 ? 12 : month - 1)).slice(-2); // (선택된 월 - 1) yyyy-mm 형식으로 포맷 / ex) 1 - 1 = 0 일때 12 반환

        console.log("년월(yyyy-mm): " + formattedMonth + " and " + formattedPreviousMonth);

        // 두 개의 데이터 세트를 순차적으로 가져와 동시에 반영할 수 있음(이번달 총금액, 저번달 총금액을 구하기 위함)
        $.ajax({
            url: "${pageContext.request.contextPath}/revenue/getMonthRevenue",
            method: 'POST',
            data: { month: formattedMonth }, // 서버에 전달할 데이터(선택된 월)
            success: function(json) {
                console.log("서버에서 받아온(선택된 월) 데이터: ", json);

                categoryName.length = 0; // 배열 초기화
                revenue.length = 0; // 배열 초기화
                // 받아온값을 for문 돌려서 초기화한 매개변수에 저장
                json.forEach(function(item) {
                    categoryName.push(item.categoryName);
                    revenue.push(item.revenue);
                });

                console.log(categoryName);
                console.log(revenue);

                // (선택된 월 - 1) 데이터 요청
                $.ajax({
                    url: "${pageContext.request.contextPath}/revenue/getMonthRevenue",
                    method: 'POST',
                    data: { month: formattedPreviousMonth }, // 서버에 전달할 데이터(선택된 월 - 1)
                    success: function(preJson) {
                        console.log("서버에서 받아온(선택된 월 - 1) 데이터: ", preJson);

                        preRevenue.length = 0; // 배열 초기화
                        // 받아온값을 for문 돌려서 초기화한 매개변수에 저장
                        preJson.forEach(function(item) {
                            preRevenue.push(item.revenue);
                        });

                        // 차트 갱신
                        createBarChart(year, month); // 막대형 바 차트 갱신
                        createDonutChart(); // 도넛 차트 생성

                        // 선택된 월의 매출 합계 업데이트
                        updateMonthlyTotal(revenue.reduce((acc, val) => acc + val, 0), preRevenue.reduce((acc, val) => acc + val, 0));
                    },
                    error: function(xhr, status, error) {
                        console.error('(선택된 월 - 1) AJAX 에러:', error);
                    }
                });
            },
            error: function(xhr, status, error) {
                console.error('(선택된 월) AJAX 에러:', error);
            }
        });
    }

    // 월 선택 시 데이터 다시 불러오기
    $('#monthSelect').on('change', function() {
        let selectedMonth = $(this).val();
        fetchData(currentYear, selectedMonth); // 선택된 년도와 월에 대한 데이터 요청
    });

    // 페이지 로드 시 초기 데이터 호출
    fetchData(currentYear, initialMonth); // 현재 월의 데이터 요청

    // 월별 매출 합계를 업데이트하는 함수
    function updateMonthlyTotal(currentMonthTotal, previousMonthTotal) {
        // 매출이 가장 높은 카테고리와 가장 낮은 카테고리를 찾기 위해 배열을 복사하여 정렬
        let sortedRevenue = [...revenue].sort((a, b) => a - b);
        let highestRevenue = sortedRevenue[sortedRevenue.length - 1];
        let lowestRevenue = sortedRevenue[0];

        let highestCategory = categoryName[revenue.indexOf(highestRevenue)];
        let lowestCategory = categoryName[revenue.indexOf(lowestRevenue)];
        // 매출이 없는 경우 처리
        if (revenue.length === 0) {
            highestCategory = '-';
            lowestCategory = '-';
            highestRevenue = 0;
            lowestRevenue = 0;
        }

        // 증감액 계산 및 스타일 설정
        let changeAmount = currentMonthTotal - previousMonthTotal;
        let changeAmountStyle = changeAmount > 0 ? 'color:blue;' : (changeAmount < 0 ? 'color:red;' : 'color:black;');
        let changeAmountText = (changeAmount || changeAmount === 0) ? changeAmount + '원' : '-';

        // 월별 매출 합계를 div에 표시
        let totalHtml = '이번달 총 매출: ' + currentMonthTotal + '원<br>' +
                        '저번달 총 매출: ' + previousMonthTotal + '원<br>' +
                        '저번달 대비 증감액: <span style="' + changeAmountStyle + '">' + changeAmountText + '</span><br><br>';

        totalHtml += '실적 우수 품목: ' + highestCategory + ' (' + highestRevenue + '원)<br>';
        totalHtml += '실적 저조 품목: ' + lowestCategory + ' (' + lowestRevenue + '원)<br>';

        $('#monthlyTotal').html(totalHtml);
    }
});
</script>
</body>
</html>