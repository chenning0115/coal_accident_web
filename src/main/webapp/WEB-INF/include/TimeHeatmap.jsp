<script type="text/javascript"> 
        // 基于准备好的dom，初始化echarts图表
        var myChart2 = echarts.init(document.getElementById('timeheatmap')); 
        var hours = [ '1', '2', '3', '4', '5', '6',
                     '7', '8', '9','10','11','12',
                     '1p', '2p', '3p', '4p', '5p',
                     '6p', '7p', '8p', '9p', '10p', '11p','12p'];
             var days = [${heatmapparam.str_row}];

             var data = [${heatmapparam.str_data}];
             data = data.map(function (item) {
                 return [item[1], item[0], item[2] || '-'];
             });

             option = {
                 tooltip: {
                     position: 'top'
                 },
                 animation: false,
                 grid: {
                     height: '50%',
                     y: '10%'
                 },
                 xAxis: {
                     type: 'category',
                     data: hours
                 },
                 yAxis: {
                     type: 'category',
                     data: days
                 },
                 visualMap: {
                     min: ${heatmapparam.min},
                     max: ${heatmapparam.max},
                     calculable: true,
                     orient: 'horizontal',
                     left: 'center',
                     bottom: '15%'
                 },
                 series: [{
                     name: 'Punch Card',
                     type: 'heatmap',
                     data: data,
                     label: {
                         normal: {
                             show: true
                         }
                     },
                     itemStyle: {
                         emphasis: {
                             shadowBlur: 10,
                             shadowColor: 'rgba(0, 0, 0, 0.5)'
                         }
                     }
                 }]
             };
             myChart2.setOption(option);
        </script>