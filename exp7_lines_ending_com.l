/*
 * EXPERIMENT 7: Test lines ending with "COM".
 * Course Outcome: CO3
 *
 * HOW TO COMPILE AND RUN:
 *   flex exp7_lines_ending_com.l
 *   gcc lex.yy.c -o exp7_lines_ending_com
 *   ./exp7_lines_ending_com <optional_input_file.txt>
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line_number = 0;
int matching_lines = 0;
%}

%option noyywrap

%%

.*[cC][oO][mM][ \t]*\n {
    line_number++;
    matching_lines++;
    printf("Line %3d [MATCHED]: %s", line_number, yytext);
}

.*\n {
    line_number++;
    /* Non-matching line ending with newline */
}

.*[cC][oO][mM][ \t]* {
    /* Remaining text at EOF without trailing newline */
    if (yyleng > 0) {
        line_number++;
        matching_lines++;
        printf("Line %3d [MATCHED]: %s\n", line_number, yytext);
    }
}

.+ {
    if (yyleng > 0) {
        line_number++;
    }
}

%%

int main(int argc, char **argv) {
    printf("============================================================\n");
    printf("  EXPERIMENT 7: Test Lines Ending with 'COM' / 'com'        \n");
    printf("============================================================\n");

    if (argc > 1) {
        FILE *fp = fopen(argv[1], "r");
        if (!fp) {
            fprintf(stderr, "Error opening input file: %s\n", argv[1]);
            return 1;
        }
        yyin = fp;
        printf("Reading from file: %s\n\n", argv[1]);
    } else {
        printf("Enter lines below (Press Ctrl+D to finish):\n\n");
    }

    yylex();

    printf("\n----------------------- SUMMARY ----------------------------\n");
    printf("  Total lines scanned               : %d\n", line_number);
    printf("  Lines ending with 'COM' / 'com'   : %d\n", matching_lines);
    printf("============================================================\n");

    return 0;
}
