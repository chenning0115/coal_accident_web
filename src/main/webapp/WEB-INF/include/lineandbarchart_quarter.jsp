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
        	    	
        	        data:[${lineandbarparam_quarter.legendname}]
        	    },
        	    xAxis : [
        	        {
        	            type : 'category',
        	            data : [${lineandbarparam_quarter.xaxisdata}]
        	        }
        	    ],
        	    yAxis : [
        	        {
        	            type : 'value',
        	            name : ${lineandbarparam_quarter.legendname},
        	            axisLabel : {
        	                formatter: '{value}'
        	            }
        	        }  
        	    ],
        	    series : [
        	        {
        	            name:${lineandbarparam_quarter.legendname},
        	            type:'line',
        	            data:[
        	                ${lineandbarparam_quarter.serisedata}
        	            ]
        	        },
        	        {
        	            name:${lineandbarparam_quarter.legendname},
        	            type:'bar',
        	            data:[
        	            	${lineandbarparam_quarter.serisedata}
        	            ]
        	        }
        	    ]
        	};