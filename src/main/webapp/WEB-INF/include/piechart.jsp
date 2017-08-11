<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">


function piefun(piedata) {
	piechart.hideLoading();
    piedata = eval("("+piedata+")");
option = {
    tooltip: {
        trigger: 'item',
        formatter: "{a} <br/>{b}: {c} ({d}%)"
    },
    title: {
        text: '煤矿事故类型累计占比',
        left: 'left',
        textStyle: {
            color: '#000'
        }
    },
    legend: {
        orient: 'vertical',
        x: 'right',
        data:['顶板事故','瓦斯事故','水灾事故','火灾事故','放炮事故','机电事故','运输事故','其他事故']
    },
    series: [
        {
            name:'访问来源',
            type:'pie',
            radius: ['50%', '70%'],
            avoidLabelOverlap: false,
            label: {
                normal: {
                    show: false,
                    position: 'center'
                },
                emphasis: {
                    show: true,
                    textStyle: {
                        fontSize: '30',
                        fontWeight: 'bold'
                    }
                }
            },
            labelLine: {
                normal: {
                    show: false
                }
            },
            data:[
                {value:piedata.pie_dingban, name:'顶板事故'},
                {value:piedata.pie_wasi, name:'瓦斯事故'},
                {value:piedata.pie_shuizai, name:'水灾事故'},
                {value:piedata.pie_huozai, name:'火灾事故'},
                {value:piedata.pie_fangpao, name:'放炮事故'},
                {value:piedata.pie_jidian, name:'机电事故'},
                {value:piedata.pie_yunshu, name:'运输事故'},
                {value:piedata.pie_qita, name:'其他事故'},
            ]
        }
    ]
};
piechart.setOption(option);
}

</script>