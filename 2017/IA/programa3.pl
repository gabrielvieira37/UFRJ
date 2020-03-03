:- abolish(contador/2).
:- dynamic contador/2.

:- abolish(c_checa_se_posicao_esta_no_tabuleiro/2).
:- dynamic c_checa_se_posicao_esta_no_tabuleiro/2.

:- dynamic valor/3.

:- abolish(board/3).
:- dynamic board/3.

:- abolish(bomb/2).
:- dynamic bomb/2.

:-abolish(valor2/3).
:-dynamic valor2/3.

:- [ambiente], [mina].

/**Valor inicial de uma mina*/
bomb(-1,-1).


/**Acumuladores para as jogadas*/
contador(0,0).
contador(1,0).
contador(2,0).
contador(3,3).
contador(4,0).
contador(5,0).
contador(6,0).
contador(7,0).

/**-------------------------------------------------------------------------------------------*/

/**Faz jogada e imprime as posições que se abrem*/
abre_posicao(Linha,Coluna):-
	not(mina(Linha,Coluna)),!,
	retract(valor2(Linha,Coluna,_)),
	incrementa_jogada(5),
	imprime_jogada_feita(Linha,Coluna),
	imprime_posicoes_abertas(Linha,Coluna).

/**Se for uma mina, Game Over*/
abre_posicao(Linha,Coluna):-
	imprime_jogada_feita(Linha,Coluna),
	incrementa_jogada(7),
	game_overl,
	fail.

/**-------------------------------------------------------------------------------------------*/

