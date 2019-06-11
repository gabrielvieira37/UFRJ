all: programa_gerado
	./programa_gerado

programa_gerado: codigo.cc
	g++ -std=c++17 main_programa_gerado.cc codigo.cc -o programa_gerado 

codigo.cc: compilador entrada.txt
	./compilador < entrada.txt > codigo.cc

lex.yy.c: gera_listas.lex
	lex gera_listas.lex

y.tab.c: gera_listas.y
	yacc gera_listas.y

compilador: lex.yy.c y.tab.c
	g++ -std=c++11 -Wno-deprecated-register -o compilador y.tab.c -lfl