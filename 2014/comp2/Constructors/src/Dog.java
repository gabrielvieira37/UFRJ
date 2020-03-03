
public class Dog implements Animal {

	private int passoX;
	private int passoY;
	private Position position;
	
	public Dog(Position position, int passoX, int passoY){
		this.position = position;
		this.passoX = passoX;
		this.passoY = passoY;
	}
	
	public void roam(){
		int posAtualX = position.getPosX();
		position.setPosX(posAtualX + passoX);
		
		int posAtualY = position.getPosY();
		position.setPosY(posAtualY + passoY);		
	}
	
	public Position getPosition(){
		return position;
	}
	
	public void setPosition(Position position){
		this.position = position;
	}
	
	public void setPassoX(int passoX){
		this.passoX = passoX;
	}
	
	public void setPassoY(int passoY){
		this.passoY = passoY;
	}
	
	public int getPassoX(){
		return passoX;
	}
	
	public int getPassoY(){
		return passoY;
	}
	
	public void print(){
		System.out.println(Integer.toString(position.getPosX()));
		System.out.println(Integer.toString(position.getPosY()));
	}
	
}
