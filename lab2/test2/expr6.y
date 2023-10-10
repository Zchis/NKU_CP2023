%{
/*********************************************
YACC file
基础程序
Date: 2023/9/19
forked SherryXiye
**********************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#ifndef YYSTYPE
#define YYSTYPE char*
#endif

char idStr[50];
char numStr[50];

struct Symbol {
    char* name;
    int value;
};

struct Symbol symbolTable[100];//符号表，记录变量名和对应的值
int symbolTableSize = 0;//个数

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

%token EQUAL // 新增等号标记

// 运算符优先级
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

// 语法规则
lines   : lines stmt ';' { printf("%s\n", $2); free($2); }
        | lines ';'
        |
        ;

stmt    : ID EQUAL expr {
            int i;
            for (i = 0; i < symbolTableSize; i++) {//遍历符号表
                if (strcmp(symbolTable[i].name, $1) == 0) {//与id进行比较
                    symbolTable[i].value = $3;//找到就更新值
                    break;
                }
            }
            if (i == symbolTableSize) {//如果遍历完没找到
                symbolTable[symbolTableSize].name = strdup($1);//创建一个新的符号
                symbolTable[symbolTableSize].value = $3;
                symbolTableSize++;
            }
            $$ = (char*)malloc(50 * sizeof(char));
            strcpy($$, $1);
            strcat($$, " = ");
            char resultStr[20];
            sprintf(resultStr, "%d", $3);
            strcat($$, resultStr);//把表达式的值输出出来
        }
        ;

expr    : expr ADD expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); strcat($$, $3); strcat($$, " +"); } 
        | expr SUB expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); strcat($$, $3); strcat($$, " -"); } 
        | expr MUL expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); strcat($$, $3); strcat($$, " *"); } 
        | expr DIV expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); strcat($$, $3); strcat($$, " /"); } 
        | LEFTP expr RIGHTP    { $$ = (char*)malloc(50 * sizeof(char));  strcat($$, $2);  } 
        | '-' expr %prec UMINUS   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, "-"); strcat($$, $2); } 
        | NUMBER { $$ = strdup($1); }
        | ID {
            int i;
            for (i = 0; i < symbolTableSize; i++) {
                if (strcmp(symbolTable[i].name, $1) == 0) {
                    $$ = (char*)malloc(50 * sizeof(char));
                    sprintf($$, "%d", symbolTable[i].value);
                    break;
                }
            }
            if (i == symbolTableSize) {
                $$ = (char*)malloc(50 * sizeof(char));
                strcpy($$, "0"); // 未赋值的变量默认为0
            }
        }
        ;

%%

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


    float floatValue = 3.14159;
    char floatStr[50]; // 存储浮点数的字符串表示
    int maxLength = 50; // 字符串的最大长度

    // 使用snprintf将浮点数转换为字符串
    int length = snprintf(floatStr, maxLength, "%f", floatValue);
{ char *endptr; float myresult1 = strtof($1, endptr);float myresult2 = strtof($3, endptr);char floatStr[50];int maxLength = 50;snprintf(floatStr, maxLength, "%f", (myresult1 + myresult2));$$ = floatStr; } 

{ char *endptr; float myresult1 = strtof($2, endptr);char floatStr[50];int maxLength = 50;snprintf(floatStr, maxLength, "%f", (-myresult1));$$ = floatStr; } 