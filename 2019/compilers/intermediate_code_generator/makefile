all: saida entrada.txt
	./saida < entrada.txt

lex.yy.c: tradutor.l
	lex tradutor.l

saida: lex.yy.c 
	g++ lex.yy.c -o saida -lfl
	
clean:
	rm saida lex.yy.c
