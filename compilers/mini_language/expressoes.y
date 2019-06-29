%{
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <map>

using namespace std;

#define YYSTYPE Atributos

int linha = 1;
int coluna = 1;

struct Atributos {
  string v;
  string c;
  int linha;
};

map<string,string> ts;

int yylex();
int yyparse();
void yyerror(const char *);

void gera_programa( Atributos a );
string geraNomeVar();
string geraNomeBp();
Atributos geraCodigoOperadorUn( string op, Atributos a );
Atributos geraCodigoOperador( Atributos a, string op, Atributos b );

int nVar = 0;
int nBp = 0;

%}

%start S
%token CSTR CINT CDOUBLE TK_ID TK_VAR TK_CONSOLE TK_SHIFTR TK_SHIFTL
%token TK_FOR TK_IN TK_2PT TK_IF TK_THEN TK_ELSE TK_ENDL
%token TK_GTE TK_LTE TK_AND TK_OR TK_NOT TK_EQ TK_NEQ TK_BEGIN TK_END

%left TK_OR
%left TK_AND
%left TK_EQ TK_NEQ
%left '<' TK_LTE '>' TK_GTE 
%left '+' '-'
%left '*' '/' '%'
%left TK_NOT

%%

S : CMDS
    { gera_programa( $1 ); }
  ;  

CMDS : CMDS CMD ';' { $$.c = $1.c + $2.c; }
     | CMD ';'
     ;
  
CMD : DECLVAR
    | ENTRADA 
    | SAIDA 
    | ATR 
    | FOR
    | IF
    ;
    
DECLVAR : TK_VAR VARS
        { $$.c = "int " + $2.c + ";\n"; }
        ;
    
VARS : VARS ',' VAR  { $$.c = $1.c + ", " + $3.c; }
     | VAR
     ;
     
VAR : TK_ID '[' CINT ']'  
      { $$.c = $1.v + "[" + $3.v + "]"; }
    | TK_ID                
      { $$.c = $1.v; }
    ;
    
ENTRADA : TK_CONSOLE TK_SHIFTR REC_E { $$.c = $3.c; }
        ;

REC_E : REC_E TK_SHIFTR TK_ID { $$.c = $1.c + "cin >> " + $3.v + ";\n"; }
        | REC_E TK_SHIFTR TK_ID '[' E ']' 
        { 
          $$.c = $5.c + $1.c + "cin >> " + $3.v + "[" + $5.v + "]" + ";\n"; ; 
        }
        | TK_ID  { $$.c = "cin >> " + $1.v + ";\n"; }
        | TK_ID '[' E ']' 
        { $$.c = $3.c + "cin >> " + $1.v + "[" + $3.v + "]" + ";\n"; }
  
SAIDA : TK_CONSOLE TK_SHIFTL REC_S { $$.c = $3.c; }
      ;

REC_S : REC_S TK_SHIFTL CSTR { $$.c = $1.c + "cout << " + $3.v + ";\n"; }
        | REC_S TK_SHIFTL E { $$.c = $3.c + $1.c + "cout << " + $3.v + ";\n"; }
        | REC_S TK_SHIFTL TK_ENDL { $$.c = $3.c + $1.c + "cout << endl;\n"; }
        | CSTR  { $$.c = "cout << " + $1.v + ";\n"; }
        | E { $$.c = $1.c + "cout << " + $1.v + ";\n"; }
        | TK_ENDL { $$.c = $1.c + "cout << endl;\n"; }
      ;
        
FOR : TK_FOR TK_ID TK_IN '[' E TK_2PT E ']' BLOK  
    {  
      string cond = geraNomeVar();
      string bp1 = geraNomeBp(), bp2 = geraNomeBp();
      $$.c = $5.c + $7.c 
          + $2.v + " = " + $5.v + ";\n"
          + bp1 + ":\n" + cond + " = " + $2.v + " > " + $7.v + ";\n"
          + "if( " + cond + ") goto " + bp2 + ";\n"
          + $9.c
          + $2.v + " = " + $2.v + " + 1;\n"
          + "goto " + bp1 + ";\n"
          + bp2 + ":\n";
    }
    ;
    
