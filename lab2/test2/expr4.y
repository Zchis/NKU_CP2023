%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#ifndef YYSTYPE
#define YYSTYPE char*
#endif

char idStr[50];
char numStr[50];

// 定义符号表结构，用于存储变量和其对应的值
struct Symbol {
    char* name;
    int value;
};

// 定义符号表，用于存储变量信息
struct Symbol symbolTable[100]; // 假设最多有100个变量
int symbolTableSize = 0; // 符号表大小，记录变量个数

// 定义生成汇编代码的函数
void generateAssembly(const char* assemblyCode) {
    // 在这里你可以将生成的汇编代码写入文件或执行其他操作
    printf("Generated Assembly Code: %s\n", assemblyCode);
}

int yylex();
extern int yyparse();
FILE *yyin;

void yyerror(const char *s);
%}

%token ADD
%token SUB
%token MUL
%token DIV

%token NUMBER
%token ID

%token LEFTP
%token RIGHTP

%token EQUAL

// 定义运算符的优先级
%left ADD SUB
%left MUL DIV
%right UMINUS

%union {
    int intValue;
    char* strValue;
}

%%

// 定义语法规则
lines   : lines stmt ';' { free($2); }
        | lines ';'
        |
        ;

stmt    : expr { $$ = $1; generateAssembly($$); } // 生成汇编代码
        | ID EQUAL expr { // 处理赋值语句
            int i;
            for (i = 0; i < symbolTableSize; i++) {
                if (strcmp(symbolTable[i].name, $1) == 0) {
                    symbolTable[i].value = $3;
                    break;
                }
            }
            if (i == symbolTableSize) {
                symbolTable[symbolTableSize].name = strdup($1);
                symbolTable[symbolTableSize].value = $3;
                symbolTableSize++;
            }
            $$ = (char*)malloc(50 * sizeof(char));
            strcpy($$, $1);
            strcat($$, " = ");
            strcat($$, $3);
            generateAssembly($$); // 生成汇编代码
        }
        ;

expr    : expr ADD term { $$ = (char*)malloc(50 * sizeof(char)); sprintf($$, "ADD %s, %s", $1, $3); }
        | expr SUB term { $$ = (char*)malloc(50 * sizeof(char)); sprintf($$, "SUB %s, %s", $1, $3); }
        | term { $$ = $1; }
        ;

term    : term MUL factor { $$ = (char*)malloc(50 * sizeof(char)); sprintf($$, "MUL %s, %s", $1, $3); }
        | term DIV factor { $$ = (char*)malloc(50 * sizeof(char)); sprintf($$, "DIV %s, %s", $1, $3); }
        | factor { $$ = $1; }
        ;

factor  : NUMBER { $$ = (char*)malloc(50 * sizeof(char)); sprintf($$, "%d", $1); }
        | ID {
            int i;
            for (i = 0; i < symbolTableSize; i++) {
                if (strcmp(symbolTable[i].name, $1) == 0) {
                    $$ = strdup(symbolTable[i].name);
                    break;
                }
            }
            if (i == symbolTableSize) {
                $$ = strdup("0");
            }
        }
        | LEFTP expr RIGHTP { $$ = $2; }
        | '-' factor %prec UMINUS { $$ = (char*)malloc(50 * sizeof(char)); sprintf($$, "NEG %s", $2); }
        ;

%%

int yylex() {
    // 词法分析器代码不变
}

int main(void) {
    yyin = stdin;
    do {
        yyparse();
    } while (!feof(yyin));
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}
