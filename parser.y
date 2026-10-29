%{
/*--------------------------- Includes & Externs ---------------------------*/
#include <stdio.h>
#include <stdlib.h>

/* Variáveis externas vindas do Flex (lexer) */
extern int yylex();
extern int yylineno;
extern int column_number;
extern char* yytext;
extern FILE *yyin;
extern FILE *yyout;

/* Função de erro exigida pelo Bison */
void yyerror(const char *s);

/* Tabela de símbolos (definida no lexer) */
void exibir_tabela_simbolos(void);
%}

/*--------------------------- Declaração de Tokens ---------------------------*/
/* Palavras-chave */
%token IF ELSE WHILE PRINT READ RETURN TYPE

/* Identificadores e Literais numéricos */
%token ID NUM_INT NUM_FLOAT

/* Operadores e Pontuação */
%token RELOP
%token PLUS MINUS MULT DIV MOD ASSIGN
%token AND OR NOT
%token SEMI COMMA LPAREN RPAREN LBRACE RBRACE

/*--------------------------- Precedência e Associatividade ------------------*/
/* Resolve a ambiguidade do 'dangling else'. 
   O ELSE tem precedência maior, forçando o shift (associa ao IF mais próximo) */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

/* Precedência de operadores (da menor para a maior) */
%right ASSIGN
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left MULT DIV MOD
%right NOT UMINUS /* UMINUS é fictício, usado apenas para o menos unário */

/*--------------------------- Regras da Gramática ----------------------------*/
%%

/* Um programa é formado por declarações seguidas de comandos */
program:
    declarations statements
    ;

/* Declarações de variáveis (permite vazio) */
declarations:
    declarations declaration
    | /* vazio */
    ;

/* Exemplo: int x, y; */
declaration:
    TYPE id_list SEMI
    ;

/* Lista de identificadores separados por vírgula */
id_list:
    ID
    | id_list COMMA ID
    ;

/* Bloco de comandos (permite vazio) */
statements:
    statements statement
    | /* vazio */
    ;

/* Comandos aceitos pela linguagem */
statement:
    assign_stmt
    | if_stmt
    | while_stmt
    | block_stmt
    | print_stmt
    | read_stmt
    ;

/* Escopos aninhados delimitados por chaves */
block_stmt:
    LBRACE statements RBRACE
    ;

/* Atribuição */
assign_stmt:
    ID ASSIGN expr SEMI
    ;

/* Condicional IF/ELSE com tratamento de dangling else */
if_stmt:
    IF LPAREN expr RPAREN statement %prec LOWER_THAN_ELSE
    | IF LPAREN expr RPAREN statement ELSE statement
    ;

/* Laço de repetição */
while_stmt:
    WHILE LPAREN expr RPAREN statement
    ;

/* Chamadas de funções predefinidas de E/S */
print_stmt:
    PRINT LPAREN expr RPAREN SEMI
    ;

read_stmt:
    READ LPAREN ID RPAREN SEMI
    ;

/* Expressões aritméticas, relacionais e lógicas */
expr:
    expr PLUS expr
    | expr MINUS expr
    | expr MULT expr
    | expr DIV expr
    | expr MOD expr
    | expr RELOP expr
    | expr AND expr
    | expr OR expr
    | NOT expr
    | MINUS expr %prec UMINUS  /* Menos unário, usa a precedência alta definida acima */
    | LPAREN expr RPAREN
    | ID
    | NUM_INT
    | NUM_FLOAT
    ;

%%
/*--------------------------- Funções Auxiliares ---------------------------*/

/* Reporta erros sintáticos com linha e coluna conforme exigência do enunciado */
void yyerror(const char *s) {
    fprintf(stderr, "Erro sintatico na linha %d, coluna %d: %s (proximo a '%s')\n", 
            yylineno, column_number, s, yytext);
}

int main(int argc, char *argv[]){
    yyin = fopen(argv[1], "r");
    yyout=stdout;
    yyparse();
    exibir_tabela_simbolos();
    fclose(yyin);
    return 0;
}