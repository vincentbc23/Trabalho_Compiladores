%option noyywrap yylineno

%{ 
    /*−−−−−−−−−−−−−−−−−−−−−−−−−− Definitions −−−−−−−−−−−−−−−−−−−−−−−−−−*/
    #include<stdio.h>

    int column_number = 1;
%}
delim [ \t\n]
ws {delim}+
digit [0-9]
lether [a-z A-Z]
number [-]?{digit}+(\.{digit}+)?
id {lether}+({lether}|{digit})*
%%
%{
    /*−−−−−−−−−−−−−−−−−−−−−−−−−−−−− Rules −−−−−−−−−−−−−−−−−−−−−−−−−−−−−*/
%}
{number} { 
    fprintf(yyout,"%d(%d): %s (NUMBER)\n", yylineno,column_number,yytext); column_number+=yyleng; 
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
{ws} { 
    column_number += yyleng; 
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