package domain;

public class LineandBarParam {

	private String legendname;
	private String xaxisdata;
	private String serisedata;
	
	public LineandBarParam(String _lengendname,String _xaxisdata,String _serisedata)
	{
		this.legendname = _lengendname;
		this.xaxisdata = _xaxisdata;
		this.serisedata = _serisedata;
	}
	public String getLegendname()
	{
		return this.legendname;
	}
	public String getXaxisdata()
	{
		return this.xaxisdata;
	}
	public String getSerisedata()
	{
		return this.serisedata;
	}
	public void setLengendname(String _lengendname)
	{
		this.legendname = _lengendname;
		
	}
	public void setXaxisdata(String _xaxisdata)
	{
		this.xaxisdata = _xaxisdata;
	}
	public void setSerisedata(String _serisedata)
	{
		this.serisedata = _serisedata;
	}
	 

}
