/*
 * EXPERIMENT 5: Conversion of lowercase to uppercase and vice versa.
 * Course Outcome: CO2
 *
 * HOW TO COMPILE AND RUN:
 *   flex exp5_case_conversion.l
 *   gcc lex.yy.c -o exp5_case_conversion
 *   ./exp5_case_conversion [input_file] [output_file]
 *
 * If no files are specified, it operates interactively via standard input/output.
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int lower_to_upper_count = 0;
int upper_to_lower_count = 0;
%}

%option noyywrap

%%

[a-z] {
    /* Convert lowercase to uppercase */
    char upper = toupper(yytext[0]);
    fputc(upper, yyout);
    lower_to_upper_count++;
}

[A-Z] {
    /* Convert uppercase to lowercase */
    char lower = tolower(yytext[0]);
    fputc(lower, yyout);
    upper_to_lower_count++;
}

\n {
    fputc('\n', yyout);
}

. {
    /* Pass through all digits, punctuation, and other characters unchanged */
    fputc(yytext[0], yyout);
}

%%

int main(int argc, char **argv) {
    printf("============================================================\n");
    printf("  EXPERIMENT 5: Case Conversion (Lower <-> Upper)           \n");
    printf("============================================================\n");

    if (argc >= 2) {
        FILE *in = fopen(argv[1], "r");
        if (!in) {
            fprintf(stderr, "Error opening input file: %s\n", argv[1]);
            return 1;
        }
        yyin = in;
        printf("Input file : %s\n", argv[1]);
    } else {
        printf("Interactive mode: Type text and press Enter (Ctrl+D to finish):\n\n");
    }

    if (argc >= 3) {
        FILE *out = fopen(argv[2], "w");
        if (!out) {
            fprintf(stderr, "Error opening output file: %s\n", argv[2]);
            return 1;
        }
        yyout = out;
        printf("Output file: %s\n", argv[2]);
    }

    /* Start scanning and transforming text */
    yylex();

    fprintf(stderr, "\n----------------------- SUMMARY ----------------------------\n");
    fprintf(stderr, "  Lowercase converted to Uppercase: %d\n", lower_to_upper_count);
    fprintf(stderr, "  Uppercase converted to Lowercase: %d\n", upper_to_lower_count);
    fprintf(stderr, "  Total characters swapped        : %d\n", lower_to_upper_count + upper_to_lower_count);
    fprintf(stderr, "============================================================\n");

    return 0;
}
