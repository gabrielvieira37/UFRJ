
public class TestWorldAnimal {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Position position = new Position(80,80);
		Dog clarencio = new Dog(position, 10, 10);
		int steps = 0;
		
		MyTerrain terraDoTioJoaquim = new MyTerrain(100, 100);
		MyWorld terraDoAmanha = new MyWorld();
		terraDoAmanha.setAnimal(clarencio);
		terraDoAmanha.setTerrain(terraDoTioJoaquim);
		
		while (terraDoAmanha.isAnimalWithinTerrain()){
			terraDoAmanha.moveAnimal();
			clarencio.print();
			System.out.println("Steps = " + ++steps);	
		}
		System.out.println("Clarêncio meteu a fuça na cerca do tio Joaquim");
	}

}
