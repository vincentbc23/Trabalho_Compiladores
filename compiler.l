%option noyywrap yylineno

%{ 
    /*−−−−−−−−−−−−−−−−−−−−−−−−−− Definitions −−−−−−−−−−−−−−−−−−−−−−−−−−*/
    #include<stdio.h>

    int column_number = 1;
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
{id} { 
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
int main(int argc, char *argv[]){
    yyin = fopen(argv[1], "r");
    yyout=stdout;
    yylex();
    fclose(yyin);
    return 0;
}