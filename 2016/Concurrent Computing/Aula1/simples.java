
public class simples extends Thread{
	public simples(int id){
		minhaID = id;
	}
	private int minhaID;
	
	/*public void run(){
		for(int i = 0;i<20;i++){
			System.out.println("Thread " + minhaID + "rodando!");
			try {
				sleep(100);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}*/
	/*public void run(){
		for(int i = 0;i<1000000;i++){
			ProgConc.Compart = ProgConc.Compart +1;
			if(i%100 == 0)
			System.out.println("Thread " + minhaID + ": Compart = " + ProgConc.Compart );
		}
		System.out.println("Thread " + minhaID + ": Compart = " + ProgConc.Compart );
	}*/
	
}
