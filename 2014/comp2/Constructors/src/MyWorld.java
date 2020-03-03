
public class MyWorld implements World {

	private Terrain terrain;
	private Animal animal;
	
	public void setTerrain(Terrain terrain){
		this.terrain = terrain;
	}
	
	public void setAnimal(Animal animal){
		this.animal = animal;
	}
	
	public void moveAnimal(){
		animal.setPassoX(2);
		animal.setPassoY(1);
		animal.roam();
	}
	
	public boolean isAnimalWithinTerrain(){
		if (terrain.isWithinLimits(animal.getPosition())){
			return true;			
		}
		return false;
	}
}
