/*
 * EXPERIMENT 8: Postfix Expression Evaluation.
 * Course Outcome: CO3
 *
 * DESCRIPTION:
 * Evaluates Postfix (Reverse Polish) expressions using YACC.
 * In postfix notation, the operator follows its operands.
 * Example: "5 3 + 2 *" evaluates to (5 + 3) * 2 = 16.
 *
 * HOW TO COMPILE AND RUN:
 *   bison -d exp8_postfix_eval.y
 *   gcc exp8_postfix_eval.tab.c -o exp8_postfix_eval
 *   ./exp8_postfix_eval
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUMBER

%%

input:
      /* empty */
    | input line
    ;

line:
      '\n'
    | expr '\n' {
        printf("  => Result = %d\n\n", $1);
      }
    | error '\n' {
        yyerrok;
        printf("  => Invalid postfix expression! Try again.\n\n");
      }
    ;

expr:
      NUMBER              { $$ = $1; }
    | expr expr '+'       { $$ = $1 + $2; }
    | expr expr '-'       { $$ = $1 - $2; }
    | expr expr '*'       { $$ = $1 * $2; }
    | expr expr '/'       {
        if ($2 == 0) {
            yyerror("Division by zero!");
            $$ = 0;
        } else {
            $$ = $1 / $2;
        }
      }
    ;

%%

int yylex(void) {
    int c;

    /* Skip horizontal spaces and tabs */
    while ((c = getchar()) == ' ' || c == '\t');

    if (c == EOF)
        return 0;

    if (c == '\n')
        return '\n';

    /* Parse multi-digit positive numbers */
    if (isdigit(c)) {
        ungetc(c, stdin);
        scanf("%d", &yylval);
        return NUMBER;
    }

    /* Return operator character: +, -, *, / */
    return c;
}

void yyerror(const char *s) {
    fprintf(stderr, "  [Error]: %s\n", s);
}

int main(void) {
    printf("============================================================\n");
    printf("  EXPERIMENT 8: Postfix Expression Evaluation (YACC)         \n");
    printf("============================================================\n");
    printf("Enter a Postfix expression separated by spaces.\n");
    printf("Examples:\n");
    printf("  5 3 +           (gives 8)\n");
    printf("  5 3 + 2 *       (gives 16)\n");
    printf("  10 2 8 * + 3 -  (gives 23)\n");
    printf("Enter expression (Ctrl+D to exit):\n\n");

    yyparse();

    printf("\nSession ended.\n");
    return 0;
}
