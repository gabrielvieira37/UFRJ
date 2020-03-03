%{
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <map>
#include <queue>
#include <utility>

using namespace std;

#define YYSTYPE Atributos
#define mp make_pair

int linha = 1;
int coluna = 1;


typedef string Tipo;

struct Atributos {
  string v;
  string c;
  Tipo t;
  int linha;
};

map<string,string> ts;

map<string,Tipo> tsVar;

int yylex();
int yyparse();
void yyerror(const char *);

queue<pair<string, string> > toDeclare;

void gera_programa( Atributos a );
string declareVars(Tipo t);
string geraNomeVar(Tipo t);
string geraNomeBp();
Atributos geraCodigoOperadorUn( string op, Atributos a );
Atributos geraCodigoOperador( Atributos a, string op, Atributos b );

int nBp = 0;
map<Tipo,int> nVar;

map<Tipo, string> conv = {
{ "I", "int" }, { "C", "char" }, { "S", "string" }, { "B", "boolean" },
{ "D", "real"}
};

map<string,Tipo> resOpr = {
{ "+II", "I" }, { "+ID", "D" }, { "+DI", "D" }, { "+DD", "D" },
{ "+CC", "S" }, { "+CS", "S" }, { "+SC", "S" }, { "+SS", "S" },
{ "+CI", "I" }, { "+IC", "I" },
{ "-II", "I" }, { "-ID", "D" }, { "-DI", "D" }, { "-DD", "D" },
{ "-CC", "C" }, { "-CI", "I" }, { "-IC", "I" },
{ "*II", "I" }, { "*ID", "D" }, { "*DI", "D" }, { "*DD", "D" },
{ "*CC", "C" }, { "*CI", "I" }, { "*IC", "I" },
{ "/II", "I" }, { "/ID", "D" }, { "/DI", "D" }, { "/DD", "D" },
{ "/CC", "C" }, { "/CI", "I" }, { "/IC", "I" },
{ "%II", "I" },
{ "!II", "I" }, { "!CC", "I" },
};


%}

%start S
%token CINT CREAL CCHAR CSTR 
%token TK_INT TK_REAL TK_STRING TK_BOOLEAN TK_CHAR
%token TK_ID TK_CONSOLE TK_SHIFTR TK_SHIFTL
%token TK_FOR TK_IN TK_2PT TK_IF TK_THEN TK_ELSE TK_ENDL
%token TK_GTE TK_LTE TK_AND TK_OR TK_NOT TK_EQ TK_NEQ TK_BEGIN TK_END
%token TK_TRUE TK_FALSE


%left TK_OR
%left TK_AND
%left TK_EQ TK_NEQ
%left '<' TK_LTE '>' TK_GTE 
%left '+' '-'
%left '*' '/' '%'
%left TK_NOT

%%

S : DECLVARS CMDS { $$.c = $1.c + $2.c; gera_programa($$);}
  ;  

DECLVARS : DECLVARS DECLVAR ';' { $$.c = $1.c + $2.c; }
         | DECLVAR ';' 
         ; 
    
DECLVAR : TK_INT VARS { $$.c = declareVars("I"); }         
          | TK_CHAR VARS { $$.c = declareVars("C"); }
          | TK_STRING VARS { $$.c = declareVars("S"); }
          | TK_BOOLEAN VARS { $$.c = declareVars("I");  }
          | TK_REAL VARS { $$.c = declareVars("D");  }
          ;
    
VARS : VARS ',' VAR { $$.c = $1.c + ", " + $3.c; $1.t = $$.t; }
       | VAR 
       ;
     
VAR : TK_ID '[' CINT ']' 
      {  
        $$.c = $1.v + "[" + $3.v + "]"; $1.t = $$.t; 
        toDeclare.push(mp($1.v, $3.v));
      }
      | TK_ID { $$.c = $1.v; $1.t = $$.t; toDeclare.push(mp($1.v, "")); }
      ;
    

CMDS : CMDS CMD { $$.c = $1.c + $2.c; }
       | CMD
       ;
  
