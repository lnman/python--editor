%{
//read me:we are not looking for programming error.so a little generalization is used
//help:error negative range for hyphen inside [],use escape backslash
//issue:unicode is not supported yet
//help:yytext has the current value
//issue:escape has been limited by chars although it is for many uses
//issue:character limit inside a string is not enough
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
int i;

%}
comment 				[#][^\n]*
single_quoted_string	\"({graphic}|{esc_u}|[ \n'])*\"|\'({graphic}|{esc_u}|[ \n"])*\'
triple_quoted_string	\"\"\"({text_chars}|{esc_u}|[ \n'])*\"\"\"|\'\'\'({text_chars}|{esc_u}|[ \n"])*\'\'\'
string_lit				{raw_opt}?({single_quoted_string}|{triple_quoted_string})

single_quoted_byte		\"({graphic}|{esc_a}|[ \n'])*\"|\'({graphic}|{esc_a}|[ \n"])*\'
triple_quoted_byte		\"\"\"({text_chars}|{esc_u}|[ \n'])*\"\"\"|\'\'\'({text_chars}|{esc_u}|[ \n"])*\'\'\'
byte_lit				{byte_opt}{raw_opt}?({single_quoted_byte}|{triple_quoted_byte})

ws				[ \t\n]+
keyword 		"del"|"from"|"while"|"as"|"elif"|"global"|"with"|"assert"|"else"|"if"|"pass"|"yield"|"break"|"except"|"import"|"print"|"class"|"exec"|"raise"|"continue"|"finally"|"return"|"def"|"for"|"lambda"|"try"
identifier		({letter}|"_")({letter}|{digit}|"_")*
letter			[a-zA-Z]
digit			[0-9]
nonzerodigit	[1-9]
hexdigit		{digit}|[a-fA-F]
hexinteger		[0][xX]{hexdigit}+
octdigit		[0-7]
intpart			{digit}+
fraction		[.]{digit}+
exponent 		[eE][+-]{digit}+
imagnumber		({floatnumber}|{intpart})[jJ]
floatnumber		{pointfloat}|{exponentfloat}
pointfloat		{intpart}?{fraction}|{intpart}[.]
exponentfloat	({intpart}|{pointfloat}){exponent}
longinteger		{integer}[lL]
integer 		{decimalinteger}|{octinteger}|{hexinteger}
decimalinteger	{nonzerodigit}{digit}*|[0]
octinteger		[0]{octdigit}+
bool			"True"|"False"
none 			None
op				"+"|"-"|"*"|"/"|"%"|"="|"!"|"<"|">"|"and"|"is"|"in"|"not"|"or"|"&"|"|"|"~"|"^"
operator		{op}+
grouping		("("|")"|"{"|"}"|"["|"]")+
punctuation		[.,:;@]
graphic			{letter}|{digit}|{operator}|{grouping}|{punctuation}|"_"
text_chars		{graphic}|{ws}
esc_a			\\{text_chars}
esc_u			{esc_a}|\\[u]{hexdigit}{4}|\\[U]{hexdigit}{8}
raw_opt			[rR]
byte_opt		[bB]


%%
{comment}		{
					printf("{\"comment\":\"");
					for(i=0;i<strlen(yytext);i++){
						if(yytext[i]==39)printf("39_");
						else if(yytext[i]==34)printf("34_");
						else printf("%c",yytext[i]);
					}
					printf("\"},");
				}
{string_lit}	{
					printf("{\"string_lit\":\"");
					for(i=0;i<strlen(yytext);i++){
						if(yytext[i]==39)printf("39_");
						else if(yytext[i]==34)printf("34_");
						else printf("%c",yytext[i]);
					}
					printf("\"},");
				}
{byte_lit}		{
					printf("{\"byte_lit\":\"",yytext);
					for(i=0;i<strlen(yytext);i++){
						if(yytext[i]==39)printf("39_");
						else if(yytext[i]==34)printf("34_");
						else printf("%c",yytext[i]);
					}
					printf("\"},");
				}

{bool}			{printf("{\"bool\":\"%s\"},",yytext);}
{none}			{printf("{\"none\":'%s'},",yytext);}
{keyword}		{printf("{\"keyword\":\"%s\"},",yytext);}
{identifier}	{printf("{\"identifier\":\"%s\"},",yytext);}
{integer}		{printf("{\"integer\":\"%s\"},",yytext);}
{longinteger}	{printf("{\"longinteger\":\"%s\"},",yytext);}
{floatnumber}	{printf("{\"floatnumber\":\"%s\"},",yytext);}
{imagnumber}	{printf("{\"imagnumber\":\"%s\"},",yytext);}
{operator}		{printf("{\"operator\":\"%s\"},",yytext);}
{grouping}		{printf("{\"grouping\":\"%s\"},",yytext);}
{punctuation}	{printf("{\"punctuation\":\"%s\"},",yytext);}
{esc_a}			{printf("{\"esc_a\":\"%s\"},",yytext);}
{esc_u}			{printf("{\"esc_u\":\"%s\"},",yytext);}
{ws}			{
					printf("{\"ws\":\"");
					for(i=0;i<strlen(yytext);i++){
						if(yytext[i]=='\n')printf("NL ");
						if(yytext[i]==' ')printf("SP ");
						if(yytext[i]=='\t')printf("TB ");
					}
					printf("\"},");
				}
%%

int main(void)
{
   yyparse();
   return 0;
}

int yywrap(void)
{
   exit(0);
}

int yyerror(void)
{
    printf("Error\n");
    exit(1);
}