:- dynamic valor/3.
:- abolish(contador/1).
:- dynamic contador/1.

:- [ambiente], [mina].

contador(1).

/**-------------------------------------------------------------------------------------------*/

/** Executa o movimento */
posicao(Linha,Coluna):-
	escreve_movimento(Linha,Coluna),
	not(mina(Linha,Coluna)),!,
	explora_ambiente(Linha,Coluna).

posicao(_,_):-
	end_game.

/**-------------------------------------------------------------------------------------------*/

/** Cria o arquivo jogo.pl */
cria_retorno :- open('jogo.pl',write, Stream), close(Stream).

/** Escreve no arquivo e no console os valores das casas abertas na jogada*/
escreve_configuracao(Linha,Coluna,Valor) :-
	write('valor('),
	write(Linha),
	write(','),
	write(Coluna),
	write(','),
	write(Valor),
	write(').\n '),
	open('jogo.pl',append, Stream),
	nl(Stream),
	write(Stream, 'valor('),
	write(Stream, Linha),
	write(Stream, ','),
	write(Stream, Coluna),
	write(Stream, ','),
	write(Stream, Valor),
	write(Stream, '). '),
	close(Stream).
escreve_configuracao(_,_,_).

/** Escreve o movimento no arquivo jogo.pl */
escreve_movimento(Linha,Coluna):-
	contador(Indice),
	contador_increment,

	open('jogo.pl',append, Stream),
	nl(Stream),
	write(Stream, '/*Jogada '),
	write(Stream, Indice),
	write(Stream, '*/'),
	nl(Stream),
	write(Stream, 'posicao('),
	write(Stream, Linha),
	write(Stream, ','),
	write(Stream, Coluna),
	write(Stream, '). '),
	nl(Stream),
	write(Stream, '/*Ambiente*/'),
	close(Stream).


/**-------------------------------------------------------------------------------------------*/

/** Escreve o fim do jogo no arquivo */
end_game:-
	write("Fim de jogo"),
	open('jogo.pl',append, Stream),
	nl(Stream),
	write(Stream, 'jogo encerrado'),
	close(Stream).

/**-------------------------------------------------------------------------------------------*/

/** Checar os campos em volta da posicao selecionada */
valores_dos_campos(Linha,Coluna):-
	Linha1 is Linha-1, Linha3 is Linha+1,
	Coluna1 is Coluna-1, Coluna3 is Coluna+1,
	explora_ambiente(Linha1,Coluna1),
	explora_ambiente(Linha1,Coluna),
	explora_ambiente(Linha1,Coluna3),
	explora_ambiente(Linha,Coluna1),
	explora_ambiente(Linha,Coluna3),
	explora_ambiente(Linha3,Coluna1),
	explora_ambiente(Linha3,Coluna),
	explora_ambiente(Linha3,Coluna3).

/** Caso base para quando as verificações dos campos falham. */
valores_dos_campos(_,_).

/**-------------------------------------------------------------------------------------------*/

/** Se o campo tiver valor diferente de 0 escreve-o */
explora_ambiente(Linha,Coluna):-
	valor(Linha,Coluna,Ponto),
	Ponto > 0,
	escreve_configuracao(Linha,Coluna,Ponto),
	!,
	retract(valor(Linha,Coluna,Ponto)).

/** Se o campo tiver valor 0 verica os adjacentes */
explora_ambiente(Linha,Coluna):-
	tabuleiro(A,B),
	valor(Linha,Coluna,Ponto),!,
	escreve_configuracao(Linha,Coluna,Ponto),
	retract(valor(Linha,Coluna,Ponto)),

	/** Verifica os limites do tabuleiro */

	Linha>= 1,Linha =<A, Coluna>=1,Coluna=<B,

	valores_dos_campos(Linha,Coluna).

/** Caso base de o campo ou não existir ou já ter sido contado */
explora_ambiente(_,_).


/**-------------------------------------------------------------------------------------------*/

/**Função para fazer o incremento do contador de jogadas*/
contador_increment:-
	contador(Indice),!,
	Indice2 is Indice+1,
	retract(contador(Indice)),
	assert(contador(Indice2)).

/**-------------------------------------------------------------------------------------------*/

inicio :- cria_retorno.

















