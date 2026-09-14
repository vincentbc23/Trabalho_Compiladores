%option noyywrap yylineno

%{ 
    /* Definições */
    #include<stdio.h>
    #include<string.h>

    int column_number = 1;

    /* Tabela de símbolos */
    char tabela_simbolos[1000][256];
    int quantidade_simbolos = 0;

    void inserir_simbolo(char *lexema);
    void exibir_tabela_simbolos(void);

%}
    /* Definições de padrões */
digit [0-9]
lether [a-zA-Z]
number ((-[1-9])|{digit}){digit}*(\.{digit}+)?
id {lether}+({lether}|{digit}|_)*
delim [ \t]
ws {delim}+
comment "//".*
multComment    "/*"([^*]|\*+[^*/])*\*+"/"
other .
%%
%{
    /* Regras */
%}
    /* Números */
{number} { 
    fprintf(yyout,"%d(%d): %s (NUMBER)\n", yylineno,column_number,yytext); column_number+=yyleng; 
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
    fprintf(yyout,"%d(%d): %s (IF)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"else" {
    fprintf(yyout,"%d(%d): %s (ELSE)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"while" {
    fprintf(yyout,"%d(%d): %s (WHILE)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"print" {
    fprintf(yyout,"%d(%d): %s (PRINT)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"read" {
    fprintf(yyout,"%d(%d): %s (READ)\n", yylineno,column_number,yytext); column_number+=yyleng;
}

    /* Tipos*/
"int"|"float" {
    fprintf(yyout,"%d(%d): %s (TYPE)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
    /* Identificadores */
{id} { 
    inserir_simbolo(yytext);
    fprintf(yyout,"%d(%d): %s (ID)\n", yylineno,column_number,yytext); column_number+=yyleng;
}

    /* Operadores relacionais */
"<="|"!="|"<"|">="|">"|"==" { 
    fprintf(yyout,"%d(%d): %s (RELOP)\n", yylineno,column_number,yytext); column_number+=yyleng;
}

    /* Pontuação */
";" { 
    fprintf(yyout,"%d(%d): %s (SEMICOLON)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"," {
    fprintf(yyout,"%d(%d): %s (COMMA)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"(" {
    fprintf(yyout,"%d(%d): %s (LPAREN)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
")" {
    fprintf(yyout,"%d(%d): %s (RPAREN)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"{" {
    fprintf(yyout,"%d(%d): %s (LBRACE)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"}" {
    fprintf(yyout,"%d(%d): %s (RBRACE)\n", yylineno,column_number,yytext); column_number+=yyleng;
}

    /* Operadores Lógicos */
"&&" { 
    fprintf(yyout,"%d(%d): %s (AND)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"||" {
    fprintf(yyout,"%d(%d): %s (OR)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"!" {
    fprintf(yyout,"%d(%d): %s (NOT)\n", yylineno,column_number,yytext); column_number+=yyleng;
}


    /* Operadores aritméticos */
"+" { 
    fprintf(yyout,"%d(%d): %s (PLUS)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"-" {
    fprintf(yyout,"%d(%d): %s (MINUS)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"*" {
    fprintf(yyout,"%d(%d): %s (MULT)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"/" {
    fprintf(yyout,"%d(%d): %s (DIV)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"%" {
    fprintf(yyout,"%d(%d): %s (MOD)\n", yylineno,column_number,yytext); column_number+=yyleng;
}

    /* Atribuição */
"=" {
    fprintf(yyout,"%d(%d): %s (ASSIGN)\n", yylineno,column_number,yytext); column_number+=yyleng;
}

    /* Erro léxico */
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

int main(int argc, char *argv[]){
    yyin = fopen(argv[1], "r");
    yyout=stdout;
    yylex();
    exibir_tabela_simbolos();
    fclose(yyin);
    return 0;
}