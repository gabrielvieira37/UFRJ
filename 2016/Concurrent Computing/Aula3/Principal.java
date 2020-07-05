package aula3;

public class Principal {
	final static int N = 100;
	public static volatile int Compart = 0;
	public static volatile long senhas[] = new long [N] ;
	public static volatile boolean escolhendo[] = new boolean[N];
	
	
	
	public static void main(String[] args) {
	
		Tn T[] = new Tn[N];
		for(int i = 0;i<N;i++){
			T[i] = new Tn(i);
		}
		for(int i = 0;i<N;i++){
			T[i].start();
		}
		
	}
}
