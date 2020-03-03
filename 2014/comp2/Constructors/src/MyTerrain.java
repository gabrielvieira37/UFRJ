public class MyTerrain implements Terrain {

	private int width;
	private int height;

	public MyTerrain(int width, int height) {
		this.width = width;
		this.height = height;
	}

	public boolean isWithinLimits(Position position) {
		if (position.getPosX() < width && position.getPosX() > 0
				&& position.getPosY() < height && position.getPosY() > 0) {
			return true;
		}

		return false;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public int getHeight() {
		return height;
	}

	public void setHeight(int height) {
		this.height = height;
	}

}
