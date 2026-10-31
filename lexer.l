%option noyywrap yylineno

%{ 
    /* Definições */
    #include<stdio.h>
    #include<string.h>
    #include "parser.tab.h"

    int column_number = 1;

    /* Tabela de símbolos */
    char tabela_simbolos[1000][256];
    int quantidade_simbolos = 0;

    void inserir_simbolo(char *lexema);
    void exibir_tabela_simbolos(void);

%}
    /* Definições de padrões */
digit [0-9]
letter [a-zA-Z]
int_number {digit}+
float_number {int_number}\.{digit}+
id {letter}+({letter}|{digit}|_)*
delim [ \t]
ws {delim}+
comment "//".*
multComment    "/*"([^*]|\*+[^*/])*\*+"/"
unclosedComment "/*"([^*]|\*+[^*/])*\**
other .
%%
%{
    /* Regras */
%}
    /* Números */
{int_number} { 
    fprintf(yyout,"%d(%d): %s (NUMBER)\n", yylineno,column_number,yytext); column_number+=yyleng; return NUM_INT;
}
{float_number} { 
    fprintf(yyout,"%d(%d): %s (NUMBER)\n", yylineno,column_number,yytext); column_number+=yyleng; return NUM_FLOAT;
}

    /* Ignora os comentários */
{comment} { 

}
{multComment} {
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] == '\n') {
            column_number = 1;
        } else {
            column_number++;
        }
    }
}

    /* Quebras de linha e espaços */
\n { 
    column_number = 1; 
}
{ws} {
    column_number += yyleng; 
}

    /* Palavras reservadas */
"if" { 
    fprintf(yyout,"%d(%d): %s (IF)\n", yylineno,column_number,yytext); column_number+=yyleng; return IF;
}
"else" {
    fprintf(yyout,"%d(%d): %s (ELSE)\n", yylineno,column_number,yytext); column_number+=yyleng; return ELSE;
}
"while" {
    fprintf(yyout,"%d(%d): %s (WHILE)\n", yylineno,column_number,yytext); column_number+=yyleng; return WHILE;
}
"print" {
    fprintf(yyout,"%d(%d): %s (PRINT)\n", yylineno,column_number,yytext); column_number+=yyleng; return PRINT;
}
"read" {
    fprintf(yyout,"%d(%d): %s (READ)\n", yylineno,column_number,yytext); column_number+=yyleng; return READ;
}

    /* Tipos*/
"int"|"float" {
    fprintf(yyout,"%d(%d): %s (TYPE)\n", yylineno,column_number,yytext); column_number+=yyleng; return TYPE;
}

    /* Identificadores */
{id} { 
    inserir_simbolo(yytext);
    fprintf(yyout,"%d(%d): %s (ID)\n", yylineno,column_number,yytext); column_number+=yyleng; return ID;
}

    /* Operadores relacionais */
"<="|"!="|"<"|">="|">"|"==" { 
    fprintf(yyout,"%d(%d): %s (RELOP)\n", yylineno,column_number,yytext); column_number+=yyleng; return RELOP;
}

    /* Pontuação */
";" { 
    fprintf(yyout,"%d(%d): %s (SEMICOLON)\n", yylineno,column_number,yytext); column_number+=yyleng; return SEMI;
}
"," {
    fprintf(yyout,"%d(%d): %s (COMMA)\n", yylineno,column_number,yytext); column_number+=yyleng; return COMMA;
}
"(" {
    fprintf(yyout,"%d(%d): %s (LPAREN)\n", yylineno,column_number,yytext); column_number+=yyleng; return LPAREN;
}
")" {
    fprintf(yyout,"%d(%d): %s (RPAREN)\n", yylineno,column_number,yytext); column_number+=yyleng; return RPAREN;
}
"{" {
    fprintf(yyout,"%d(%d): %s (LBRACE)\n", yylineno,column_number,yytext); column_number+=yyleng; return LBRACE;
}
"}" {
    fprintf(yyout,"%d(%d): %s (RBRACE)\n", yylineno,column_number,yytext); column_number+=yyleng; return RBRACE;
}

    /* Operadores Lógicos */
"&&" { 
    fprintf(yyout,"%d(%d): %s (AND)\n", yylineno,column_number,yytext); column_number+=yyleng; return AND;
}
"||" {
    fprintf(yyout,"%d(%d): %s (OR)\n", yylineno,column_number,yytext); column_number+=yyleng; return OR;
}
"!" {
    fprintf(yyout,"%d(%d): %s (NOT)\n", yylineno,column_number,yytext); column_number+=yyleng; return NOT;
}


    /* Operadores aritméticos */
"+" { 
    fprintf(yyout,"%d(%d): %s (PLUS)\n", yylineno,column_number,yytext); column_number+=yyleng; return PLUS;
}
"-" {
    fprintf(yyout,"%d(%d): %s (MINUS)\n", yylineno,column_number,yytext); column_number+=yyleng; return MINUS;
}
"*" {
    fprintf(yyout,"%d(%d): %s (MULT)\n", yylineno,column_number,yytext); column_number+=yyleng; return MULT;
}
"/" {
    fprintf(yyout,"%d(%d): %s (DIV)\n", yylineno,column_number,yytext); column_number+=yyleng; return DIV;
}
"%" {
    fprintf(yyout,"%d(%d): %s (MOD)\n", yylineno,column_number,yytext); column_number+=yyleng; return MOD;
}

    /* Atribuição */
"=" {
    fprintf(yyout,"%d(%d): %s (ASSIGN)\n", yylineno,column_number,yytext); column_number+=yyleng; return ASSIGN;
}

    /* Erro léxico */
{unclosedComment} {
    int linha_inicio = yylineno;
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] == '\n') linha_inicio--;
    }
    fprintf(yyout, "Lexical error on line %d and column %d. Unclosed comment\n", linha_inicio, column_number);
}

"*/" {
    fprintf(yyout, "Lexical error on line %d and column %d. Unopened comment\n", yylineno, column_number);
    column_number+=yyleng;
}
{other} { 
    fprintf(yyout, "Lexical error on line %d and column %d. Input -> \"%s\"\n", yylineno, column_number, yytext);
    column_number+=yyleng;
}


%%
/* Insere um identificador na tabela de símbolos */
void inserir_simbolo(char *lexema){
    int i;
    for(i = 0; i < quantidade_simbolos; i++){
        if(strcmp(tabela_simbolos[i], lexema) == 0){

            return;
        }
    }

    if(quantidade_simbolos == 1000 || strlen(lexema) >= 256){
        fprintf(yyout, "Symbol table limit on line %d and column %d. Input -> \"%s\"\n", yylineno, column_number, lexema);
        return;
    }
    strcpy(tabela_simbolos[quantidade_simbolos], lexema);
    quantidade_simbolos++;
}

/* Exibe a tabela de símbolos */
void exibir_tabela_simbolos(void){
    int i;
    fprintf(yyout, "\nSymbol table\n");
    fprintf(yyout, "Index | Lexeme\n");
    for(i = 0; i < quantidade_simbolos; i++){
        fprintf(yyout, "%d | %s\n", i, tabela_simbolos[i]);
    }
}
