/*
 * EXPERIMENT 9: Desk Calculator with Error Recovery.
 * Course Outcome: CO4
 *
 * DESCRIPTION:
 * An interactive desktop calculator implementing syntax and semantic error recovery.
 * Uses YACC's special 'error' pseudo-token and recovery macros:
 *   - yyerrok   : Resets error status so future errors will be reported.
 *   - yyclearin : Discards the lookahead token that caused the parse failure.
 *
 * Supported features:
 *   - Floating-point & integer arithmetic (+, -, *, /, parentheses)
 *   - Unary minus (-5 * 2)
 *   - Division by zero detection and graceful handling
 *   - Recovery from malformed expressions without crashing
 *
 * HOW TO COMPILE AND RUN:
 *   bison -d exp9_desk_calculator.y
 *   gcc exp9_desk_calculator.tab.c -o exp9_desk_calculator -lm
 *   ./exp9_desk_calculator
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>

int yylex(void);
void yyerror(const char *s);
%}

/* Define the value type for tokens and expressions */
%union {
    double val;
}

%token <val> NUMBER
%type  <val> expr

/* Precedence and associativity declarations (lowest to highest) */
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

input:
      /* empty */
    | input line
    ;

line:
      '\n'
    | expr '\n' {
        printf("  => Result = %g\n\n", $1);
      }
    | error '\n' {
        /* Error Recovery Action:
         * 1. yyerrok informs the parser that error recovery is complete.
         * 2. yyclearin flushes the invalid lookahead token.
         */
        yyerrok;
        yyclearin;
        printf("  [RECOVERY]: Syntax error handled successfully. Ready for next input.\n\n");
      }
    ;

expr:
      NUMBER              { $$ = $1; }
    | expr '+' expr       { $$ = $1 + $3; }
    | expr '-' expr       { $$ = $1 - $3; }
    | expr '*' expr       { $$ = $1 * $3; }
    | expr '/' expr       {
        if ($3 == 0.0) {
            yyerror("Division by zero error");
            $$ = 0.0;
        } else {
            $$ = $1 / $3;
        }
      }
    | '(' expr ')'        { $$ = $2; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    ;

%%

/* Supporting Lexer */
int yylex(void) {
    int c;

    /* Skip whitespace except newline */
    while ((c = getchar()) == ' ' || c == '\t');

    if (c == EOF)
        return 0;

    if (c == '\n')
        return '\n';

    /* Parse floating-point and integer numbers */
    if (isdigit(c) || c == '.') {
        ungetc(c, stdin);
        scanf("%lf", &yylval.val);
        return NUMBER;
    }

    /* Return character tokens: +, -, *, /, (, ) */
    return c;
}

void yyerror(const char *s) {
    fprintf(stderr, "  [Syntax Error]: %s\n", s);
}

int main(void) {
    printf("============================================================\n");
    printf("  EXPERIMENT 9: Desk Calculator with Error Recovery         \n");
    printf("============================================================\n");
    printf("Enter arithmetic expressions to calculate.\n");
    printf("Supports: +, -, *, /, unary -, parentheses, floating numbers.\n");
    printf("Demonstrates error recovery (e.g. try typing: 4 +* 2 or 10 / 0).\n");
    printf("Press Ctrl+D to exit.\n\n");

    yyparse();

    printf("\nCalculator session terminated.\n");
    return 0;
}
