%{
/*********************************************
YACC file
基础程序
Date: 2023/9/19
forked SherryXiye
**********************************************/
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#ifndef YYSTYPE
#define YYSTYPE double
#endif

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

%token LEFTP
%token RIGHTP

// 定义运算符的优先级
%left ADD SUB
%left MUL DIV
%right UMINUS//UMINUS是右结合的，优先级最高。

%%

// 定义语法规则
lines   : lines expr ';' { printf("%f\n", $2); }//打印计算表达式的结果
        | lines ';'
        |
        ;

expr    : expr ADD expr   { $$ = $1 + $3; }
        | expr SUB expr   { $$ = $1 - $3; }
        | expr MUL expr   { $$ = $1 * $3; }
        | expr DIV expr   { $$ = $1 / $3; }
        | LEFTP expr RIGHTP    { $$ = $2; }
        | '-' expr %prec UMINUS   { $$ = -$2; }
        | NUMBER { $$ = $1; }
        ;
/*
NUMBER  : ZORE     { $$ = 0.0; }
        | ONE    { $$ = 1.0; }
        | TWO     { $$ = 2.0; }
        | THREE    { $$ = 3.0; }
        | FOUR     { $$ = 4.0; }
        | FIVE     { $$ = 5.0; }
        | SIX     { $$ = 6.0; }
        | SEVEN     { $$ = 7.0; }
        | EIGHT     { $$ = 8.0; }
        | NINE     { $$ = 9.0; }
        ;
*/

%%

// 词法分析器部分


int yylex() {

    int t;
    while (1) {
        t = getchar();
        if (t == ' ' || t == '\t' || t == '\n') {
            // 忽略空白字符
        } 
        else if (isdigit(t)) {
            yylval = 0;
            while (isdigit(t)) {
                yylval = yylval * 10 + t - '0';//识别多位数字，因为是十进制，所以乘以10，直到读取的不再是数字，就返回
                t = getchar();
            }
            ungetc(t, stdin);
            return NUMBER;
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

