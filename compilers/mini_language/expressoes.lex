%{
int token( int );
%}
DIGITO  [0-9]
LETRA   [A-Za-z_]
INT     {DIGITO}+
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*
STRING  (\"([^\"]|\"\"|\\\")*\")

%%

"\t"       { coluna += 4; }
" "        { coluna++; }
"\n"	   { linha++; coluna = 1; }

{INT} 	   { return token( CINT ); }
{DOUBLE}   { return token( CDOUBLE ); }
{STRING}      { return token( CSTR ); }

"var"	   { return token( TK_VAR ); }

"console"  { return token( TK_CONSOLE ); }
">>"       { return token( TK_SHIFTR ); }
"<<"       { return token( TK_SHIFTL ); }
"for"      { return token( TK_FOR ); }
"in"       { return token( TK_IN ); }
".."       { return token( TK_2PT ); }
"if"       { return token( TK_IF ); }
"then"     { return token( TK_THEN ); }
"else"     { return token( TK_ELSE ); }
">="       { return token( TK_GTE ); }      
"<="       { return token( TK_LTE ); }    
"=="       { return token( TK_EQ ); }  
"<>"       { return token( TK_NEQ ); }
"or"       { return token( TK_OR ); }
"and"      { return token( TK_AND ); }
"not"      { return token( TK_NOT ); }
"endl"     { return token( TK_ENDL); }
"begin"    { return token( TK_BEGIN ); }
"end"      { return token( TK_END ); }

{ID}       { return token( TK_ID ); }
.          { return token( *yytext ); }

%%
int token( int tk ) {
 yylval.v = yytext;
 coluna += strlen(yytext);
 yylval.linha = linha;
 yylval.c = "";
 return tk;
}