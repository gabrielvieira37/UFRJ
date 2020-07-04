#include<stdio.h>
#include<stdlib.h>

typedef struct tree{
    char cor;
    int campo;
    struct tree *esq;
    struct tree *dir;
    struct tree *raiz;

}TREE;


TREE *insere(TREE *ptree , int x );
char cor (TREE *ptree);
TREE *recolore (TREE *ptree);
TREE *rotesq (TREE *ptree);
TREE *rotdir(TREE *ptree);
void imprime(TREE *ptree);
TREE *insereRnll(TREE *ptree, int x);

int main (){
    TREE *arvore;
    arvore = NULL;
    char string[1000];
    int i, temp, n;
    char c;
    c = 'e';
    while (c!='p'){
        fgets(string, sizeof(string), stdin);
        sscanf(string, "%c %d", &c, &n);

            if(c == 'i'){
                arvore = insereRnll(arvore,n);
            }else{
                if(c!='p')
                printf("as letras utilizadas sao apenas p e i \n");
            }

    }
    imprime(arvore);

return 0;
}


void imprime(TREE *ptree){

if(ptree != NULL)
    {
        printf("%d %c\n", ptree->campo,ptree->cor);
        imprime(ptree->esq);
        imprime(ptree->dir);
    }


}



char cor (TREE *ptree){
    if (ptree == NULL){
        return 'N'; }
    else{
        return ptree->cor;
    }
}

TREE *recolore(TREE *ptree){
    ptree->cor= 'R';
    ptree->esq->cor = 'N';
    ptree->dir->cor = 'N';
    return ptree;
}

TREE *rotesq(TREE *ptree){
    ptree->dir->cor = 'N';
    ptree->cor = 'R';

    TREE *tmp,*var;

    tmp = ptree;
    var = ptree->dir;
    tmp->dir = var->esq;

    ptree = var;
    ptree->esq = tmp;


    return ptree;


}

TREE *rotdir(TREE *ptree){
    ptree->cor = 'R';
    ptree->esq->cor ='N';
    ptree->esq->esq->cor = 'R';

    TREE *tmp,*aux,*var;

    tmp = ptree;
    aux = ptree->esq;
    var = ptree->esq->esq;
    tmp->esq = aux->dir;

    ptree = aux;
    ptree->dir = tmp;
    ptree->esq = var;



    return ptree;
}


TREE *insere(TREE *ptree, int x){
    if (ptree == NULL){
        TREE *no;
        no = malloc(sizeof(TREE));
        no->campo = x;
        no->esq = NULL;
        no->dir = NULL;
        no->cor = 'R';

        return no;
    }


    if(x < ptree->campo){
            ptree->esq = insere(ptree->esq,x);
        }

        else{
            ptree->dir=insere(ptree->dir,x);
        }
     if(cor(ptree)=='N' && cor(ptree->esq)=='R' && cor(ptree->dir)=='R')
        {
                ptree=recolore(ptree);
        }


     if (cor(ptree)=='N' && cor(ptree->esq)=='N' && cor(ptree->dir)=='R')
        {
                ptree=rotesq(ptree);
        }
    if (cor(ptree)=='N' && cor(ptree->esq)=='R' && cor(ptree->esq->esq)=='R')
        {
                ptree=rotdir(ptree);
        }

    return ptree;

}

TREE* insereRnll(TREE *ptree, int x){
    ptree=insere(ptree,x);
    ptree->cor = 'N';
    return ptree;
}
