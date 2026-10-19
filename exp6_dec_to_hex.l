/*
 * EXPERIMENT 6: Conversion of decimal to hexadecimal number in a file.
 * Course Outcome: CO2
 *
 * HOW TO COMPILE AND RUN:
 *   flex exp6_dec_to_hex.l
 *   gcc lex.yy.c -o exp6_dec_to_hex
 *   ./exp6_dec_to_hex [input_file] [output_file]
 *
 * If no files are specified, it operates interactively via standard input/output.
 */

%{
#include <stdio.h>
#include <stdlib.h>

int converted_count = 0;
%}

%option noyywrap

%%

[0-9]+ {
    /* Match decimal integer, convert to hexadecimal */
    long dec_val = atol(yytext);
    fprintf(yyout, "0x%lX", dec_val);
    converted_count++;
}

\n {
    fputc('\n', yyout);
}

. {
    /* All other characters (letters, operators, symbols, spaces) remain unchanged */
    fputc(yytext[0], yyout);
}

%%

int main(int argc, char **argv) {
    printf("============================================================\n");
    printf("  EXPERIMENT 6: Decimal to Hexadecimal Conversion           \n");
    printf("============================================================\n");

    if (argc >= 2) {
        FILE *in = fopen(argv[1], "r");
        if (!in) {
            fprintf(stderr, "Error opening input file '%s'\n", argv[1]);
            return 1;
        }
        yyin = in;
        printf("Reading input from: %s\n", argv[1]);
    } else {
        printf("Enter text with numbers (Press Ctrl+D to finish):\n\n");
    }

    if (argc >= 3) {
        FILE *out = fopen(argv[2], "w");
        if (!out) {
            fprintf(stderr, "Error opening output file '%s'\n", argv[2]);
            return 1;
        }
        yyout = out;
        printf("Writing output to: %s\n", argv[2]);
    }

    yylex();

    fprintf(stderr, "\n----------------------- SUMMARY ----------------------------\n");
    fprintf(stderr, "  Total decimal numbers converted to Hex: %d\n", converted_count);
    fprintf(stderr, "============================================================\n");

    return 0;
}
