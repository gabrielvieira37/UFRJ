

public class Tn extends Thread{
		private int myId;
		
		public Tn(int id){
			myId = id;
		}
		
	/*	static long  maximo(){
			long max = 0;
			for(int i = 0;i<Principal.N;i++){
				if( Principal.senhas[i] > max )
					max = Principal.senhas[i];
			}
			return max;
		}
	*/
		public void run(){
		
			for(int n =  1000000; n > 0; n--){
				Principal.mutex.lock();
				Principal.Compart++;
				Principal.mutex.unlock();
			//	Principal.senhas[myId] = 0;
			}
			System.out.println("Thread: " + myId + " Sessao Critica: " + Principal.Compart );
		}
		
		
}
