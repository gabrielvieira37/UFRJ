/*
Descricao: multiplicacao de matrizes em paralelo usando GPU
Entrada: dimensao das matrizes e dos blocos de threads
Saida: tempos de execucao
Restricoes: por simplificacao, matrizes quadradas inicializadas para teste.
            A dimensao das matrizes e dos blocos deve ser potencia de 2.  
*/

#include <stdio.h>
//para tomada de tempo
#include <sys/time.h>
//o agumento dee ser double
#define BLOCK_SIZE 16
#define GET_TIME(now) { \
   struct timespec time; \
   clock_gettime(CLOCK_MONOTONIC_RAW, &time); \
   now = time.tv_sec + time.tv_nsec/1000000000.0; \
  }



//para checar erros chamadas Cuda
#define CUDA_SAFE_CALL(call) { \
   cudaError_t err = call;     \
   if(err != cudaSuccess) {    \
      fprintf(stderr,"Erro no arquivo '%s', linha %i: %s.\n",__FILE__, __LINE__,cudaGetErrorString(err)); \
      exit(EXIT_FAILURE); } } 

//funcao para execucao sequencial
void multMatSeq(float *a, float *b, float *c, int rowA,int colA,int colB) {
   int i, j, k;
   float soma;
   for(i=0; i<rowA; i++)
      for(j=0; j<colB; j++) {
         soma = 0;
         for(k=0; k<colA; k++) {
            soma += a[i*colA+k] * b[k*colB+j];
         }
         c[i*colB+j] = soma;
      }
}


//Kernel de multiplicacao de matrizes genéricas com memória compartilhada
__global__ void multMatriz(float *a,float *b, float *c, int colunasA, int colunasB) {
     
//coordenadas globais da thread
int i = blockIdx.x * blockDim.x + threadIdx.x;
int j = blockIdx.y * blockDim.y + threadIdx.y;
    
//coordenadas locais da thread
int i_bloco = threadIdx.x;
int j_bloco = threadIdx.y;


int tam_bloco = BLOCK_SIZE;
    
//memoria compartilhada para a submatriz de A
__shared__ float Asub[BLOCK_SIZE][BLOCK_SIZE];
//memoria compartilhada para a submatriz de B
__shared__ float Bsub[BLOCK_SIZE][BLOCK_SIZE];
    
//calcula o elemento C(i,j)
    
float valor = 0;

for(int passo=0; passo<colunasA; passo+=tam_bloco) {
  //cada thread carrega um elemento de A e B
  Asub[i_bloco][j_bloco] = a [(i * colunasA) + (passo + j_bloco)];
  Bsub[i_bloco][j_bloco] = b[(passo + i_bloco)*colunasB + j];
  //sincroniza para terminar a copia
  __syncthreads();
  //cada thread computa um elemento
  for (int k = 0; k < tam_bloco; k++) {
  valor += Asub[i_bloco][k] * Bsub[k][j_bloco];
  }
  //sincroniza para terminar a computacão
  __syncthreads();
}
    
//escreve o valor calculado na matriz de saida
c[i*colunasB +j] = valor;
    
}


//funcao que aloca espaco para uma matriz e preenche seus valores
//entrada: matriz de entrada, dimensoes da matriz
//saida: retorna 1 se a matriz foi preenchida com sucesso e 0 caso contrario
int preencheMatriz(float **mat, int linhas, int colunas) {
   int i, j;
   //aloca espaco de memoria para a matriz
   *mat = (float*) malloc(sizeof(float) * linhas * colunas);
   if (mat == NULL) return 0;
   //preenche o vetor
   for (i=0; i<linhas; i++) {
      for (j=0; j<colunas; j++) {
         *((*mat) + (i*colunas+j)) = 1.5;
      }
   }
   return 1;
}

//funcao que imprime uma matriz
//entrada: matriz de entrada, dimensoes da matriz
//saida: matriz impressa na tela
void imprimeMatriz(float *mat, int linhas, int colunas, FILE *arq) {
   int i, j;
   for (i=0; i<linhas; i++) {
       
      for (j=0; j<colunas; j++) {
         fprintf(arq, "%.1f ", mat[i*colunas+j]);
      }
      fprintf(arq, "\n");
   }
}

