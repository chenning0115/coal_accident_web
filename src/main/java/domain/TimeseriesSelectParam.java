package domain;

public class TimeseriesSelectParam {

	String select_pro ="all";
	String select_type = "all";
	
	public TimeseriesSelectParam()
	{
		
	}
	public TimeseriesSelectParam(String _pro,String _type)
	{
		this.select_pro = _pro;
		this.select_type = _type;
	}
	
	public String getSelect_pro()
	{
		return this.select_pro;
	}
	public String getSelect_type()
	{
		return this.select_type;
	}
	public void setSelect_pro(String _select_pro)
	{
		this.select_pro = _select_pro;
	}
	public void setSelect_type(String _select_type)
	{
		this.select_type = _select_type;
	}
	
}
