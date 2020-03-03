
public interface Terrain {

	public int getWidth();
	
	public void setWidth(int width);
	
	public int getHeight();
	
	public void setHeight(int height);
	
	public boolean isWithinLimits(Position position);
	
}
