%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"

extern int yylex(void);
extern int line_num;
%}

%union
{
	char* str;
  	int intNum;
  	double doubleNum;
}
%token <str> KW_FALSE
%token KW_FOR
%token KW_NOT
%token KW_BOOLEAN
%token KW_VAR
%token KW_WHILE
%token KW_AND
%token KW_STRING
%token KW_CONST
%token KW_FUNCTION
%token KW_OR
%token KW_VOID
%token KW_IF
%token KW_BREAK
%token KW_RETURN
%token <str> KW_TRUE
%token KW_ELSE
%token KW_CONTINUE
%token KW_NULL
%token KW_NUMBER
%token KW_START

%token <str>		RG_IDENT
%token <str>		RG_INT
%token <str>		RG_DEC
%token <str>		RG_REAL
%token <str>		RG_STR

%token TK_POWER
%token TK_EQ
%token TK_LEQ
%token TK_NEQ
%token TK_ASSGN

%start program

%type <str> body decl decl_list_item_id //decl_list 
%type <str> var_decl_list var_decl_list_item var_list_item_id
%type <str> const_decl_list const_decl_list_item 
%type <str> type_spec
%type <str> expr start_func
%type <str> init_decl init_decl_list
%type <str> const_decl vars_decl func_decl
%type <str> sec_func func_arg_list_item func_arg_list type_spec_ret

%%

program: 
init_decl_list start_func
{ 
/* We have a successful parse! 
  Check for any errors and generate output. 
*/
	if (yyerror_count == 0) {
    // include the mslib.h file
	  puts(c_prologue); 
	  printf("/* program */ \n\n");
	  printf("%s\n\n", $1);
	  printf("int main() {\n%s} \n", $2);
	}
}
|start_func
{ 
/* We have a successful parse! 
  Check for any errors and generate output. 
*/
	if (yyerror_count == 0) {
    // include the mslib.h file
	  puts(c_prologue); 
	  printf("/* program */ \n\n");
	  printf("%s\n\n", $1);
	  printf("int main() {\n%s} \n", $1);
	}
}
;

init_decl_list: 
init_decl_list init_decl { $$ = template("%s\n%s", $1, $2); }
| init_decl { $$ = $1; }
;

init_decl: 
const_decl
| vars_decl
| func_decl
| sec_func
;


decl: 
const_decl
| vars_decl
;



// ********************************const declaration********************************  

const_decl:
KW_CONST const_decl_list ':' type_spec ';' { $$ = template("const %s %s;", $4, $2); }
;

const_decl_list:
const_decl_list ',' const_decl_list_item { $$ = template("%s, %s", $1, $3); }
| const_decl_list_item { $$ = template("%s", $1); }
;

const_decl_list_item: 
decl_list_item_id TK_ASSGN expr { $$ = template("%s =%s", $1, $3);}
;

decl_list_item_id: RG_IDENT { $$ = $1; } 
| RG_IDENT '[' RG_INT ']' { $$ = template("*%s", $1); }
;


// ********************************var declaration********************************
func_arg_list:
func_arg_list ',' func_arg_list_item{ $$ = template("%s, %s", $1, $3); }
| func_arg_list_item { $$ = template("%s", $1); }
;

func_arg_list_item:
RG_IDENT ':' type_spec { $$ = template("%s %s", $3, $1); }
// | RG_IDENT '[' RG_INT ']' { $$ = template("*%s %s", $6, $1); }
;

vars_decl:
KW_VAR var_decl_list ':' type_spec ';' { $$ = template("%s %s;", $4, $2); }
;


var_decl_list: 
var_decl_list ',' var_decl_list_item { $$ = template("%s, %s", $1, $3); }
| var_decl_list_item { $$ = template("%s", $1); }
;

var_decl_list_item: 
var_list_item_id TK_ASSGN expr { $$ = template("%s = %s", $1, $3);}
|var_list_item_id { $$ = template("%s", $1); }
;

var_list_item_id: 
RG_IDENT { $$ = $1; } 
| RG_IDENT '[' RG_INT ']' { $$ = template("*%s", $1); }
;


// ********************************function declaration********************************

start_func:
KW_FUNCTION KW_START '(' ')' ':' KW_VOID '{' body '}' { $$ = template("%s", $8); }
|KW_FUNCTION KW_START '(' ')' ':' KW_VOID '{' body KW_RETURN ';''}' { $$ = template("%s\treturn;\n", $8); }
;

body:  %empty { $$="";}
| decl body {$$ = template("\t%s\n%s", $1,$2);}
;

func_decl:
KW_FUNCTION RG_IDENT '(' ')' ':' type_spec ';' { $$ = template("%s %s();", $6, $2); }
| KW_FUNCTION RG_IDENT '(' func_arg_list ')' ';' { $$ = template("void %s(%s); ", $2 , $4); }
;


// functions with body
sec_func:
KW_FUNCTION RG_IDENT '(' func_arg_list ')' ':' type_spec_ret '{' body KW_RETURN RG_IDENT ';' '}' ';' { $$ = template("%s %s(%s) {\n%s\treturn %s;\n}",$7 , $2, $4, $9, $11); }
|KW_FUNCTION RG_IDENT '(' func_arg_list ')' ':' KW_VOID '{' body '}' ';' { $$ = template("void %s(%s) {\n%s}", $2, $4, $9); }
|KW_FUNCTION RG_IDENT '(' func_arg_list ')' ':' KW_VOID '{' body KW_RETURN ';' '}' ';' { $$ = template("void %s(%s) {\n%s\treturn; \n}", $2, $4, $9); }
;




type_spec: 
KW_NUMBER { $$ = "double"; }
| KW_STRING { $$ = "char" ;}
| KW_VOID { $$ = "void"; }
| KW_BOOLEAN { $$ = "int";}
;

type_spec_ret:
KW_NUMBER { $$ = "double"; }
| KW_STRING { $$ = "char" ;}
| KW_BOOLEAN { $$ = "int";}
;

expr:   
RG_STR 		{ $$=$1; }
| RG_IDENT 	{ $$=$1; }
| RG_INT 	{ $$=$1; }
| RG_DEC 	{ $$=$1; }
| RG_REAL 	{ $$=$1; }
| KW_TRUE 	{ $$="1"; }
| KW_FALSE 	{ $$="0"; }

;


%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}