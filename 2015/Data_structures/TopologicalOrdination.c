#include<stdio.h>
#include<stdlib.h>


typedef struct item{
	int campo;
	struct item* prox;
}ITEM;


void Imprimir(ITEM *lista,int TOTALVERTICES);
void insert(ITEM* lista,int a, int b);

int main(void){

    char *buffer;
    char string[1000];
    int ttemp, n,m;
    int i,a,b,k;
    k = 0;
    i=0;
    int arestas = 0;
    int TOTALVERTICES = 0;

    ITEM *lista;
    ITEM *lista2;


  // Inicialização da lista.
      fgets(string, sizeof(string), stdin);
    sscanf(string, "%d %d", &TOTALVERTICES, &arestas);


    lista = malloc((TOTALVERTICES+1)* sizeof(ITEM));
    lista2 = malloc((TOTALVERTICES+1)* sizeof(ITEM));

    lista[0].campo=0;
    lista[0].prox = NULL;

  for(i=1; i<=TOTALVERTICES; i++){
    lista[i].campo = 0;
    lista[i].prox = NULL;

     lista2[i].campo = 0;
     lista2[i].prox = NULL;
  }
  //leitura dos vertices adjacentes
  for(i=1; i<= TOTALVERTICES; i++){
        fgets(string, sizeof(string), stdin);
        buffer = strtok (string," ");

            while(buffer != NULL){
                if(sscanf(buffer, "%d", &ttemp) == -1)
                {
                }
                else{
                    insert(lista,i,ttemp);
                    insert(lista2,ttemp,i);
                    }

                buffer = strtok (NULL, " ");



            }
  }

    for(i = 1; i <= TOTALVERTICES; i ++) {
            if (lista[i].campo==0){
                insert(lista,0,i);
            }
        }


  /*Imprimir(lista,TOTALVERTICES);
  printf("\n");
  Imprimir(lista2,TOTALVERTICES);
  printf("\n");
*/


    ITEM* pont1 = lista[0].prox;
    while(pont1 != NULL) {
        ITEM* pont2 = lista2[pont1->campo].prox;
        while(pont2 != NULL) {
            lista[pont2->campo].campo--;
            if(lista[pont2->campo].campo == 0) {
                insert(lista, 0, pont2->campo);
            }
            pont2 = pont2->prox;
        }
        pont1 = pont1->prox;
    }

   printf("lista ordenada:\n ");

   ITEM* no = lista[0].prox;
	while(no != NULL) {
		printf("%d \n ", no->campo);
		no = no->prox;
	}

  return 0;

}


void Imprimir(ITEM *lista,int TOTALVERTICES){
  int i;
  ITEM * tmp;
  for(i=1; i<=TOTALVERTICES; i++) {
    tmp = lista[i].prox;
    printf("%2d: (%d) ==>", i, lista[i].campo);
    while (tmp != NULL) {
      printf("%d  ", tmp->campo);
      tmp = tmp->prox;
    }
    printf("\n");
  }
}


void insert(ITEM* lista,int a, int b) {
	ITEM* aux;
	aux = malloc(sizeof(ITEM));
	aux->prox= NULL;
	aux->campo = b;

    if(lista[a].prox == NULL) {
        lista[a].prox = aux;
    }
    else {
        ITEM* temp;
        temp = lista[a].prox;

        while(temp->prox != NULL) {
            temp = temp->prox;
        }
        temp->prox = aux;
    }
	lista[a].campo++;
}

