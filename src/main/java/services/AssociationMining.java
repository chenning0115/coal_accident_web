package services; 

import java.io.ByteArrayOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;

import org.json.JSONWriter;

import analyse.association.LRAssociation;
import analyse.association.LRRule;
import data.AttrFilterByExpression;
import data.LRInstances;
import data.RemoveAttrFilter;

public class AssociationMining {

	LRInstances lrInstances =null;
	String attrbuteselectedexpression = null;
	String removeAttrindex = null;
	public AssociationMining(LRInstances _lLrInstances,String _aAttrFilterexpression,String _rRemoveAttrindex)
	{
		this.lrInstances = _lLrInstances;
		this.attrbuteselectedexpression = _aAttrFilterexpression;
		this.removeAttrindex = _rRemoveAttrindex;
	}
	
	private String convert2Json(ArrayList<LRRule> list)
	{
		DecimalFormat df=(DecimalFormat)NumberFormat.getInstance(); 
		df.applyPattern(".0000");
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		PrintWriter writer = new PrintWriter(new OutputStreamWriter(outputStream));
		JSONWriter writer2 = new JSONWriter(writer);
		writer2.object().key("data").array();
		for(int i=0;i<list.size();i++)
		{
			LRRule rule = list.get(i);
			writer2.array().value(""+i).value(rule.premise).value(rule.consequense).value(df.format(rule.metricmap.get("Confidence")))
			.value(df.format(rule.metricmap.get("Lift"))).value(df.format(rule.metricmap.get("Leverage"))).value(df.format(rule.metricmap.get("Conviction")))
			.endArray();
			
		}
		writer2.endArray().endObject();
		writer.flush();
		try {
			String str_result = outputStream.toString("UTF-8");
			return str_result;
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	public String RunApriori(double _UpperBoundSupport,double _LowerBoundMinSupport
			,double _delt,int _metrictype,double _minmetric,int _numrules)
	{
		LRInstances lrInstances2=lrInstances;
		if(this.attrbuteselectedexpression!=null&&!this.attrbuteselectedexpression.equals("all"))
		{
			AttrFilterByExpression attrFilterByExpression = new AttrFilterByExpression(this.lrInstances,
					this.attrbuteselectedexpression);
			lrInstances2 = attrFilterByExpression.LRProcess(this.lrInstances);
		}
		LRInstances lrInstances3 = lrInstances2;
		if(this.removeAttrindex!=null&&!this.removeAttrindex.equals("-1"))
		{
			RemoveAttrFilter removeAttrFilter = new RemoveAttrFilter(lrInstances2, this.removeAttrindex);
			lrInstances3 = removeAttrFilter.LRProcess(lrInstances2);
		}
		
		LRAssociation lrAssociation = new LRAssociation(lrInstances3, _UpperBoundSupport, _LowerBoundMinSupport, _delt,
				_metrictype, _minmetric, _numrules);
		ArrayList<LRRule> list = lrAssociation.runapriori();
		//System.out.println("lrrules = "+list.size());
		return convert2Json(list);
		
	}
	
}