/**Funções de término de jogo para casos de vitória ou derrota*/
game_overl:- nl, write('      _.-^^---....,,--'), nl,      
	write(' _--                  --_'), nl,  
	write('<                        >)'), nl,
	write('|                         | '), nl,
	write(' |-_                   _./  '), nl,
	write('   ```--. . , ; .--''''       '), nl,
	write('          | |   |             '), nl,
	write('       .-=||  | |=-.   '), nl,
	write('       `-=#$%&%$#=-''   '), nl,
	write('          | ;  :|     '), nl,
	write(' _____.,-#%&$@%#&#~,._____'), nl,nl,
	write("Game Over - Bot Lost :(").

game_overw:-write('       $$$$'),nl,
	write('       $$  $'),nl,
	write('       $  $$'),nl,
	write('       $  $$'),nl,
	write('       $$  $$'),nl,
	write('        $    $$'),nl,
	write('        $$    $$$'),nl,
	write('         $$     $$'),nl,
	write('         $$      $$'),nl,
	write('          $       $$'),nl,
	write('    $$$$$$$        $$'),nl,
	write('  $$$               $$$$$$'),nl,
	write(' $$    $$$$            $$$'),nl,
	write(' $   $$$  $$$            $$'),nl,
	write(' $$        $$$            $'),nl,
	write('  $$    $$$$$$            $'),nl,
	write('  $$$$$$$    $$           $'),nl,
	write('  $$       $$$$           $'),nl,
	write('   $$$$$$$$$  $$         $$'),nl,
	write('    $        $$$$     $$$$'),nl,
	write('    $$     $$$$$$    $$$$$$'),nl,
	write('     $$$$$$    $$  $$'),nl,
	write('       $     $$$ $$$'),nl,
	write('        $$$$$$$$$$'),nl,
	write("Game Over - Bot Won! :D").

/**-------------------------------------------------------------------------------------------*/

/**Função para imprimir os valores da jogada*/
imprime_posicoes_abertas(Linha,Coluna):-
	valor(Linha,Coluna,Valor),
	Valor > 0,
	imprime_configuracao(Linha,Coluna,Valor),
	!,
	retract(valor(Linha,Coluna,Valor)).

/**Se o valor da posição for 0, abre os vizinhos*/
imprime_posicoes_abertas(Linha,Coluna):-
	tabuleiro(Linhas,Colunas),
	valor(Linha,Coluna,Valor),!,
	imprime_configuracao(Linha,Coluna,Valor),
	retract(valor(Linha,Coluna,Valor)),
	Linha >= 1,Linha =< Linhas, Coluna >= 1,Coluna =< Colunas,
	checa_vizinhos_abertos(Linha,Coluna).

imprime_posicoes_abertas(_,_).

/**-------------------------------------------------------------------------------------------*/

/**Faz checagem dos vizinhos para impressão*/
checa_vizinhos_abertos(Linha,Coluna):-
	L1 is Linha-1, L2 is Linha+1,
	C1 is Coluna-1, C2 is Coluna+1,
	imprime_posicoes_abertas(L1,C1),
	imprime_posicoes_abertas(L1,Coluna),
	imprime_posicoes_abertas(L1,C2),
	imprime_posicoes_abertas(Linha,C1),
	imprime_posicoes_abertas(Linha,C2),
	imprime_posicoes_abertas(L2,C1),
	imprime_posicoes_abertas(L2,Coluna),
	imprime_posicoes_abertas(L2,C2).

checa_vizinhos_abertos(_,_).

/**-------------------------------------------------------------------------------------------*/


/**Checa se é uma posição válida para jogar*/
checa_se_posicao_esta_no_tabuleiro(Linha,Coluna):-
	tabuleiro(Linhas,Colunas),
	not(board(Linha,Coluna,_)),
	not(bomb(Linha,Coluna)),
	Linha >= 1,Linha =< Linhas,
	Coluna >= 1,Coluna =< Colunas,!,
	incrementa_jogada(0),
	assert(c_checa_se_posicao_esta_no_tabuleiro(Linha,Coluna)).

checa_se_posicao_esta_no_tabuleiro(_,_).

procura_bombas_nos_vizinhos(Linha,Coluna):-
	L1 is Linha-1, L3 is Linha+1,
	C1 is Coluna-1, C3 is Coluna+1,!,
	checa_mina(L1,C1),
	checa_mina(L1,Coluna),
	checa_mina(L1,C3),
	checa_mina(Linha,C1),
	checa_mina(Linha,C3),
	checa_mina(L3,C1),
	checa_mina(L3,Coluna),
	checa_mina(L3,C3).

procura_bombas_nos_vizinhos(_,_).

/**-------------------------------------------------------------------------------------------*/

/**Imprime a configuração do tabuleiro com a jogada feita*/
imprime_configuracao(L,C,Valor) :-

	incrementa_jogada(2),
	assert(board(L,C,Valor)),

	nl,
	write('valor('),
	write(L),
	write(','),
	write(C),
	write(','),
	write(Valor),
	write('). '),
	nl.

imprime_configuracao(_,_,_).

/**Imprime jogada*/
imprime_jogada_feita(L,C):-
	incrementa_jogada(6),
	contador(6,Contador),

	write("Joga: "),
	write(L), write(","),write(C),write("\n"),
	nl,
	write('/*Jogada '),
	write(Contador),
	write("*/"),
	nl,
	write('posicao('),
	write(L),
	write(','),
	write(C),
	write('). '),
	nl,
	write('/*Ambiente*/').

/**-------------------------------------------------------------------------------------------*/

/**Função inicial*/
inicio :-
	posiciona_minas,
	checa_estado_do_jogo(0).

/**-------------------------------------------------------------------------------------------*/

/**Posiciona as minas no tabuleiro*/
posiciona_minas:-
	forall(mina(Linha,Coluna), assert(valor2(Linha,Coluna,-1))),
	forall(valor(Linha,Coluna,Valor), assert(valor2(Linha,Coluna,Valor))).

/**-------------------------------------------------------------------------------------------*/

/**Procura as posições por uma jogada*/
checa_posicoes_por_jogada(Linha,Coluna,Valor):-
	reseta_contador(0),
	reseta_contador(1),
	retractall(c_checa_se_posicao_esta_no_tabuleiro(_,_)),

	%Determina os campos em volta
	L1 is Linha-1, L3 is Linha+1,
	C1 is Coluna-1, C3 is Coluna+1,

	checa_se_posicao_esta_no_tabuleiro(L1,C1),
	checa_se_posicao_esta_no_tabuleiro(L1,Coluna),
	checa_se_posicao_esta_no_tabuleiro(L1,C3),
	checa_se_posicao_esta_no_tabuleiro(Linha,C1),
	checa_se_posicao_esta_no_tabuleiro(Linha,C3),
	checa_se_posicao_esta_no_tabuleiro(L3,C1),
	checa_se_posicao_esta_no_tabuleiro(L3,Coluna),
	checa_se_posicao_esta_no_tabuleiro(L3,C3),

	procura_bombas_nos_vizinhos(Linha,Coluna),

	contador(1,BombasEmVolta),

	BombasEmVolta = Valor,!,

	forall(
	    (c_checa_se_posicao_esta_no_tabuleiro(A,B)

	     ),	(write("Fez jogada\n"),abre_posicao(A,B))
	),
	retractall(c_checa_se_posicao_esta_no_tabuleiro(_,_)).

checa_posicoes_por_jogada(_,_,_).

/**-------------------------------------------------------------------------------------------*/

/**Checa se encontra alguma bomba nos vizinhos*/
checa_vizinhos_por_bomba(Linha,Coluna,Valor):-
	reseta_contador(0),
	reseta_contador(1),
	retractall(c_checa_se_posicao_esta_no_tabuleiro(_,_)),

	L1 is Linha-1, L3 is Linha+1,
	C1 is Coluna-1, C3 is Coluna+1,

	checa_se_posicao_esta_no_tabuleiro(L1,C1),
	checa_se_posicao_esta_no_tabuleiro(L1,Coluna),
	checa_se_posicao_esta_no_tabuleiro(L1,C3),
	checa_se_posicao_esta_no_tabuleiro(Linha,C1),
	checa_se_posicao_esta_no_tabuleiro(Linha,C3),
	checa_se_posicao_esta_no_tabuleiro(L3,C1),
	checa_se_posicao_esta_no_tabuleiro(L3,Coluna),
	checa_se_posicao_esta_no_tabuleiro(L3,C3),

	procura_bombas_nos_vizinhos(Linha,Coluna),

	contador(0,PosicoesFavoraveis),
	contador(1,BombasEmVolta),

	PosicoesPossiveis is Valor-BombasEmVolta,
	PosicoesFavoraveis = PosicoesPossiveis,!,

	forall(c_checa_se_posicao_esta_no_tabuleiro(A,B),
	       (
		   incrementa_jogada(4),
		   decrementa_contador(3),
		   incrementa_jogada(5),

		   write("Mina na posicao: "),write(A),write(","),
		   write(B),write("\n"),
		   assert(bomb(A,B)),
		   retract(valor2(A,B,_)),
		   condicao_vitoria
	       )
	      ).

checa_vizinhos_por_bomba(_,_,_).



checa_mina(Linha,Coluna):- bomb(Linha,Coluna), incrementa_jogada(1).
checa_mina(_,_).

/**-------------------------------------------------------------------------------------------*/

/**Checa os estados do jogo para ver se existe alguma jogada sensata a ser feita*/
checa_estado_do_jogo(EstadoAnterior):-
	contador(2,PecasNoTabuleiro),
	contador(5,EstadoAtual),

	PecasNoTabuleiro >0,
	EstadoAtual \= EstadoAnterior,!,

	forall(board(Linha,Coluna,Valor),checa_vizinhos_por_bomba(Linha,Coluna,Valor)),

	forall(board(Linha,Coluna,Valor),checa_posicoes_por_jogada(Linha,Coluna,Valor)),

	checa_estado_do_jogo(EstadoAtual).

checa_estado_do_jogo(EstadoAnterior):-
	not(condicao_vitoria),!,
	chutar_jogada(Linha,Coluna),
	abre_posicao(Linha,Coluna),
	contador(7,A),	A=<0,
	checa_estado_do_jogo(EstadoAnterior).

checa_estado_do_jogo(_):-game_overw.

/**-------------------------------------------------------------------------------------------*/

/**Funções auxiliares*/
incrementa_jogada(Tipo):-
	contador(Tipo,I),
	I2 is I+1,
	retract(contador(Tipo,I)),
	assert(contador(Tipo,I2)).

decrementa_contador(Tipo):-
	contador(Tipo,I),
	I2 is I-1,
	retract(contador(Tipo,I)),
	assert(contador(Tipo,I2)).

reseta_contador(Tipo):-
	contador(Tipo,I),
	retract(contador(Tipo,I)),
	assert(contador(Tipo,0)).

chutar_jogada(Linha,Coluna):-
	findall([A,B], board(A,B,_),VisibleTiles),
	findall([C,D], bomb(C,D),KnownBombs),
	findall([X,Y], valor2(X,Y,_),V),
	subtract(V, VisibleTiles, V1),
	subtract(V1, KnownBombs, V2),

	random_member([Linha,Coluna],V2).


condicao_vitoria:-
	contador(3,B),
	B =< 0.





















