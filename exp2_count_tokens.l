/*
 * EXPERIMENT 2: Count the number of comments, keywords, identifiers, 
 *               words, lines, and spaces from an input file.
 * Course Outcome: CO1
 *
 * HOW TO COMPILE AND RUN:
 *   flex exp2_count_tokens.l
 *   gcc lex.yy.c -o exp2_count_tokens
 *   ./exp2_count_tokens <optional_input_file.c>
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int single_comments = 0;
int multi_comments  = 0;
int keywords        = 0;
int identifiers     = 0;
int words           = 0;
int lines           = 1;
int spaces          = 0;
int total_chars     = 0;
%}

%option noyywrap

/* Regular Definitions */
KEYWORD "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"

ID      [a-zA-Z_][a-zA-Z0-9_]*
NUMBER  [0-9]+(\.[0-9]+)?

%%

"//".* {
    single_comments++;
}

"/*"([^*]|\*+[^*/])*\*+"/" {
    multi_comments++;
    /* Count lines inside multi-line comments */
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') lines++;
    }
}

{KEYWORD} {
    keywords++;
    words++;
}

{ID} {
    identifiers++;
    words++;
}

{NUMBER} {
    words++;
}

[ ] {
    spaces++;
}

\t {
    spaces += 4; /* Treat tab as 4 spaces */
}

\n {
    lines++;
}

. {
    total_chars++;
}

%%

int main(int argc, char **argv) {
    printf("============================================================\n");
    printf("  EXPERIMENT 2: Token, Comment, Line & Space Counter        \n");
    printf("============================================================\n");

    if (argc > 1) {
        FILE *fp = fopen(argv[1], "r");
        if (!fp) {
            fprintf(stderr, "Error: Cannot open input file '%s'\n", argv[1]);
            return 1;
        }
        yyin = fp;
        printf("Reading from file: %s\n", argv[1]);
    } else {
        printf("Reading from standard input (Type text and press Ctrl+D):\n");
    }

    yylex();

    printf("\n----------------------- RESULTS ----------------------------\n");
    printf("  Single-line Comments (//)   : %d\n", single_comments);
    printf("  Multi-line Comments (/* */) : %d\n", multi_comments);
    printf("  Total Comments              : %d\n", single_comments + multi_comments);
    printf("  Keywords                    : %d\n", keywords);
    printf("  Identifiers                 : %d\n", identifiers);
    printf("  Total Words                 : %d\n", words);
    printf("  Total Lines                 : %d\n", lines);
    printf("  Total Spaces & Tabs         : %d\n", spaces);
    printf("============================================================\n");

    return 0;
}
