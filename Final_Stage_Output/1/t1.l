%{
#include "y.tab.h"
#include <stdio.h> 
#include <strings.h>

int line_no=1;
int token_count = 0;

typedef struct {
    int lineno;
    char lexeme[100];
    char token_type[100];
} token_info;

token_info tokens[100];

%}

DIGIT [0-9]
LETTER [a-zA-Z]
UNDERSCORE "_"
WHITESPACE [ \t\r]+
TEXT ([0-9A-Za-z]|[ \t\r])*

%%


"//".*      { /* ignore single-line comments */ }    
[\t\f] {}
[\n]      {}           
" " {}

[pP][rR][oO][gG][rR][aA][mM]   {return PROGRAM ;}
[iI][nN][tT][eE][gG][eE][rR]       {yylval.t.type = strdup("integer");return INT;}
[rR][eE][aA][lL]      {yylval.t.type = strdup("real");return REAL;}
[bB][oO][oO][lL][eE][aA][nN]   {yylval.t.type = strdup("boolean");return BOOLEAN;}
[cC][hH][aA][rR]     {yylval.t.type = strdup("char");return CHAR;}
[vV][aA][rR]       {return VAR ;}
[fF][oO][rR]    { return FOR;}
[dD][oO]        { return DO;}
[wW][hH][iI][lL][eE]     { return WHILE;}
[aA][rR][rR][aA][yY]     { return ARRAY;}
[aA][nN][dD]       { return AND;}
[oO][rR]        { return OR;}
[nN][oO][tT]       { return NOT;}
[bB][eE][gG][iI][nN]     { return PROG_BEGIN ;}
[eE][nN][dD]       { return END;}
[rR][eE][aA][dD]      { return READ;}
[wW][rR][iI][tT][eE]     { return WRITE;}
[iI][fF]        { return IF;}
[eE][lL][sS][eE]      { return ELSE;}
[tT][oO]        { return TO;}
[dD][oO][wW][nN][tT][oO]    { return DOWNTO;}
[eE][lL][sS][eE][ ][iI][fF]   { return ELSEIF;}  
[tT][hH][eE][nN]      { return THEN;} 
[oO][fF]        {return OF;}
\"([^\\"]*)\" { yylval.t.v.sval = strdup(yytext);return TXT;}

[tT][rR][uU][eE]  {yylval.t.type = strdup("boolean");yylval.t.v.sval = strdup("true"); return BOOLVAL;}
[fF][aA][lL][sS][eE] {yylval.t.type = strdup("boolean");yylval.t.v.sval = strdup("false");return BOOLVAL;}

[a-zA-Z][_a-zA-Z0-9]* {yylval.t.type = strdup(yytext);return IDENTIFIER;}


[-]?{DIGIT}+([eE][+-]?{DIGIT}+)?  {yylval.t.type = strdup("integer");yylval.t.v.ival = atoi(yytext); return INTVAL;}
[-]?({DIGIT}+(\.{DIGIT}+))([eE][+-]?{DIGIT}+)?   {yylval.t.type = strdup("real");yylval.t.v.fval = atof(yytext); return REALVAL;}

\'{LETTER}\'  {yylval.t.type = strdup("char");yylval.t.v.cval = yytext[1]; return CHARVAL;} 

"="        { return EQ;}
"<>"        { return NEQ;}
"<"         { return LT;}
">"         { return GT;}
"<="        { return LTE;}
">="        { return GTE;}

"+"         { return PLUS;}
"-"         { return MINUS;}
"*"         { return MULT;}
"/"         { return DIV;}
"%"         { return MOD;}

":="        { return ASSIGN;}
","         { return COMMA;}
":"         { return COLON;}
";"         { return SEMICOLON;}
"("         { return LPAREN;}
")"         { return RPAREN;}
"["         { return LSPAREN;}
"]"         { return RSPAREN;}
"_"         { return UNDERSCORE;}

[\']        { return SQUOTE;}
"{"         { return LCPAREN;}
"}"         { return RCPAREN;}
\.	    { return PERIOD;}
.           { return -1;}


%%

int yywrap() {
    return 1;
}

/*
int main(int argc, char *argv[]) {
    
    FILE *input_file = fopen("ip.txt", "r");
    if (input_file == NULL) {
        fprintf(stderr, "Error: Unable to open file %s\n", argv[1]);
        return 1;
    }

    yyin = input_file;
    yylex();

    printf("Line number Lexeme Token type\n");
    for (int i = 0; i < token_count; i++) {
        printf("%d %s %s\n", tokens[i].lineno , tokens[i].lexeme, tokens[i].token_type);
    }

    fclose(input_file);
    return 0;
}*/
