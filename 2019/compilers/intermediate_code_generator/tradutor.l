%{
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <map>

using namespace std;
int token;

void A();
void E();
void E_linha();
void F();
void T();
void T_linha();
void casa( int );

string lexema; 

enum { tk_int = 256, tk_char, tk_double, 
        tk_id, tk_cte_num, tk_print, tk_string };

%}

WS  [ \n\t]
DIGITO  [0-9]
LETRA [A-Za-z_]
STRING  (\"([^\"]|\"\"|\\\")*\")
INT {DIGITO}+
ID  {LETRA}({LETRA}|{DIGITO})*
NUM   {INT}("."{INT})?([Ee]("+"|"-")?{INT})?

%%

{WS}      { }
{NUM}     { lexema = yytext; return tk_cte_num; }

"char"    { return tk_char; }
"int"   { return tk_int; }
"double"  { return tk_double; }

"print" {return tk_print;}

{STRING}	{ lexema = yytext; return tk_string;}

{ID}    {lexema = yytext;  return tk_id; }

.   { return yytext[0]; }

%%

int next_token() {
  return yylex();
}


void A() {
  switch(token){

  case tk_id:
    cout << lexema << " ";
    casa( tk_id );
    casa( '=' );
    E();
    cout << "=" << endl ;
    break;
  case tk_print:
    casa(tk_print);
    F();
    cout << endl;
    break;
  case ';':
    casa(';');
    break;  
  }
}

void E() {
  T();
  E_linha();
}

void E_linha() {
  switch( token ) {
    case '+' : 
        casa( '+' ); 
        T(); 
        cout << "+ "; 
        E_linha(); 
        break;
    case '-' : 
        casa( '-' ); 
        T(); 
        cout << "- "; 
        E_linha(); 
        break;
  }
}

void T() {
  F();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' :
        casa( '*' ); 
        F(); 
        cout << "* "; 
        T_linha(); 
        break;
    case '/' : 
        casa( '/' ); 
        F(); 
        cout << "/ "; 
        T_linha(); 
        break;
  }
}

void F() {
  switch( token ) {
    case tk_id : 
        casa( tk_id );
        cout << lexema << " @ " ;
        break;
    case tk_cte_num : 
        casa( tk_cte_num ); 
        cout << lexema << " ";
        break;
    case '(' : 
        casa( '(' ); 
        E(); 
        casa( ')') ; 
        break;
    case tk_string:
        casa(tk_string);
        cout << lexema << " ";
        break;
  }
}

void casa( int esperado ) {
  if( token == esperado ){
    token = next_token();
    }
  else {
      cout << "Esperado " <<  esperado  
     << " , encontrado: " <<  token << endl;
     exit( 1 );
  }
}

int main() {
  token = next_token();
  while(token!=0){
    A();
  }
  
  return 0;
}