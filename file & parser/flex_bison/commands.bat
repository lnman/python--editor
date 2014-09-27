flex python_flex.l
bison -dy *.y
gcc lex.yy.c y.tab.c -o parser.exe
parser.exe