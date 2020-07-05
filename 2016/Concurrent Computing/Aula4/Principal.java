import java.util.concurrent.Semaphore;
import java.util.concurrent.locks.ReentrantLock;

public class Principal {
//	static Semaphore mutex = new Semaphore(1);
	static ReentrantLock mutex = new ReentrantLock();
	static Semaphore disponivel = new Semaphore(0);
	static int count = 2;
	static int waiting = 0;
	final static int N = 10;
	public static volatile int Compart = 0;
	//public static volatile long senhas[] = new long [N] ;
	//public static volatile boolean escolhendo[] = new boolean[N];
	
	
	
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
