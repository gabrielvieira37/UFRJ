package aula3;

public class Tn extends Thread{
		private int myId;
		
		public Tn(int id){
			myId = id;
		}
		
		static long  maximo(){
			long max = 0;
			for(int i = 0;i<Principal.N;i++){
				if( Principal.senhas[i] > max )
					max = Principal.senhas[i];
			}
			return max;
		}
		
		public void run(){
		
			for(int n =  1000; n > 0; n--){
				Principal.escolhendo[myId] = true;
				Principal.senhas[myId] = ( maximo() +1 )*Principal.N + myId;
				Principal.escolhendo[myId] = false;
				
				for(int j = 0;j < Principal.N; j++){
					while(Principal.escolhendo[j]) {;}
					while(j != myId && Principal.senhas[j] != 0 && Principal.senhas[j] < Principal.senhas[myId] ) {;}
				}
				Principal.Compart++;
				Principal.senhas[myId] = 0;
			}
			System.out.println("Thread: " + myId + " Sessao Critica: " + Principal.Compart );
		}
		
		
}
