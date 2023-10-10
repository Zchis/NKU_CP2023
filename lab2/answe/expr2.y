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

// 定义运算符的优先级
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

// 定义语法规则
lines   : lines expr ';' { printf("%s\n", $2); free($2); } // 释放内存
        | lines ';'
        |
        ;

        //以后缀的形式输出字符串运算式
expr    : expr ADD expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); strcat($$, $3); strcat($$, " +"); } 
        | expr SUB expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); strcat($$, $3); strcat($$, " -"); } 
        | expr MUL expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); strcat($$, $3); strcat($$, " *"); } 
        | expr DIV expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); strcat($$, $3); strcat($$, " /"); } 
        | LEFTP expr RIGHTP    { $$ = (char*)malloc(50 * sizeof(char));  strcat($$, $2);  } 
        | '-' expr %prec UMINUS   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, "-"); strcat($$, $2); } 
        | NUMBER { $$ = strdup($1); } // 使用strdup复制字符串
        | ID { $$ = strdup($1); } 
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
