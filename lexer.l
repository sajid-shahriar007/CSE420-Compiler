%{
#include <stdio.h>
#include "parser.tab.h" 
%}

%option noyywrap

digit       [0-9]
letter      [a-zA-Z_]
id          {letter}({letter}|{digit})*
number      {digit}+

%%
"int"       { return KEYWORD_INT; }
"float"     { return KEYWORD_FLOAT; }
"void"      { return KEYWORD_VOID; }
"if"        { return KEYWORD_IF; }
"else"      { return KEYWORD_ELSE; }
"while"     { return KEYWORD_WHILE; }
"for"       { return KEYWORD_FOR; }
"return"    { return KEYWORD_RETURN; }
"struct"    { return KEYWORD_STRUCT; }
"switch"    { return KEYWORD_SWITCH; }
"case"      { return KEYWORD_CASE; }
"default"   { return KEYWORD_DEFAULT; }
"break"     { return KEYWORD_BREAK; }

"=="        { return OP_EQ; }
"<="        { return OP_LE; }
">="        { return OP_GE; }

{id}        { return IDENTIFIER; }
{number}    { return NUMBER; }

[-+*/=;(){},<>[\]&.:] { return yytext[0]; }

[ \t\n\r]+  { /* Ignore whitespace */ }
.           { printf("UNKNOWN TOKEN\n"); }
%%