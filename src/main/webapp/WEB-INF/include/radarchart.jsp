<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">
<!--

//-->

function radarfun(radardata) {
    radarChart.hideLoading();
    radardata = eval("("+radardata+")");
var dataBJ = radardata.data;
var lineStyle = {
    normal: {
        width: 1,
        opacity: 1
    }
};

option = {
    
    title: {
        text: '煤矿事故类型按月份统计图',
        left: 'left',
        textStyle: {
            color: '#000'
        }
    },
    legend: {
        bottom: 5,
        data: ['煤矿事故类型'],
        itemGap: 20,
        textStyle: {
            color: '#fff',
            fontSize: 14
        },
        selectedMode: 'single'
    },
    // visualMap: {
    //     show: true,
    //     min: 0,
    //     max: 20,
    //     dimension: 6,
    //     inRange: {
    //         colorLightness: [0.5, 0.8]
    //     }
    // },
    radar: {
        indicator: [ 
            {name: '顶板事故', max: radardata.dingban},
            {name: '瓦斯事故', max: radardata.wasi},
            {name: '水灾事故', max: radardata.shuizai},
            {name: '火灾事故', max: radardata.huozai},
            {name: '放炮事故', max: radardata.fangpao},
            {name: '机电事故', max: radardata.jidian},
            {name: '运输事故', max: radardata.yunshu},
            {name: '其他事故', max: radardata.qita}
        ],
        shape: 'circle',
        splitNumber: 5,
        name: {
            textStyle: {
                color: 'rgb(0, 0, 0)'
            }
        },
        splitLine: {
            lineStyle: {
                color: [
                    'rgba(0, 0, 255, 0.8)', 'rgba(0,0,255, 0.7)',
                    'rgba(0, 0, 255, 0.6)', 'rgba(0,0,255, 0.5)',
                    'rgba(0, 0, 255, 0.4)', 'rgba(0,0,255, 0.3)',
                ]
            }
        },
        splitArea: {
            show: false
        },
        axisLine: {
            lineStyle: {
                color: 'rgba(0, 0, 0, 0.8)'
            }
        }
    },
    series: [
        {
            name: '煤矿事故类型统计',
            type: 'radar',
            lineStyle: lineStyle,
            data: dataBJ,
            symbol: 'none',
            itemStyle: {
                normal: {
                    color: '#F9713C'
                }
            },
            areaStyle: {
                normal: {
                    opacity: 0.1
                }
            }
        }
    ]
};
radarChart.setOption(option);
}

</script>