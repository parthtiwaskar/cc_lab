/*
 * EXPERIMENT 3: Count number of words starting with "A" (or "a").
 * Course Outcome: CO1
 *
 * HOW TO COMPILE AND RUN:
 *   flex exp3_words_starting_a.l
 *   gcc lex.yy.c -o exp3_words_starting_a
 *   ./exp3_words_starting_a <optional_input_file.txt>
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int words_starting_with_a = 0;
int total_words = 0;
%}

%option noyywrap

%%

[aA][a-zA-Z0-9_]* {
    words_starting_with_a++;
    total_words++;
    printf("Found word starting with 'A'/'a': %s\n", yytext);
}

[a-zA-Z0-9_]+ {
    total_words++;
}

[ \t\n]+ {
    /* Skip whitespace */
}

. {
    /* Skip punctuation and symbols */
}

%%

int main(int argc, char **argv) {
    printf("============================================================\n");
    printf("  EXPERIMENT 3: Count Words Starting with 'A' or 'a'        \n");
    printf("============================================================\n");

    if (argc > 1) {
        FILE *fp = fopen(argv[1], "r");
        if (!fp) {
            fprintf(stderr, "Error: Cannot open input file '%s'\n", argv[1]);
            return 1;
        }
        yyin = fp;
        printf("Reading from file: %s\n\n", argv[1]);
    } else {
        printf("Enter text below (Press Ctrl+D to finish):\n\n");
    }

    yylex();

    printf("\n----------------------- RESULTS ----------------------------\n");
    printf("  Words starting with 'A' / 'a' : %d\n", words_starting_with_a);
    printf("  Total words scanned           : %d\n", total_words);
    if (total_words > 0) {
        printf("  Percentage                    : %.2f%%\n", 
               ((float)words_starting_with_a / total_words) * 100.0);
    }
    printf("============================================================\n");

    return 0;
}
