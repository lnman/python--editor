%token END

%%

end:    
        END { printf("Bye World\n"); exit(0); }
         ;