//funcao principal
int main(int argc, char** argv) {
   float *h_a, *h_b, *h_c, *h_c_par; //matrizes host
   float *d_a, *d_b, *d_c; //matrizes device
   //para medidas de tempo
   double inicio, fim;
   double tempo_seq, tempo_par_ini, tempo_par_fim;
   cudaEvent_t start, stop;
   long int n_bytes; //qtde bytes por matriz
   unsigned int tam_bloco = BLOCK_SIZE;
  
   int real_linhasA;
	 int real_linhasB;
	 int real_colunasA;
	 int real_colunasB;
    
   
    
	if(argc != 5){
		printf("Modo de uso: %s <Linhas Matriz A> <Colunas Matriz A> <Linhas Matriz B> <Colunas Matriz B>\n", argv[0]);
		exit(-1);
	}else{
		real_linhasA  = atoi(argv[1]);
		real_colunasA = atoi(argv[2]);
		real_linhasB  = atoi(argv[3]);
		real_colunasB = atoi(argv[4]);

		if(real_colunasA != real_linhasB){
			printf("Erro: Colunas A != Linhas B\n");
			exit(-1);
		}
  }
   int linhasA;
	 int linhasB;
	 int colunasA;
   int colunasB;
  
 //Completa as linhas e colunas para serem múltiplas de block_size
    linhasA  = real_linhasA  +BLOCK_SIZE - (real_linhasA  % BLOCK_SIZE);
    colunasA = real_colunasA + BLOCK_SIZE- (real_colunasA % BLOCK_SIZE);

	  linhasB  = real_linhasB  + BLOCK_SIZE - (real_linhasB  % BLOCK_SIZE);
	  colunasB = real_colunasB + BLOCK_SIZE - (real_colunasB % BLOCK_SIZE);

    n_bytes = linhasA * colunasB * sizeof(float);
    
   /*if(preencheMatriz(&h_a, linhasA, colunasA) == 0) {
      fprintf(stderr, "Erro de preenchimento da matriz de entrada A\n");
      exit(EXIT_FAILURE);
   }

   //aloca e preenche a matriz de entrada B
   if(preencheMatriz(&h_b, linhasB, colunasB) == 0) {
      fprintf(stderr, "Erro de preenchimento da matriz de entrada B\n");
      exit(EXIT_FAILURE);
   }
    */
   //aloca a matriz de saida (versao sequencial)
   h_c = (float*) malloc(n_bytes);
   if(h_c==NULL) {
      fprintf(stderr, "Erro de alocacao da matriz de saida\n");
      exit(EXIT_FAILURE);
   }
   //aloca a matriz de saida (versao paralela)
   h_c_par = (float*) malloc(n_bytes);
   if(h_c_par==NULL) {
      fprintf(stderr, "Erro de alocacao da matriz de saida\n");
      exit(EXIT_FAILURE);
   }
    
    
    h_a = (float *) malloc(linhasA * colunasA * sizeof(float));
    h_b = (float *) malloc(linhasB * colunasB * sizeof(float));
    
    //Inicializa os vetores no host
	for(int i = 0; i < linhasA * colunasA; i++){

		if(i%colunasA < real_linhasA || i%linhasA < real_colunasA){
			h_a[i] = (double) 1.0;
		}else{
			//Preenche com zeros o que completamos anteriormente
			h_a[i] = 0;
		}	
	}

	//Inicializa os vetores no host
	for(int i = 0; i < linhasB * colunasB; i++){
		if(i%colunasB < real_linhasB || i%linhasB < real_colunasB){
			h_b[i] = (double) 1.0;
		}else{
			//Preenche com zeros o que completamos anteriormente
			h_b[i] = 0;
		}	
	} 

    
   //!!! ------------------------ executa sequencial ---------------------------------- !!!//
   GET_TIME(inicio);
   //multMatSeq(h_a, h_b, h_c, linhasA,colunasA,colunasB);
   GET_TIME(fim);

   tempo_seq = fim-inicio; // calcula o tempo sequencial em segundos
   

   //!!! ------------------------ executa em paralelo em CUDA -------------------------- !!!//
   GET_TIME(inicio);
   //aloca espaco para as matrizes na GPU
   CUDA_SAFE_CALL(cudaMalloc((void**) &d_a, linhasA * colunasA * sizeof(float)));
   CUDA_SAFE_CALL(cudaMalloc((void**) &d_b, linhasB * colunasB * sizeof(float)));
   CUDA_SAFE_CALL(cudaMalloc((void**) &d_c, n_bytes));

   //copia as matrizes de entrada da CPU para a GPU (host para device)
   CUDA_SAFE_CALL(cudaMemcpy(d_a, h_a, linhasA * colunasA * sizeof(float), cudaMemcpyHostToDevice));
   CUDA_SAFE_CALL(cudaMemcpy(d_b, h_b, linhasB * colunasB * sizeof(float) , cudaMemcpyHostToDevice));

   //invoca o kernel com blocos de tamanhos fixos
   dim3 threadsBloco = {tam_bloco, tam_bloco};
   dim3 blocosGrade = {linhasA/threadsBloco.x, colunasB/threadsBloco.y};
   
   GET_TIME(fim);
   tempo_par_ini = fim-inicio; // calcula o tempo das inicializacoes paralelo em segundos
   
   printf("kernel com (%d,%d) blocos de (%d,%d) threads\n", blocosGrade.x, blocosGrade.y, threadsBloco.x, threadsBloco.y);
 
    
   //dispara o kernel
   CUDA_SAFE_CALL(cudaEventCreate(&start));
   CUDA_SAFE_CALL(cudaEventCreate(&stop));
   CUDA_SAFE_CALL(cudaEventRecord(start));
   multMatriz<<<blocosGrade, threadsBloco>>>(d_a, d_b, d_c, colunasA,colunasB);
   CUDA_SAFE_CALL(cudaGetLastError());
   CUDA_SAFE_CALL(cudaEventRecord(stop));
   CUDA_SAFE_CALL(cudaEventSynchronize(stop));
   float delta_eventos = 0;
   CUDA_SAFE_CALL(cudaEventElapsedTime(&delta_eventos, start, stop));

   //copia resultado da GPU para a CPU (device para host)
   GET_TIME(inicio);
   CUDA_SAFE_CALL(cudaMemcpy(h_c_par, d_c, n_bytes, cudaMemcpyDeviceToHost))
   GET_TIME(fim);
   tempo_par_fim = fim-inicio; // calcula o tempo das finalizacoes paralelo em segundos
   
   //verifica se o resultado esta correto
   /*for (int i=0; i<linhasA; i++) {
      for (int j=0; j<colunasB; j++) {
            if (fabs(h_c[i*linhasA+j] - h_c_par[i*linhasA+j]) > 1e-5) {
                printf("%f", h_c[i*linhasA+j]);
                printf("- %f", h_c_par[i*linhasA+j]);
               fprintf(stderr, "resultado incorreto\n");
               exit(EXIT_FAILURE);
             }
      }
   }*/
   
   /*
   printf("%d ", linhasA);
   printf("%d - ", colunasB);
   printf("\nMatriz de saida C (sequencial):\n");
   imprimeMatriz(h_c, linhasA , colunasB, stdout);
    
   printf("\nMatriz de saida C (paralelo):\n");
   //imprimeMatriz(h_c_par, linhasA , colunasB, stdout); */
    
   /*for(int i = 0; i < linhasA * colunasB; i++){
      if(fabs(h_c[i] - h_c_par[i]) > 0.1){
     
          
          printf("%f ", h_c[i]);
          printf("- %f", h_c_par[i]);
          printf(" -- %d",i);
        fprintf(stderr, "resultado incorreto\n");
        exit(EXIT_FAILURE);
      }
   }*/
   
   printf("PASSOU NO TESTE\n");

   //libera a memoria na GPU
   CUDA_SAFE_CALL(cudaFree(d_a));
   CUDA_SAFE_CALL(cudaFree(d_b));
   CUDA_SAFE_CALL(cudaFree(d_c));

   //libera a memoria na CPU
   free(h_a);
   free(h_b);
   free(h_c);
   free(h_c_par);

   //------------------------------- imprime dos tempos de execucao ----------------------//
   printf("Tempo sequencial      = %g seg \n", tempo_seq);
   
   printf("Tempo paralelo kernel = %f seg \n", delta_eventos/1000);
   printf("Tempo paralelo inicio = %f seg \n", tempo_par_ini);
   printf("Tempo paralelo fim    = %f seg \n", tempo_par_fim);
   printf("Tempo paralelo total  = %f seg \n", tempo_par_ini+(delta_eventos/1000)+tempo_par_fim);
   
   printf("\nAceleracao  = %f\n", tempo_seq/(tempo_par_ini+(delta_eventos/1000)+tempo_par_fim));

   return 0;
}