CMD : ENTRADA ';'
      | SAIDA ';'
      | ATR ';'
      | FOR
      | IF
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
      ;
  
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
      string cond = geraNomeVar("I");  
      tsVar[cond] = "I";            
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
    |  TK_FOR TK_ID TK_IN '[' E TK_2PT E ']' BLOK ';'
    {  
      string cond = geraNomeVar("I");
      tsVar[cond] = "I";       
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
    
IF : TK_IF E TK_THEN BLOK TK_ELSE BLOK
    {     
      string bp1 = geraNomeBp(), bp2 = geraNomeBp();  
      $$.c = $2.c + "if (" + $2.v + ") goto " + bp1 + ";\n" + $6.c
        + "goto " + bp2 + ";\n" + bp1 + ":\n" + $4.c + bp2 + ":\n";
    }
    | TK_IF E TK_THEN BLOK TK_ELSE BLOK ';'
    {     
      string bp1 = geraNomeBp(), bp2 = geraNomeBp();  
      $$.c = $2.c + "if (" + $2.v + ") goto " + bp1 + ";\n" + $6.c
        + "goto " + bp2 + ";\n" + bp1 + ":\n" + $4.c + bp2 + ":\n";
    }
    | TK_IF E TK_THEN BLOK TK_ELSE IF ';'
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
    | TK_IF E TK_THEN BLOK ';'
    {
       string bp1 = geraNomeBp();  
       $$.c = $2.c + $2.v + " = !" + $2.v + ";\nif (" + $2.v + ") goto " 
       + bp1 + ";\n" + $4.c + bp1 + ":\n";
    }
   ;

BLOK : TK_BEGIN CMDS TK_END { $$.c = $2.c ; }
      | TK_BEGIN TK_END { $$.c = "\n"; }
      | CMD { $$.c = $1.c; }
      ;
  
ATR : TK_ID '=' E
      { $$.v = $3.v;
        if (tsVar[$1.v] == "S"){
          $$.c = $3.c + "strcpy(" + $1.v + "," + $3.v + ");\n";
        } else {
          $$.c = $3.c + $1.v + " = " + $3.v + ";\n";
        }
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
    { 
      $$.v = geraNomeVar("I");
      $$.c = $3.c + $$.v + " = " + $1.v + "[" + $3.v + "];\n"; 
      $$.t = tsVar[$1.v];                
    }
  | TK_ID     { $$.c = ""; $$.v = $1.v; $$.t = tsVar[$1.v]; }
  | CINT      { $$.c = ""; $$.v = $1.v; $$.t = "I"; } 
  | CREAL     { $$.c = ""; $$.v = $1.v; $$.t = "D"; } 
  | CSTR      { $$.c = ""; $$.v = $1.v; $$.t = "S"; } 
  | CCHAR     { $$.c = ""; $$.v = $1.v; $$.t = "C"; } 
  | TK_TRUE   { $$.c = ""; $$.v = "1"; $$.t = "I"; }   
  | TK_FALSE  { $$.c = ""; $$.v = "0"; $$.t = "I"; }     
  | '(' E ')' { $$ = $2; }
  ;

%%

#include "lex.yy.c"

string cabecalho = 
"#include <iostream>\n"
"#include <stdio.h>\n"
"#include <string.h>\n"
"#include <cstring>\n\n" 
"using namespace std;\n\n"
"int main() {\n";

string fim_programa = 
"return 0;\n"
"}\n";

string declareVars(Tipo t){
  string ret = "";
  while (!toDeclare.empty()){
    pair<string, string> x = toDeclare.front();
    tsVar[x.first] = t;

    if (t == "I" || t == "B") ret += "int " + x.first;
    else if (t == "C") ret += "char " + x.first;
    else if (t == "S") ret += "char " + x.first + "[257]";
    else if (t == "D") ret += "double " + x.first;

    ret += ";\n";
    toDeclare.pop();
  }  
  return ret;
}


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

string geraNomeVar(Tipo t) {
  string aux = "";
  string name_type = conv[t] ;

  if (t == "S") { aux = "[257]"; name_type = "char";}

  if (t == "D") name_type = "double";

  string nome = "t_" + name_type + "_" + to_string( nVar[t]++ );

  ts[nome] = name_type + " " + nome + aux + ";\n";

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


Tipo buscaTipoOperacao( Tipo a, string op, Tipo b ) {
  if (op == ">" || op == "<" || op == ">=" || op == "<=" || op == "==" || op == "!="
      || op == "&&" || op == "||" || op == "!" ){
      if (a == b) return "I";
      if (a == "I" && b == "D") return "I";
      if (a == "D" && b == "I") return "I";
      if (a == "I" && b == "C") return "I";
      if (a == "C" && b == "I") return "I";
      if (a == "S" && b == "C") return "I";
      if (a == "C" && b == "S") return "I";
  }
  return resOpr[op + a + b];
}


Atributos geraCodigoOperador( Atributos a, string op, Atributos b ) {
  Atributos r;
  if (a.t.empty()) { a.t = tsVar[a.v];}
  if (b.t.empty()) { b.t = tsVar[b.v];}

  
  r.t = buscaTipoOperacao( a.t, op, b.t );
  if( r.t == "" ) {
    string temp = "Operacao '" + op + "' inválida entre " + conv[a.t] + " e " + conv[b.t]; 
    yyerror( temp.c_str() );
  } 
  
  r.c = a.c + b.c;
  r.v = geraNomeVar( r.t );
  tsVar[r.v] = r.t;
  
  if ( (a.t == "S" || b.t == "S" || (a.t == "C" && b.t == "C")) && 
  (op == "+" || op == ">" || op == "<" || op == ">=" || op == "<=" || op == "==" || op == "!=")){

    if (op == "+"){
      if (a.t == "C" && b.t == "C"){
        r.c += "strcpy(" + r.v + ", \"  \");\n";
        r.c += r.v + "[0] = " + a.v + ";\n";
        r.c += r.v + "[1] = " + b.v + ";\n"; 
      } else if (a.t == "C" && b.t == "S") {
        r.c += "strcpy(" + r.v + ", \" \");\n";
        r.c += r.v + "[0] = " + a.v + ";\n"; 
        r.c += "strncat(" + r.v + ", " + b.v + ", 256);\n"; 
      } else if (a.t == "S" && b.t == "C") {
        r.c += "strcpy(" + r.v + ", " + a.v + ");\n";
        string novo = geraNomeVar( "I" );
        tsVar[novo] = "I";
        r.c += novo = "strlen(" + r.v + ");\n";
        r.c += novo = novo + " + 1;\n";
        r.c += r.v + "[" + novo + ")] = " + b.v + ";\n"; 
      } else {
        string novo = geraNomeVar( "I" );
        tsVar[novo] = "I";
        r.c += "strcpy(" + r.v + "," + a.v + ");\n";
        r.c += "strncat(" + r.v + ", " + b.v + ", 256);\n"; 
      }
    } else {
      
      string v1 = a.v, v2 = b.v;

      if (a.t == "C"){
        string novo = geraNomeVar( "S" );
        tsVar[novo] = "S";
        r.c += novo + "[0] = " + a.v + ";\n";
        v1 = novo;
      }

      if (b.t == "C"){
        string novo = geraNomeVar( "S" );
        tsVar[novo] = "S";
        r.c += novo + "[0] = " + b.v + ";\n";
        v2 = novo;
      }

      string novo = geraNomeVar( "I" );
      tsVar[novo] = "I";
      r.c += novo + " = strcmp(" + v1 + "," + v2 + ");\n";

      if (op == ">"){
        r.c += r.v + " = " + novo + " > 0;\n";
      } else if (op == "<") {
        r.c += r.v + " = " + novo + " < 0 ;\n";
      } else if (op == "==") {
        r.c += r.v + " = " + novo + " == 0;\n";
      } else if (op == "!=") {
        r.c += r.v + " = " + novo + " != 0;\n";
      } else if (op == ">=") {
        r.c += r.v + " = " + novo + " >= 0;\n";
      } else if (op == "<=") {
        r.c += r.v + " = " + novo + " <= 0;\n";
      } 
    }

  } else {
    r.c +=  r.v + " = " + a.v + op + b.v + ";\n";
  }

  return r;
}

Atributos geraCodigoOperadorUn( string op, Atributos a ) {
  Atributos r;
  
  r.t = buscaTipoOperacao( a.t, op, a.t );
  if( r.t == "" ) {
    string temp = "Operacao '" + op + "' inválida para " + a.t; 
    yyerror( temp.c_str() );
  }
  
  r.v = geraNomeVar( r.t );
  r.c = a.c + r.v + " = !" + a.v + ";\n";
  return r;
}

int main( int argc, char* st[]) {
  yyparse();
  
  return 0;
}