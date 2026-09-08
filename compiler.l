%option noyywrap yylineno

%{ 
    /*−−−−−−−−−−−−−−−−−−−−−−−−−− Definitions −−−−−−−−−−−−−−−−−−−−−−−−−−*/
    #include<stdio.h>
    /* @leoeliasr bibliotecas usadas só pelas funcoes da tabela */
    #include<string.h>
    #include<stdlib.h>

    int column_number = 1;

/* @leoeliasr Aqui o amarzenameto da tabela de simbolos perguntar se tem valores de limites minimo ou maximo no enunciado não fala */

    char tabela_simbolos[1000][256];
    int quantidade_simbolos = 0;

/* chamando as funçoes do flex antes das Definitions */

    void inserir_simbolo(char *lexema);
    void exibir_tabela_simbolos(void);

%}
digit [0-9]
lether [a-zA-Z]
number [-]?{digit}+(\.{digit}+)?
id {lether}+({lether}|{digit})*
delim [ \t]
ws {delim}+
comment "//".*
multComment    "/*"([^*]|\*+[^*/])*\*+"/"
other .
%%
%{
    /*−−−−−−−−−−−−−−−−−−−−−−−−−−−−− Rules −−−−−−−−−−−−−−−−−−−−−−−−−−−−−*/
%}
{number} { 
    fprintf(yyout,"%d(%d): %s (NUMBER)\n", yylineno,column_number,yytext); column_number+=yyleng; 
}
{comment} {

}
{multComment} {

}
\n { 
    column_number = 1; 
}
{ws} { 
    column_number += yyleng; 
}
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
"int" { 
    fprintf(yyout,"%d(%d): %s (TIPO)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"float" { 
    fprintf(yyout,"%d(%d): %s (TIPO)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
{id} { /*@leoeliasr: registro de identificador reconheciso na regra if*/

    inserir_simbolo(yytext);

    fprintf(yyout,"%d(%d): %s (ID)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
"<="|"<>"|"<"|">="|">"|"=" { 
    fprintf(yyout,"%d(%d): %s (RELOP)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
";"|","|"("|")"|"{"|"}" { 
    fprintf(yyout,"%d(%d): %s (PONTUACAO)\n", yylineno,column_number,yytext); column_number+=yyleng;
}
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
{other} {
    fprintf(yyout, "Lexical error on line %d and column %d. Input -> \"%s\"\n", yylineno, column_number, yytext);
    column_number+=yyleng;
}


%%
/*−−−−−−−−−−−−−−−−−−−−−−−− User subrotines −−−−−−−−−−−−−−−−−−−−−−−−*/
/* @leoeliasr: função que constroe a tabela durante a analise   */
void inserir_simbolo(char *lexema){
    int i;
    for(i = 0; i < quantidade_simbolos; i++){
        if(strcmp(tabela_simbolos[i], lexema) == 0){

            return;
        }
    }

    if(quantidade_simbolos == 1000 || strlen(lexema) >= 256){
        fprintf(yyout, "Symbol table limit on line %d and column %d. Input -> \"%s\"\n", yylineno, column_number, lexema);
    }
    strcpy(tabela_simbolos[quantidade_simbolos], lexema);
    quantidade_simbolos++;
}
void exibir_tabela_simbolos(void){
    int i;
    fprintf(yyout, "\nTabela de simbolos\n");
    fprintf(yyout, "Indice | Identificador\n");
    for(i = 0; i < quantidade_simbolos; i++){
        fprintf(yyout, "%d | %s\n", i, tabela_simbolos[i]);
    }
}

int main(int argc, char *argv[]){
    yyin = fopen(argv[1], "r");
    yyout=stdout;
    yylex();
    /* @leoeliasr */
    exibir_tabela_simbolos();
    fclose(yyin);
    return 0;
}