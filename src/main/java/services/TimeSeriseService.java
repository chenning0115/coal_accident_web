package services;

import java.awt.Window.Type;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import javax.sound.sampled.Line;

import org.apache.coyote.http11.filters.VoidInputFilter;

import data.AttrFilterByExpression;
import data.DateFilter;
import data.ILRFilter;
import data.LRInstances;
import data.SpaceFilter;
import data.Utils;
import domain.LineandBarParam;
import domain.TimeHeatmapParam;
import junit.swingui.TestHierarchyRunView;
import statistics.DeathcountAggregation;
import statistics.timeserise.TimeSeriseStatistics;

public class TimeSeriseService {

	public static String type_all = "alltype";
	public LRInstances lrInstances;
	
	private double[] monthsumsta;
	private double[] quartersumsta;
	private double[] all_year_count;
	private double[] all_year_death;
	private double[][] all_year_month;
	

	public static LRInstances Filterlrins(String types,String provinces,LRInstances _lrInstances)
	{
		Utils.shp_china=SpaceService.class.getClassLoader().getResource("/shp/province_singlepart.shp").getPath();
		try{
			LRInstances resultlr = null;
			HashMap<String, String> map = services.Utils.getProvinceMap();
			String str_pro = provinces;
			if(str_pro==null||str_pro.equals("all"))
			{
				resultlr = _lrInstances;
			}
			else{
				String[] strs_pro = str_pro.split(",");
				StringBuffer buffer_pro = new StringBuffer();
				for(int i=0;i<strs_pro.length-1;i++)
				{
					buffer_pro.append("NAME_1='"+map.get(strs_pro[i])+"' OR ");
				}
				buffer_pro.append("NAME_1='"+map.get(strs_pro[strs_pro.length-1])+"'");
				System.out.println(buffer_pro.toString());
				SpaceFilter spaceFilter = new SpaceFilter(_lrInstances);
				spaceFilter.setCQL(buffer_pro.toString());
				System.out.println(buffer_pro.toString());
				resultlr = spaceFilter.LRProcess(_lrInstances);
			}
			if(types!=null&&(!types.equals("all")))
			{
				String[] strs_type = types.split(",");
				StringBuffer buffer_type = new StringBuffer();
				for(int i=0;i<strs_type.length-1;i++)
				{
					buffer_type.append("(ATT7 is '"+strs_type[i]+"') or");
				}
				buffer_type.append("(ATT7 is '"+strs_type[strs_type.length-1]+"')");
				System.out.println(buffer_type.toString());
				ILRFilter filter = new AttrFilterByExpression(resultlr, buffer_type.toString());
				resultlr = filter.LRProcess(resultlr);
			}
			
			return resultlr;
			
		}catch(Exception e)
		{
			e.printStackTrace();
			return _lrInstances;
		}
	}
	
	public TimeSeriseService(LRInstances _lLrInstances)
	{
		this.lrInstances = _lLrInstances;
	}

