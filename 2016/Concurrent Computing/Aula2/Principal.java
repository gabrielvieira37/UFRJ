package aula2;


public class Principal {
	
	public static volatile int Compart = 0;
	public static volatile int vez = 0;
	public static volatile boolean intendToEnter0 = false;
	public static volatile boolean intendToEnter1 = false;
	
public static void main(String[] args) {
	
	
	T0 T1 = new T0();
	T1 T2 = new T1();
	T1.start();
	T2.start();
	}
	
	
	
}
