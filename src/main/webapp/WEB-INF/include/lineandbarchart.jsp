 option = {
        	    tooltip : {
        	        trigger: 'axis'
        	    },
        	    toolbox: {
        	        show : true,
        	        orient:'vertical',
        	        feature : {
        	            mark : {show: true},
        	            dataView : {show: true, readOnly: false},
        	            magicType: {show: true, type: ['line', 'bar']},
        	            restore : {show: true},
        	            saveAsImage : {show: true}
        	        }
        	    },
        	    calculable : true,
        	    legend: {
        	    	
        	        data:[${lineandbarparam_month.legendname}]
        	    },
        	    xAxis : [
        	        {
        	            type : 'category',
        	            data : [${lineandbarparam_month.xaxisdata}]
        	        }
        	    ],
        	    yAxis : [
        	        {
        	            type : 'value',
        	            name : ${lineandbarparam_month.legendname},
        	            axisLabel : {
        	                formatter: '{value}'
        	            }
        	        }  
        	    ],
        	    series : [
        	        {
        	            name:${lineandbarparam_month.legendname},
        	            type:'line',
        	            data:[
        	                ${lineandbarparam_month.serisedata}
        	            ]
        	        },
        	        {
        	            name:${lineandbarparam_month.legendname},
        	            type:'bar',
        	            data:[
        	            	${lineandbarparam_month.serisedata}
        	            ]
        	        }
        	    ]
        	};