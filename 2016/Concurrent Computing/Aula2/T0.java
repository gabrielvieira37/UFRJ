package aula2;

public class T0 extends Thread{
	
	
	public void run(){
		for(int i = 0;i < 10000000;i++){
			Principal.intendToEnter0 = true;
			Principal.vez = 1;
			while( Principal.intendToEnter1 && Principal.vez == 1){;}
			Principal.Compart += 1;
			Principal.intendToEnter0 = false;
			
		}
		System.out.println("T0: " + Principal.Compart);
	} 


}