	public void monthandquartesta()
	{                                 
		try{
			TimeSeriseStatistics tSeriseStatistics = new TimeSeriseStatistics(lrInstances);
			double[] result = tSeriseStatistics.Statisticbyinter(TimeSeriseStatistics.LRMonth);
			int startmonth = tSeriseStatistics.Getstartdatesign(TimeSeriseStatistics.LRMonth);
			int startindex = ((12-startmonth)+1)%12;
			int loopnum = (result.length-startindex+1)/12*12;
			double[] res2 = new double[12];
			for(int i=0;i<loopnum;i++)
			{
				int index = i+startindex;
				if(index>=result.length) break;
				res2[i%12]+=result[index];
			}
			this.monthsumsta = res2;
			this.quartersumsta = new double[4];
			for(int i=0;i<12;i++)
			{
				this.quartersumsta[i/3]+=this.monthsumsta[i];
			}
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	public LineandBarParam all_monthsum()
	{
		
		StringBuffer serisedatabuffer = new StringBuffer();
		StringBuffer xaxisebuffer = new StringBuffer();
		for(int i=0;i<this.monthsumsta.length;i++)
		{
			serisedatabuffer.append(""+(int)this.monthsumsta[i]+",");
		}
		for(int i=0;i<12;i++)
		{
			xaxisebuffer.append("'"+(i+1)+"',");
		}
		return new LineandBarParam("'月度事故数累计'", xaxisebuffer.toString(), serisedatabuffer.toString());
	}
	
	public LineandBarParam all_quartersum()
	{
		StringBuffer serisedatabuffer = new StringBuffer();
		StringBuffer xaxisebuffer = new StringBuffer();
		for(int i=0;i<this.quartersumsta.length;i++)
		{
			serisedatabuffer.append(""+(int)this.quartersumsta[i]+",");
		}
		for(int i=0;i<4;i++)
		{
			xaxisebuffer.append("'"+(i+1)+"',");
		}
		return new LineandBarParam("'季度事故数累计'", xaxisebuffer.toString(), serisedatabuffer.toString());
	}
	
	public String all_daysta(String sign,int num)
	{
		try{
		double[] result = null;
		TimeSeriseStatistics tSeriseStatistics = new TimeSeriseStatistics(lrInstances);
		int startyear = tSeriseStatistics.Getstartdatesign(TimeSeriseStatistics.LRYear);
		int startmonth = tSeriseStatistics.Getstartdatesign(TimeSeriseStatistics.LRMonth);
		int date = tSeriseStatistics.Getstartdatesign(TimeSeriseStatistics.LRDate);
		if(sign.equals("a"))
		{
			try {
				result = tSeriseStatistics.StatisticAverage(num);
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else{
			int lrtype =TimeSeriseStatistics.LRMonth;
			
			switch (sign) {
			case "q":
				lrtype = TimeSeriseStatistics.LRQuater;
				date = 1;
				break;
			case "m":
				lrtype = TimeSeriseStatistics.LRMonth;
				date = 1;
				break;
			case "d":
				lrtype = TimeSeriseStatistics.LRDate;
				break;
			default:
				break;
			}
			result = tSeriseStatistics.Statisticbyinter(lrtype);
		}
		System.out.println("reusltlen = "+result.length);
		
			StringBuffer buffer = new StringBuffer("{\"sign\":\""+sign+"\",\"year\":"+startyear+",\"month\":"+startmonth+",\"day\":"+date+",\"len\":"+result.length+",\"data\":[");
			for(int i=0;i<result.length;i++)
			{
				buffer.append(""+result[i]+",");
			}
			buffer.append("]}");
			//System.out.println(buffer.toString());
			return buffer.toString();
		}catch(Exception e)
		{
			e.printStackTrace();
			return null;
		}
	}
	
	public TimeHeatmapParam all_yearmonth_sta()
	{
		try {
			TimeSeriseStatistics tSeriseStatistics = new TimeSeriseStatistics(lrInstances);
			int startyear = tSeriseStatistics.Getstartdatesign(TimeSeriseStatistics.LRYear);
			int startmonth = tSeriseStatistics.Getstartdatesign(TimeSeriseStatistics.LRMonth);
			int endyear = tSeriseStatistics.getEnddatesign(TimeSeriseStatistics.LRYear);
			int endmonth = tSeriseStatistics.getEnddatesign(TimeSeriseStatistics.LRMonth);
			System.out.println("startyear="+startyear+"endyear="+endyear+"startmonth="
					+ startmonth+"endmonth="+endmonth);
			double[] monthval = tSeriseStatistics.Statisticbyinter(TimeSeriseStatistics.LRMonth);
			all_year_month = new double[endyear-startyear+1][12];
			System.out.println("len="+monthval.length);
			for(int i=0;i<monthval.length;i++)
			{
				int tempmon = (i+startmonth-1)%12;
				int tempyear = (i+startmonth-1)/12;
				
				all_year_month[tempyear][tempmon] = monthval[i];
			}
			
			int row = this.all_year_month.length;
			int col = this.all_year_month[0].length;
			for(int i=0;i<col;i++)
			{
				int tempsum = 0;
				for(int j=0;j<row;j++)
				{
					tempsum+=all_year_month[j][i];
				}
				System.out.print(tempsum+",");
			}
			int[][] newdata = new int[row][col];
			double allmax = Double.MIN_VALUE;
			double allmin = Double.MAX_VALUE;
			for(int i = 0;i<row;i++)
			{
				double max = Double.MIN_VALUE;
				double min = Double.MAX_VALUE;
				for(int j = 0;j<col;j++)
				{
					if(all_year_month[i][j]>max) max = all_year_month[i][j];
					if(all_year_month[i][j]<min) min = all_year_month[i][j];
			 	}
				double inter = max - min;
				for(int j=0;j<col;j++)
				{
					//newdata[i][j] =(int) all_year_month[i][j];
					newdata[i][j] =(int) ((all_year_month[i][j]-min)/inter*100);
					
					//if(newdata[i][j]==0) newdata[i][j]=1; 
					
				}
				//if(max>allmax) allmax = max;
				//if(min<allmin) allmin = min;
			}
			allmax = 100;
			allmin = 0;
			  TimeHeatmapParam param = new TimeHeatmapParam();
			  StringBuffer rowbuffer = new StringBuffer();
			  StringBuffer colbuffer = new StringBuffer();
			  StringBuffer databuffer = new StringBuffer();
			  for(int i =0;i<row;i++) 
			  {
				  rowbuffer.append("'"+(startyear+i)+"',");
			  }
			  for(int i=0;i<col;i++)
			  {
				  colbuffer.append("'"+(startmonth+i)+"',");
			  }
			  for(int i=0;i<row;i++)
			  {
				  for(int j=0;j<col;j++)
				  {
					  databuffer.append("["+(i)+","+j+","+newdata[i][j]+"],");
				  }
			  }
			  return new TimeHeatmapParam(rowbuffer.toString(), colbuffer.toString(), databuffer.toString(),(int)allmax,(int)allmin);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	public  void all_year_sta()
	{
		try {
			TimeSeriseStatistics tSeriseStatistics = new TimeSeriseStatistics(lrInstances);
			System.out.println(tSeriseStatistics.Getstartdatesign(TimeSeriseStatistics.LRYear));
			all_year_count = tSeriseStatistics.Statisticbyinter(TimeSeriseStatistics.LRYear);
			tSeriseStatistics.SetLRIAggregation(new DeathcountAggregation(4));
			all_year_death  = tSeriseStatistics.Statisticbyinter(TimeSeriseStatistics.LRYear);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}
		
	}
	public double[] get_all_year_count()
	{
		return all_year_count;
	}
	public double[] get_all_year_death()
	{
		return all_year_death;
	}
	
	
}