IF :  TK_IF E TK_THEN BLOK TK_ELSE BLOK
    {     
      string bp1 = geraNomeBp(), bp2 = geraNomeBp();  
      $$.c = $2.c + "if (" + $2.v + ") goto " + bp1 + ";\n" + $6.c
        + "goto " + bp2 + ";\n" + bp1 + ":\n" + $4.c + bp2 + ":\n";
    }
    | TK_IF E TK_THEN BLOK
    {
       string bp1 = geraNomeBp();  
       $$.c = $2.c + $2.v + " = !" + $2.v + ";\nif (" + $2.v + ") goto " 
       + bp1 + ";\n" + $4.c + bp1 + ":\n"; 
    }
   ;

BLOK : TK_BEGIN CMDS TK_END { $$.c = $2.c ; }
      | TK_BEGIN TK_END { $$.c = "\n"; }
      | CMD { $$.c = $1.c; }

ATR : TK_ID '=' E
      { $$.v = $3.v;
        $$.c = $3.c + $1.v + " = " + $3.v + ";\n";
      }
    | TK_ID '[' E ']' '=' E 
      { $$.c = $3.c + $6.c 
             + $1.v + "[" + $3.v + "] = " + $6.v + ";\n";
        $$.v = $6.v;
      }
    ;
  
E : E '+' E     { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E '-' E     { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E '*' E     { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E '/' E     { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E '<' E     { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E '>' E     { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E '%' E     { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E TK_GTE E  { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E TK_LTE E  { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E TK_EQ E   { $$ = geraCodigoOperador( $1, $2.v, $3); }
  | E TK_NEQ E  { $$ = geraCodigoOperador( $1, "!=", $3); }
  | E TK_AND E  { $$ = geraCodigoOperador( $1, "&&", $3); }
  | E TK_OR E   { $$ = geraCodigoOperador( $1, "||", $3); }
  | TK_NOT E    { $$ = geraCodigoOperadorUn( "!", $2); }
  | V
  ;
  
V : TK_ID '[' E ']' 
    { $$.v = geraNomeVar();
      $$.c = $3.c + $$.v + " = " + $1.v + "[" + $3.v + "];\n";                    
    }
  | TK_ID     { $$.c = ""; $$.v = $1.v; }
  | CINT      { $$.c = ""; $$.v = $1.v; } 
  | '(' E ')' { $$ = $2; }
  ;

%%

#include "lex.yy.c"

string cabecalho = 
"#include <iostream>\n\n" 
"using namespace std;\n\n"
"int main() {\n";

string fim_programa = 
"return 0;\n"
"}\n";

void yyerror( const char* st ) {
   puts( st ); 
   printf( "Linha %d, coluna %d, proximo a: %s\n", linha, coluna, yytext );
   exit( 0 );
}

string declara_variaveis() {
  string saida;
  
  for( auto p : ts ) 
    saida += p.second;
  
  return saida;
}

string geraNomeVar() {

  string nome = "t_" + to_string( nVar++ );

  ts[nome] = "int " + nome + ";\n";

  return nome;
}

string geraNomeBp() {
  char buf[20] = "";  
  sprintf( buf, "bp%d", nBp++ );  
  return buf;
}

void gera_programa( Atributos a ) {
  cout << cabecalho 
       << declara_variaveis()
       << a.c
       << fim_programa
       << endl;
}

Atributos geraCodigoOperador( Atributos param1, string opr, Atributos param2 ) {
  Atributos r;
  
  r.v = geraNomeVar();
  r.c = param1.c + param2.c + 
             "  " + r.v + " = " + param1.v + opr + param2.v + ";\n";
  
  return r;
}

Atributos geraCodigoOperadorUn( string op, Atributos a ) {
  Atributos r;
  
  r.v = geraNomeVar();
  r.c = a.c + r.v + " = !" + a.v + ";\n";
  return r;
}

int main( int argc, char* st[]) {
  yyparse();
  
  return 0;
}