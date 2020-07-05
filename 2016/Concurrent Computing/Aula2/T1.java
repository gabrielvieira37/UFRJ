package aula2;

public class T1 extends Thread{
	
	
	public void run(){
		for(int i = 0;i < 10000000;i++){
			Principal.intendToEnter1 = true;
			Principal.vez = 0;
			while( Principal.intendToEnter0 && Principal.vez == 0){;}
			Principal.Compart += 1;
			Principal.intendToEnter1 = false;
		}
		System.out.println("T1: " + Principal.Compart);
	}
	
}
