#!/usr/bin/env bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Uso: ./compiler.sh <arquivo-fonte>"
    exit 1
fi

# Etapa 1: analisador léxico
flex -o lexer.c lexer.l
gcc -o main lexer.c

./main "$1"