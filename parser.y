%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
void yyerror(const char *s);
%}

%token KEYWORD_INT KEYWORD_FLOAT KEYWORD_VOID KEYWORD_IF KEYWORD_ELSE KEYWORD_WHILE KEYWORD_FOR KEYWORD_RETURN
%token KEYWORD_STRUCT KEYWORD_SWITCH KEYWORD_CASE KEYWORD_DEFAULT KEYWORD_BREAK
%token IDENTIFIER NUMBER OP_EQ OP_LE OP_GE

%nonassoc LOWER_THAN_ELSE
%nonassoc KEYWORD_ELSE

/* Operator precedence for math and comparisons */
%left OP_EQ OP_LE OP_GE '<' '>'
%left '+' '-'
%left '*' '/'
%right '&'

%%
program:
    global_statement_list
    ;

global_statement_list:
    global_statement
    | global_statement_list global_statement
    ;

global_statement:
    function_declaration { printf("Success: Parsed Function Declaration\n"); }
    | declaration ';' { printf("Success: Parsed Global Declaration\n"); }
    | struct_definition ';' { printf("Success: Parsed Struct Definition\n"); }
    ;

function_declaration:
    type pointer IDENTIFIER '(' parameter_list ')' compound_statement
    | type pointer IDENTIFIER '(' ')' compound_statement
    ;

type:
    KEYWORD_INT | KEYWORD_FLOAT | KEYWORD_VOID | KEYWORD_STRUCT IDENTIFIER
    ;

pointer:
    /* empty */
    | '*' pointer
    ;

parameter_list:
    parameter
    | parameter_list ',' parameter
    ;

parameter:
    type pointer IDENTIFIER
    | type pointer IDENTIFIER '[' ']'
    ;

struct_definition:
    KEYWORD_STRUCT IDENTIFIER '{' struct_member_list '}'
    ;

struct_member_list:
    declaration ';'
    | struct_member_list declaration ';'
    ;

compound_statement:
    '{' statement_list '}'
    | '{' '}'
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    declaration ';' { printf("Success: Parsed Local Declaration\n"); }
    | assignment ';' { printf("Success: Parsed Assignment\n"); }
    | while_loop { printf("Success: Parsed While Loop\n"); }
    | for_loop { printf("Success: Parsed For Loop\n"); }
    | if_statement { printf("Success: Parsed If/Else Statement\n"); }
    | switch_statement { printf("Success: Parsed Switch Statement\n"); }
    | KEYWORD_RETURN expression ';' { printf("Success: Parsed Return Statement\n"); }
    | KEYWORD_BREAK ';' { printf("Success: Parsed Break Statement\n"); }
    | compound_statement
    ;

declaration:
    type pointer IDENTIFIER
    | type pointer IDENTIFIER '[' NUMBER ']'
    ;

assignment:
    IDENTIFIER '=' expression
    | IDENTIFIER '[' expression ']' '=' expression
    | IDENTIFIER '.' IDENTIFIER '=' expression
    ;

while_loop:
    KEYWORD_WHILE '(' expression ')' statement
    ;

for_loop:
    KEYWORD_FOR '(' assignment ';' expression ';' assignment ')' statement
    ;

if_statement:
    KEYWORD_IF '(' expression ')' statement %prec LOWER_THAN_ELSE
    | KEYWORD_IF '(' expression ')' statement KEYWORD_ELSE statement
    ;

switch_statement:
    KEYWORD_SWITCH '(' expression ')' '{' case_list '}'
    ;

case_list:
    case_statement
    | case_list case_statement
    ;

case_statement:
    KEYWORD_CASE NUMBER ':' statement_list
    | KEYWORD_DEFAULT ':' statement_list
    ;

expression:
    NUMBER
    | IDENTIFIER
    | IDENTIFIER '[' expression ']'
    | IDENTIFIER '.' IDENTIFIER
    | '&' IDENTIFIER
    | expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    | expression OP_EQ expression
    | expression '<' expression
    | expression '>' expression
    | expression OP_LE expression
    | expression OP_GE expression
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}

int main() {
    printf("Ready for full C code input:\n");
    yyparse();
    return 0;
}