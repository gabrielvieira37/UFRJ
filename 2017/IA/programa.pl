
/**Inclui o arquivo com as posições das minas*/
:-include("mina.pl").

/**-------------------------------------------------------------------------------------------*/

/**Gera o arquivo onde vai ser gerado o ambiente de jogo*/
cria_arquivo():- open('ambiente.pl', write,Stream),
	close(Stream).

imprime_tamanho_do_tabuleiro(Tamanho):-open('ambiente.pl',append, Stream),
	write(Stream, 'tabuleiro('),
	write(Stream, Tamanho),
	write(Stream, ','),
	write(Stream, Tamanho),
	write(Stream, ').'),
	nl(Stream),
	close(Stream).

/**Função usada para imprimir no arquivo os valores do ambiente de jogo no formato correto*/
printar(Linha,Coluna,Valor):- \+ mina(Linha,Coluna),
	open('ambiente.pl',append, Stream),
	write(Stream, 'valor('),
	write(Stream, Linha),
	write(Stream, ','),
	write(Stream, Coluna),
	write(Stream, ','),
	write(Stream, Valor),
	write(Stream, ').'),
	nl(Stream),
	close(Stream).

/**Se a posição tiver uma mina nada será impresso*/
printar(_,_,_).

/**-------------------------------------------------------------------------------------------*/

/**Função inicial. Ela faz as chamadas para criar o arquivo do ambiente, criar o tabuleiro de*/
/** jogo, e fazer os cálculos para determinar os valores de todas as posições do tabuleiro*/
inicio(Tamanho):- cria_arquivo(),
	imprime_tamanho_do_tabuleiro(Tamanho),
	cria_tabuleiro(Tamanho,Tamanho,Tabuleiro),
	determinar_valores(Tamanho,1,1,Tabuleiro).

/**-------------------------------------------------------------------------------------------*/

/**Função que cria o tabuleiro. Percorre todas as posições de uma lista de tamanho*/
/**Linhas * Colunas e as inicializa com 0*/
cria_tabuleiro(1,[]):- !.

cria_tabuleiro(Linha,[0|Tabuleiro]):- L1 is Linha-1,
	cria_tabuleiro(L1,Tabuleiro).

cria_tabuleiro(Linhas,Colunas,[0|Tabuleiro]):- Length is Linhas*Colunas,
	cria_tabuleiro(Length,Tabuleiro).


/**-------------------------------------------------------------------------------------------*/

/**Função que determina os valores que devem ser colocados em cada posição.*/
determinar_valores(_,_,_,[]).

determinar_valores(Tamanho,Linha,Coluna,[Valor|Tabuleiro]):- calcula_quantidade_de_bombas_vizinhas(Linha,Coluna,Valor,Novo_valor),
	C1 is Coluna+1,
	C1 =< Tamanho,
	!,
	printar(Linha,Coluna,Novo_valor),
	determinar_valores(Tamanho,Linha,C1,Tabuleiro).


determinar_valores(Tamanho,Linha,Coluna,[Valor|Tabuleiro]):- calcula_quantidade_de_bombas_vizinhas(Linha,Coluna,Valor,Novo_valor),
	L1 is Linha+1,
	Linha =< Tamanho,
	C1 is 1,
	printar(Linha,Coluna,Novo_valor),
	determinar_valores(Tamanho,L1,C1,Tabuleiro).


/**-------------------------------------------------------------------------------------------*/

/**Função que calcula a calcula quantidade de bombas vizinhas a uma determinada posição*/
/**O valor é acumulado ao longo das chamadas através das variáveis passadas*/
calcula_quantidade_de_bombas_vizinhas(Linha,Coluna,Valor,Novo_valor):- \+ mina(Linha,Coluna),
	checa_esquerda_acima(Linha,Coluna,Valor,Valor1),
	checa_acima(Linha,Coluna,Valor1,Valor2),
	checa_direita_acima(Linha,Coluna,Valor2,Valor3),
	checa_esquerda(Linha,Coluna,Valor3,Valor4),
	checa_direita(Linha,Coluna,Valor4,Valor5),
	checa_esquerda_abaixo(Linha,Coluna,Valor5,Valor6),
	checa_abaixo(Linha,Coluna,Valor6,Valor7),
	checa_direita_abaixo(Linha,Coluna,Valor7,Novo_valor).

calcula_quantidade_de_bombas_vizinhas(_,_,_,_).

/**-------------------------------------------------------------------------------------------*/

/**Abaixo são as funções que checam cada uma das posições adjacentes e determinam se*/
/**o valor deve ser incrementado ou não*/
checa_esquerda_acima(Linha,Coluna,Valor,Valor1):- L1 is Linha-1,
	C1 is Coluna-1,
	mina(L1,C1),
	Valor1 is Valor+1.

checa_esquerda_acima(Linha,Coluna,Valor,Valor1):- Valor1 is Valor.

checa_acima(Linha,Coluna,Valor1,Valor2):- L1 is Linha-1,
	mina(L1,Coluna),
	Valor2 is Valor1+1.

checa_acima(Linha,Coluna,Valor1,Valor2):- Valor2 is Valor1.

checa_direita_acima(Linha,Coluna,Valor2,Valor3):- L1 is Linha-1,
	C1 is Coluna+1,
	mina(L1,C1),
	Valor3 is Valor2+1.

checa_direita_acima(Linha,Coluna,Valor2,Valor3):- Valor3 is Valor2.

checa_esquerda(Linha,Coluna,Valor3,Valor4):- C1 is Coluna-1,
	mina(Linha,C1),
	Valor4 is Valor3+1.

checa_esquerda(Linha,Coluna,Valor3,Valor4):- Valor4 is Valor3.

checa_direita(Linha,Coluna,Valor4,Valor5):- C1 is Coluna+1,
	mina(Linha,C1),
	Valor5 is Valor4+1.

checa_direita(Linha,Coluna,Valor4,Valor5):- Valor5 is Valor4.

checa_esquerda_abaixo(Linha,Coluna,Valor5,Valor6):- L1 is Linha+1,
	C1 is Coluna-1,
	mina(L1,C1),
	Valor6 is Valor5+1.

checa_esquerda_abaixo(Linha,Coluna,Valor5,Valor6):- Valor6 is Valor5.

checa_abaixo(Linha,Coluna,Valor6,Valor7):- L1 is Linha+1,
	mina(L1,Coluna),
	Valor7 is Valor6+1.

checa_abaixo(Linha,Coluna,Valor6,Valor7):- Valor7 is Valor6.

checa_direita_abaixo(Linha,Coluna,Valor7,Novo_valor):- L1 is Linha+1,
	C1 is Coluna+1,
	mina(L1,C1),
	Novo_valor is Valor7+1.

checa_direita_abaixo(Linha,Coluna,Valor7,Novo_valor):- Novo_valor is Valor7.