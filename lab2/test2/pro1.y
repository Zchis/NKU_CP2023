%{
/****************************************************************************
思考题1
YACC file
****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h> 
#include <string.h> 
#define MAXNUM 20 //符号表总数
struct symtab {//建立符号表
        char *name;//标识符名字
        double value;//值
}symtab[MAXNUM];

struct symtab *searchTab(char *s);// 在符号表中查找
char idStr[50];// 字符数组
int yylex();// 词法分析器函数
extern int yyparse();// 语法分析函数
FILE* yyin;// 文件指针
void yyerror(const char* s);// 错误处理函数
%}


%union {
        double  val;// 存储属性值
        struct symtab *TabP;// 存储指向符号表项的指针
}


%token ADD SUB MUL DIV //加减乘除     
%token LEFTP RIGHTP //左右括号
%token <val> NUMBER //数字对应的属性值
%token UMINUS //负号
%token equal //等号
%token <TabP> ID  //标识符对应属性值

%right equal
%left ADD SUB
%left MUL DIV
%right UMINUS
%left LEFTP RIGHTP


%type <val> expr//表达式 数值类型

//规则部分
%%
//定义输入的一行或多行表达式
lines	: lines expr ';'	{ printf("%f\n", $2); }
		| lines ';'
		|
		;

//定义表达式的各种形式
expr	: expr ADD expr { $$ = $1 + $3; }
		| expr SUB expr { $$ = $1 - $3; }
		| expr MUL expr { $$ = $1 * $3; }
		| expr DIV expr { $$ = $1 / $3; }
		| LEFTP expr RIGHTP { $$ = $2; }
		| UMINUS expr %prec UMINUS { $$ = -$2; }
		| NUMBER { $$ = $1; }
		| ID equal expr { $1->value=$3; $$=$3;}
		| ID {$$=$1->value;}  
		;


%%
int isLastCharPram=0;
int count=0;
int yylex()
{
	int t;
	count++;
	while (1)
	{
		t = getchar();
		if (t == ' ' || t == '\n' || t == '\t') { ; }
		else if (isdigit(t))
		{
			yylval.val = 0;//属性值，在此处即指对应的数值
			while (isdigit(t))
			{
				yylval.val = yylval.val * 10 + t - '0';
				t = getchar();
			}
			ungetc(t, stdin);
			isLastCharPram=0;
			return NUMBER;
		}
		else if ((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')) //字母或下划线
		{
			int ti=0;
			while ((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')||(t>='0'&&t<='9'))
			{
				idStr[ti]=t;
				t = getchar();
				ti++;
			}
			idStr[ti]='\0';

			char* temp = (char*)malloc (50*sizeof(char)); 
			strcpy(temp,idStr);
			yylval.TabP=searchTab(temp); 

			ungetc(t, stdin);
			isLastCharPram=0;
			return ID;
		}
		else if (t == '-')
		{
			if(count!=1&&isLastCharPram==0)
			{
				return SUB;
			}
			else
			{
				isLastCharPram=0;
				return UMINUS;
			}
		} 
		else if (t == '(')
		{
			isLastCharPram=1;
			return LEFTP;
		}
		else if(t == ';')
		{
			count=0;   // 每次读入一个字符串重新清0
			return t;
		}
        else if (t == '=')
		{
			isLastCharPram=0;
			return equal;
		}
		else
		{
			isLastCharPram=0;
			if (t == '+') return ADD;
			else if (t == '*') return MUL;
			else if (t == '/') return DIV;
			else if (t == ')') return RIGHTP;
			else return t;
		}
	}
}

int main()
{
	yyin = stdin;
	do {
		yyparse();
	} while (!feof(yyin));
	return 0;
}
void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
// 符号表查找程序
// 返回一个符号表的表项
struct symtab* searchTab(char *s){
    char *p;
    struct symtab *sp;
	// 遍历符号表中每一个表项
    for(sp=symtab;sp<&symtab[MAXNUM];sp++){
		// 如果找到了表中存在这一项，返回指向该表项的指针
        if(sp->name && !strcmp(sp->name,s))
            return sp;
		// 如果找不到这一项，那就新建一个表项，strdup函数用于拷贝字符串
        if(!sp->name){
            sp->name=strdup(s);
            return sp;
            }
        }
        yyerror("Wrong input");
        exit(1);
}
