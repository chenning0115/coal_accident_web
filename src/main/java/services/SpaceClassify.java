package services;

import java.io.ByteArrayOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

import org.json.JSONWriter;

import analyse.cluster.FastSearchBasedGeo2;
import data.LRInstances;
import data.SpaceFilter;
import statistics.AttributeBasedCount;
import statistics.timeserise.TimeSeriseStatistics;

public class SpaceClassify {
	LRInstances lrInstances;
	
	public SpaceClassify(LRInstances _lLrInstances)
	{
		this.lrInstances = _lLrInstances;
	}
	
	public LRInstances FastSearchClassify(double r,int minptsaspoints,int numclass)
	{
		FastSearchBasedGeo2 fastSearchBasedGeo2 = new FastSearchBasedGeo2(this.lrInstances, r, minptsaspoints, numclass);
		return fastSearchBasedGeo2.runLRCluster("classify");
	}

	/*
	 * 对指定的lrinstances数据生成分类别的统计数据
	 */
	public String classifiedwithtimeandtype()throws Exception
	{
		//System.out.println("spaced="+ins_spacefiltered.getsign_attr_date());
		//filter instances by every type
		String[] typenames = new String[]{"dingban","wasi","shuizai","huozai","fangpao","jidian","yunshu","qita"};
		double[][] table = new double[typenames.length][];
		for(int i =0;i<typenames.length;i++)
		{
			TimeSeriseStatistics timesta = new TimeSeriseStatistics(this.lrInstances);
			timesta.SetLRIAggregation(new AttributeBasedCount(6,typenames[i]));
			table[i] = timesta.Statisticbyinter(TimeSeriseStatistics.LRMonth);
		} 
		for(int i=0;i<typenames.length;i++)
		{
			System.out.println(typenames[i]+" "+table[i].length);
		}
		double maxvalue = Double.MIN_VALUE;
		double[] sumvalue = new double[typenames.length];
		for(int i=0;i<sumvalue.length;i++) sumvalue[i] = 0;
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		PrintWriter writer = new PrintWriter(new OutputStreamWriter(outputStream,"UTF-8"));
		JSONWriter writer2 = new JSONWriter(writer);
		writer2.object().key("data").array();
		for(int i=0;i<table[0].length;i++)
		{
			writer2.array();
			for(int j=0;j<typenames.length;j++)
			{
				if(table[j][i]>maxvalue) maxvalue = table[j][i];
				sumvalue[j]+=table[j][i];
				writer2.value(table[j][i]);
				//System.out.print(table[j][i]);;
			}
			//System.out.println();
			writer2.endArray();
		}
		writer2.endArray();
		
		for(int i=0;i<typenames.length;i++)
		{
			writer2.key(typenames[i]).value(maxvalue);
			writer2.key("pie_"+typenames[i]).value(sumvalue[i]);
		}
		
		writer2.endObject();
		writer.flush();
		String str_result = outputStream.toString("UTF-8");
		outputStream.flush();
		
		return str_result;
		
		
	}
	
}
