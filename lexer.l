%{
  #include <assert.h>
  #include <stdio.h>
  #include <string.h>
  #include "cgen.h"
  #include "parser.tab.h"

  int line_num = 1;
  char lbuf[500];
%}

%x comment
NON_ZERO_DIGIT  [1-9]
DIGIT           [0-9]
NUMBER          {DIGIT}{DIGIT}*
INTEGER         {NON_ZERO_DIGIT}{DIGIT}*|0
ESCAPE_CHAR     ("\\n"|"\\t"|"\\r"|"\\\\"|"\\\'"|"\\\"")
CONST_STR       [^\"'\\]

ID              [a-zA-Z][0-9a-zA-Z_]*
DECIMAL         ("."{NUMBER}+)|({INTEGER}("."{NUMBER}?)?)
REAL            {DECIMAL}([eE][+-]?{NUMBER})?
STR             ('(({ESCAPE_CHAR}*)|({CONST_STR}*))*')|(\"(({ESCAPE_CHAR}*)|({CONST_STR}*))*\")

%%

\n.*					{ ++line_num; strncpy(lbuf, yytext , sizeof(lbuf)); yyless(1) ; 
                    } /* save the new line in a buffer for better syntax error recognition*/ 

number      return KW_NUMBER; /*  KEYWORDS  */
false       return KW_FALSE;
for         return KW_FOR;
not         return KW_NOT;
boolean     return KW_BOOLEAN;
var         return KW_VAR;
while       return KW_WHILE;
and         return KW_AND;
string      return KW_STRING;
const       return KW_CONST;
function    return KW_FUNCTION;
or          return KW_OR;
void        return KW_VOID;
if          return KW_IF;
break       return KW_BREAK;
return      return KW_RETURN;
true        return KW_TRUE;
else        return KW_ELSE;
continue    return KW_CONTINUE;
null        return KW_NULL;
start       return KW_START;

{ID}        { yylval.str = strdup(yytext); 
              return RG_IDENT; }
{INTEGER}   { yylval.str = strdup(yytext); 
              return RG_INT; } 
{DECIMAL}   { yylval.str = strdup(yytext); 
              return RG_DEC; } 
{REAL}      { yylval.str = strdup(yytext); 
              return RG_REAL; } 
{STR}       { yylval.str = strdup(yytext); 
              return RG_STR; } 


"+"         return '+';
"-"         return '-';
"*"         return '*';
"/"         return '/';
"%"         return '%';
"**"        return TK_POWER;
"=="        return TK_EQ;
"!="        return TK_NEQ;
"<"         return '<';
"<="        return TK_LEQ;
";"         return ';';
"("         return '(';
")"         return ')';
","         return ',';
"["					return '[';
"]"					return ']';
"{"         return '{';
"}"         return '}';
":"         return ':';

"="         return TK_ASSGN;

[ \r\t]		/* skip whitespace */

"/*"					          BEGIN(comment); printf("%s", yytext);
<comment>[^*\n]*        printf("%s", yytext); /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   printf("%s", yytext); /* eat up '*'s not followed by ')'s */
<comment>\n             printf("%s", yytext); ++line_num;
<comment>"*"+"/"        printf("%s\n", yytext); BEGIN(INITIAL);

"//"[^\n]*				      printf("%s\n", yytext); /* eat line comments */

<<EOF>> 	return EOF;

.           { yyerror("lexical error: unrecognized literal '%s'\n", yytext);};

