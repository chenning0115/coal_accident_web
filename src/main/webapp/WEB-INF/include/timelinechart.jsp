<script type="text/javascript"> 
<%@ include file="./dateadd.jsp" %>

var myChart = echarts.init(document.getElementById('daychart')); 
myChart.showLoading();
function timelinefun(daydata) { 
    myChart.hideLoading();
    daydata = eval("("+daydata+")");
    base = new Date(daydata.year,daydata.month-1,daydata.day);
    oneDay = 24 * 3600 * 1000;
    data = daydata.data;
    date=[];
    date.push([daydata.year, daydata.month, daydata.day].join('-'));
    for (var i = 1; i < daydata.len; i++) {
        var now =  DateAdd(daydata.sign,1,base);
       
        date.push([now.getFullYear(), now.getMonth() + 1, now.getDate()].join('-'));
    }
    
    option = {
    	    tooltip: {
    	        trigger: 'axis'
    	    },
    	    title: {
    	        left: 'center',
    	        text: 'coalmine accidents per day statistics',
    	    },
    	    legend: {
    	        top: 'bottom',
    	        data:['coalmine accidents']
    	    },
    	    toolbox: {
    	        show: true,
    	        orient:'vertical',
    	        feature: {
    	            dataView: {show: true, readOnly: false},
    	            magicType: {show: true, type: ['line', 'bar', 'stack', 'tiled']},
    	            restore: {show: true},
    	            saveAsImage: {show: true}
    	        }
    	    },
    	    xAxis: {
    	        type: 'category',
    	        boundaryGap: false,
    	        data: date
    	    },
    	    yAxis: {
    	        type: 'value',
    	        boundaryGap: [0, '100%']
    	    },
    	    dataZoom: [{
    	        type: 'inside',
    	        start: 0,
    	        end: 10
    	    }, {
    	        start: 0,
    	        end: 10
    	    }],
    	    series: [
    	        {
    	            name:'coalmine accidents',
    	            type:'line',
    	            smooth:true,
    	            symbol: 'none',
    	            sampling: 'average',
    	            itemStyle: {
    	                normal: {
    	                    color: 'rgb(255, 70, 131)'
    	                }
    	            },
    	            areaStyle: {
    	                normal: {
    	                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
    	                        offset: 0,
    	                        color: 'rgb(255, 158, 68)'
    	                    }, {
    	                        offset: 1,
    	                        color: 'rgb(255, 70, 131)'
    	                    }])
    	                }
    	            },
    	            data: data
    	        }
    	    ]
    	};
    	   myChart.setOption(option);

    }
        </script>