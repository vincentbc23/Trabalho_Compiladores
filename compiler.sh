#!/usr/bin/env bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Uso: ./compiler.sh <arquivo-fonte>"
    exit 1
fi

 # Etapa 1: analisador léxico
 # flex -o lexer.c lexer.l
 #gcc -o main lexer.c

 #./main "$1"

echo "Compilando o analisador sintatico (Bison)..."
bison -d parser.y

echo "Compilando o analisador lexico (Flex)..."
flex -o lex.yy.c compiler.l

echo "Gerando o executavel..."
gcc -o main parser.tab.c lex.yy.c

echo "Executando:"
echo "----------------------------------------"
./main "$1"


