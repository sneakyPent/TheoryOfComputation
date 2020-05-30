%{
  #include <assert.h>
  #include <stdio.h>
  #include <string.h>

  #define KW_FALSE 260
  #define KW_FOR 261
  #define KW_NOT 262
  #define KW_BOOLEAN 263
  #define KW_VAR 264
  #define KW_WHILE 265
  #define KW_AND 266
  #define KW_STRING 267
  #define KW_CONST 268
  #define KW_function 269
  #define KW_OR 270
  #define KW_VOID 271
  #define KW_IF 272
  #define KW_BREAK 273
  #define KW_RETURN 274
  #define KW_TRUE 275
  #define KW_ELSE 276
  #define KW_CONTINUE 277
  #define KW_NULL 278

  #define TK_IDENT 300
  #define TK_DEC   301
  #define TK_REAL 302
  #define TK_STR 303

  #define TK_POWER 320
  #define TK_EQ 321
  #define TK_LEQ 322
  #define TK_NEQ 323
  #define TK_ASSGN 324


  int lineNum = 1;
%}

%x comment
NON_ZERO_DIGIT  [1-9]
DIGIT           [0-9]
NUMBER          {DIGIT}{DIGIT}*
INTEGER         {NON_ZERO_DIGIT}{DIGIT}*|0
ESCAPE_CHAR     ("\\n"|"\\t"|"\\r"|"\\\\"|"\\\'"|"\\\"")
CONST_STR       [^"'\\]

ID              [a-zA-Z][0-9a-zA-Z_]*
DECIMAL         [+|-]?("."{NUMBER}+)|[+-]?({INTEGER}("."{NUMBER}?)?)
REAL            {DECIMAL}([eE][+-]?{NUMBER})?
STR             ('(({ESCAPE_CHAR}*)|({CONST_STR}*))*')|(\"(({ESCAPE_CHAR}*)|({CONST_STR}*))*\")

%%

number /*  KEYWORDS  */
false       return KW_FALSE;
for         return KW_FOR;
not         return KW_NOT;
boolean     return KW_BOOLEAN;
var         return KW_VAR;
while       return KW_WHILE;
and         return KW_AND;
string      return KW_STRING;
const       return KW_CONST;
function    return KW_function;
or          return KW_OR;
void        return KW_VOID;
if          return KW_IF;
break       return KW_BREAK;
return      return KW_RETURN;
true        return KW_TRUE;
else        return KW_ELSE;
continue    return KW_CONTINUE;
null        return KW_NULL;


{ID}        return TK_IDENT;
{DECIMAL}   return TK_DEC;
{REAL}      return TK_REAL;
{STR}       return TK_STR;



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
\n 			++lineNum;

"/*"					          { BEGIN(comment); printf("comment started at line: %d\n", lineNum); }
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by ')'s */
<comment>\n             ++lineNum;
<comment>"*"+"/"        { BEGIN(INITIAL); printf("comment ended at line: %d\n", lineNum); }

"//"[^\n]*				printf("Line %d: line comment: %s\n", lineNum, yytext);/* eat line comments */

<<EOF>> 	return EOF;

.           { printf("Line %d: Error %s\n", lineNum, yytext); }


%%
int main() { 
  int token;
   while ( (token = yylex()) != EOF )
      printf("Line %d Token %d: %s\n", lineNum, token, yytext);
}
