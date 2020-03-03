#include <stdio.h>
#include <stdlib.h>

void quick_S( int v[], int p, int r) {
   int c, i, j, t;
   if (p < r) {
      c = v[(p+r)/2];
      i = p, j = r;
      while (i <= j) {
         while (v[i] < c){
		 ++i;
	}

         while (c < v[j]){
		 --j;
	}
         if (i <= j) {
            t = v[i];
            v[i] = v[j];
            v[j] = t;
            ++i, --j;
         }
      }
      quick_S( v, p, j);
      quick_S( v, i, r);
   }
}



int main() {
 	int contadentro,casos, tam1, tam2, tam3, conta1, conta2, conta3, l, s, i, j, k;
	int *V1 = NULL,*V2 = NULL, *V3 = NULL ,*V1dif = NULL ,*V2dif = NULL,*V3dif= NULL ;



	scanf("%d", &casos);

       // testando os casos //
	for (l=1; l <= casos; l++){
        printf("entrei no loop");
         // Lendo Vetores //
		scanf("%d", &tam1);
		V1 = malloc((tam1+1)*sizeof(int));
		V1dif = malloc((tam1)*sizeof(int));
		V1[0] = tam1;
		for (s=1; s <= tam1; s++ ){
			scanf("%d", &V1[s]);
			}

		scanf("%d", &tam2);
		V2 = malloc((tam2+1)*sizeof(int));
		V2dif = malloc((tam2)*sizeof(int));
		V2[0] = tam2;
		for (s=1; s <= tam2; s++ ){
			scanf("%d", &V2[s]);
			}

		scanf("%d", &tam3);
		V3 = malloc((tam3+1)*sizeof(int));
		V3dif = malloc((tam3)*sizeof(int));
		V3[0] = tam3;
		for (s=1; s <= tam3; s++ ){
			scanf("%d", &V3[s]);
			}scanf("%d", &tam1);
		V1 = malloc((tam1+1)*sizeof(int));
		V1dif = malloc((tam1)*sizeof(int));
		V1[0] = tam1;
		for (s=1; s <= tam1; s++ ){
			scanf("%d", &V1[s]);
			}

		scanf("%d", &tam2);
		V2 = malloc((tam2+1)*sizeof(int));
		V2dif = malloc((tam2)*sizeof(int));
		V2[0] = tam2;
		for (s=1; s <= tam2; s++ ){
			scanf("%d", &V2[s]);
			}

		scanf("%d", &tam3);
		V3 = malloc((tam3+1)*sizeof(int));
		V3dif = malloc((tam3)*sizeof(int));
		V3[0] = tam3;
		for (s=1; s <= tam3; s++ ){
			scanf("%d", &V3[s]);
			}

		// Lendo Vetores termina //

        // Comparação do primeiro vetor com os outros //
        for (i=1; i<=tam1; i++){
            for (j=1; j<=tam2; j++){
                if (V1[i]==V2[j]){
                    j=tam2;
                    contadentro = 0;
                }else{
                    contadentro++;
                }
                if (j=tam2 && contadentro!= 0){
                    conta1++;
                }
            }

            for (k=1; k<=tam3; k++){
                 if (V1[i]==V3[k] || contadentro==0){
                    if(contadentro!=0){
                        conta1--;
                        contadentro = 0;
                        }
                    k=tam3;
                    }else{
                    contadentro++;
                    }
                     if (k=tam3 && contadentro!= 0){
                        V1dif[i] = V1[i];
                }
            }

        }
        // Comparação do primeiro vetor com os outros termina //

        // Comparação do segundo vetor com os outros //
        for (i=1; i<=tam2; i++){
            for (j=1; j<=tam1; j++){
                if (V2[i]==V1[j]){
                    j=tam1;
                    contadentro = 0;
                }else{
                    contadentro++;
                }
                if (j=tam1 && contadentro!= 0){
                    conta2++;
                }
            }

            for (k=1; k<=tam3; k++){
                 if (V2[i]==V3[k] || contadentro==0){
                    if(contadentro!=0){
                        conta2--;
                        contadentro = 0;
                        }
                    k=tam3;
                    }else{
                    contadentro++;
                    }
                     if (k=tam3 && contadentro!= 0){
                        V2dif[i] = V2[i];
                }
            }

        }
        // Comparação do segundo vetor com os outros termina //

        // Comparação do terceiro vetor com os outros //
         for (i=1; i<=tam3; i++){
            for (j=1; j<=tam1; j++){
                if (V3[i]==V1[j]){
                    j=tam1;
                    contadentro = 0;
                }else{
                    contadentro++;
                }
                if (j=tam1 && contadentro!= 0){
                    conta3++;
                }
            }

            for (k=1; k<=tam2; k++){
                 if (V3[i]==V2[k] || contadentro==0){
                    if(contadentro!=0){
                        conta3--;
                        contadentro = 0;
                        }
                    k=tam2;
                    }else{
                    contadentro++;
                    }
                     if (k=tam2 && contadentro!= 0){
                        V3dif[i] = V3[i];
                }
            }

        }
        // Comparação do terceiro vetor com os outros termina //


        // ordenando os vetores dos valores diferentes//
        quick_S(V1dif,0,tam1);
        quick_S(V2dif,0,tam2);
        quick_S(V3dif,0,tam3);
        // ordenando os vetores dos valores diferentes termina //


        //output do programa//
        if ( conta1 > conta2 && conta1> conta3){
            printf("Case # &d",l);
            printf("1");
            printf("%d",conta1);
            for (s=0; s<tam1; s++){
                printf("%d",V1dif[s]);
            }
        }
        if (conta2> conta1 && conta2>conta3){
            printf("Case # &d",l);
            printf("2");
            printf("%d",conta2);
            for (s=0; s<tam2; s++){
                printf("%d",V2dif[s]);
            }
        }
        if (conta3> conta1 && conta3>conta2){
            printf("Case # &d",l);
            printf("3");
            printf("%d",conta3);
            for (s=0; s<tam3; s++){
                printf("%d",V3dif[s]);
            }
        }
        if (conta1== conta2 && conta2>conta3){
            printf("Case # &d",l);
            printf("1");
            printf("%d",conta1);
            for (s=0; s<tam1; s++){
                printf("%d",V1dif[s]);
            }
            printf("2");
            printf("%d",conta2);
            for (s=0; s<tam2; s++){
                printf("%d",V2dif[s]);
            }

        }
        if (conta1== conta3 && conta1>conta2){
            printf("Case # &d",l);
            printf("1");
            printf("%d",conta1);
            for (s=0; s<tam1; s++){
                printf("%d",V1dif[s]);
            }
            printf("3");
            printf("%d",conta3);
            for (s=0; s<tam3; s++){
                printf("%d",V3dif[s]);
            }
        }
        if (conta2== conta3 && conta2>conta1){
            printf("Case # &d",l);
            printf("2");
            printf("%d",conta2);
            for (s=0; s<tam2; s++){
                printf("%d",V2dif[s]);
            }
            printf("3");
            printf("%d",conta3);
            for (s=0; s<tam3; s++){
                printf("%d",V3dif[s]);
            }
        }
        if (conta1==conta2 && conta2==conta3){
            printf("Case # &d",l);
            printf("1");
            printf("%d",conta1);
            for (s=0; s<tam1; s++){
                printf("%d",V1dif[s]);
            }
            printf("2");
            printf("%d",conta2);
            for (s=0; s<tam2; s++){
                printf("%d",V2dif[s]);
            }
            printf("3");
            printf("%d",conta3);
            for (s=0; s<tam3; s++){
                printf("%d",V3dif[s]);
            }
        }
        //output do programa termina//
	}
    // testando casos termina //

    // liberando memoria//
    free(V1);
    free(V2);
    free(V3);
    free(V1dif);
    free(V2dif);
    free(V3dif);
    // liberando memoria termina//

	return 0;
}


