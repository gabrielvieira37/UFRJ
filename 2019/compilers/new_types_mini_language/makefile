codigo.cc: mlc exemplo.ml
	./mlc < exemplo.ml > codigo.cc

y.tab.c: tipos.y
	yacc tipos.y

mlc: lex.yy.c y.tab.c
	g++ -std=c++11 -o mlc y.tab.c -lfl