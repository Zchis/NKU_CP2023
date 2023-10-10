%{
/*********************************************
YACC file
基础程序
Date: 2023/9/19
forked SherryXiye
**********************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h> // 添加字符串处理的头文件
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

%%

// 定义语法规则
lines   : lines stmt ';' { printf("%s\n", $2); free($2); } // 释放内存
        | lines ';'
        |
        ;

stmt    : expr { $$ = $1; }
        | ID EQUAL expr { // 处理赋值语句
            // 遍历符号表查找变量
            int i;
            for (i = 0; i < symbolTableSize; i++) {
                if (strcmp(symbolTable[i].name, $1) == 0) {
                    // 找到变量，更新其值
                    symbolTable[i].value = atoi($3); // 将字符串转换为整数
                    break;
                }
            }
            if (i == symbolTableSize) {
                // 变量不存在，添加到符号表中
                symbolTable[symbolTableSize].name = strdup($1);
                symbolTable[symbolTableSize].value = atoi($3); // 将字符串转换为整数
                symbolTableSize++;
            }
            $$ = (char*)malloc(50 * sizeof(char));
            strcpy($$, $1);
            strcat($$, " = ");
            strcat($$, $3);
        }
        ;

expr    : expr ADD term   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " + "); strcat($$, $3); } 
        | expr SUB term   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " - "); strcat($$, $3); } 
        | term { $$ = $1; } 
        ;

term    : term MUL factor { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " * "); strcat($$, $3); } 
        | term DIV factor { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " / "); strcat($$, $3); } 
        | factor { $$ = $1; } 
        ;

factor  : NUMBER { $$ = (char*)malloc(50 * sizeof(char)); sprintf($$, "%d", atoi($1)); } // 将字符串转换为整数
        | ID { // 处理变量
            // 遍历符号表查找变量的值
            int i;
            for (i = 0; i < symbolTableSize; i++) {
                if (strcmp(symbolTable[i].name, $1) == 0) {
                    // 找到变量，使用其值
                    $$ = (char*)malloc(50 * sizeof(char));
                    sprintf($$, "%d", symbolTable[i].value);
                    break;
                }
            }
            if (i == symbolTableSize) {
                // 变量未赋值，默认为0
                $$ = strdup("0");
            }
        }
        | LEFTP expr RIGHTP { $$ = $2; } 
        | '-' factor %prec UMINUS { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, "-"); strcat($$, $2); } 
        ;

%%

// 词法分析器部分

int yylex() {

    int t;
    while (1) {
        t = getchar();
        if (t == ' ' || t == '\t' || t == '\n') {
            // 忽略空白字符
        } 
        else if (( t >= '0' && t <= '9' )) {
            int ti=0;
            while (( t >= '0' && t <= '9' )) {
                numStr[ti]=t ;
                t = getchar();
                ti++;
            }
            numStr[ti]='\0';
            yylval=numStr;
            ungetc(t , stdin );
            return NUMBER;
        } 
        else if ((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || (t == '_')) {
            int ti = 0;
            while ((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || (t == '_') || (t >= '0' && t <= '9')) {
                idStr[ti] = t;
                ti++;
                t = getchar();
            }
            idStr[ti] = '\0';
            yylval = strdup(idStr);
            ungetc(t, stdin);
            return ID;
        }       
        else if (t == '+') {
            return ADD;
        } 
        else if (t == '-') {
            return SUB;
        } 
        else if (t == '*') {
            return MUL;
        } 
        else if (t == '/') {
            return DIV;
        } 
        else if (t == '(') {
            return LEFTP;
        } 
        else if (t == ')') {
            return RIGHTP;
        } 
        else if (t == '=') { // 新增处理等号的情况
            return EQUAL;
        } 
        else {
            return t;
        }
    }
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
