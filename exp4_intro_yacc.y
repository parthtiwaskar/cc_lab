/*
 * EXPERIMENT 4: Introduction to YACC tool, and format to write YACC code.
 * Course Outcome: CO2
 *
 * DESCRIPTION:
 * YACC (Yet Another Compiler-Compiler) / GNU Bison is an LALR(1) parser generator.
 * It translates a Context-Free Grammar (CFG) into a syntax analyzer in C.
 *
 * STANDARD FORMAT OF A YACC FILE (.y):
 * -----------------------------------------------------------------------------
 * 1. DECLARATIONS SECTION:
 *    %{
 *       // C declarations, headers, and function prototypes
 *    %}
 *    %token TOKEN_NAME ...      // Terminal symbols from the lexer
 *    %left, %right, %nonassoc   // Operator associativity and precedence
 *    %type <type> non_terminal  // Value types of grammar symbols
 *    %start start_symbol        // Specifies the entry point of the grammar
 * -----------------------------------------------------------------------------
 * 2. RULES SECTION:
 *    %%
 *    non_terminal : rhs_1 { // semantic action 1 (using $$, $1, $2, ...) }
 *                 | rhs_2 { // semantic action 2 }
 *                 ;
 *    %%
 * -----------------------------------------------------------------------------
 * 3. SUPPORTING C ROUTINES SECTION:
 *    - int main(): Entry point that invokes yyparse()
 *    - int yylex(): Lexical scanner supplying tokens (can be built-in or from Lex)
 *    - void yyerror(const char *s): Error handler invoked upon syntax errors
 * -----------------------------------------------------------------------------
 *
 * HOW TO COMPILE AND RUN:
 *   bison -d exp4_intro_yacc.y
 *   gcc exp4_intro_yacc.tab.c -o exp4_intro_yacc
 *   ./exp4_intro_yacc
 *
 * (Note: yacc -d exp4_intro_yacc.y && gcc y.tab.c -o exp4_intro_yacc also works)
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

/* Function prototypes */
int yylex(void);
void yyerror(const char *s);

int valid_statements = 0;
%}

/* YACC Token Declarations */
%token NUMBER
%token ID
%token TYPE
%token IF ELSE WHILE

/* Operator Precedence and Associativity (lowest to highest) */
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

/* Grammar Rules */
program:
      /* empty */
    | program statement
    ;

statement:
      '\n'
    | expr '\n' {
        printf("  => Valid Arithmetic Expression! Result = %d\n\n", $1);
        valid_statements++;
      }
    | decl_stmt '\n' {
        printf("  => Valid Variable Declaration Statement!\n\n");
        valid_statements++;
      }
    ;

decl_stmt:
      TYPE id_list ';'
    ;

id_list:
      ID
    | id_list ',' ID
    ;

expr:
      NUMBER              { $$ = $1; }
    | expr '+' expr       { $$ = $1 + $3; }
    | expr '-' expr       { $$ = $1 - $3; }
    | expr '*' expr       { $$ = $1 * $3; }
    | expr '/' expr       { 
        if ($3 == 0) {
            yyerror("Division by zero error");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
      }
    | '(' expr ')'        { $$ = $2; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    ;

%%

/* Supporting C Routines */

/* Built-in Lexer for self-contained compilation */
int yylex(void) {
    int c;

    /* Skip spaces and horizontal tabs */
    while ((c = getchar()) == ' ' || c == '\t');

    if (c == EOF)
        return 0;

    /* Return newline as a token delimiter */
    if (c == '\n')
        return '\n';

    /* Parse multi-digit integer numbers */
    if (isdigit(c)) {
        ungetc(c, stdin);
        scanf("%d", &yylval);
        return NUMBER;
    }

    /* Parse identifiers and keywords */
    if (isalpha(c) || c == '_') {
        char buffer[128];
        int idx = 0;
        buffer[idx++] = c;
        while ((c = getchar()) != EOF && (isalnum(c) || c == '_')) {
            if (idx < 127) buffer[idx++] = c;
        }
        buffer[idx] = '\0';
        ungetc(c, stdin);

        /* Check for C data types */
        if (strcmp(buffer, "int") == 0 || strcmp(buffer, "float") == 0 ||
            strcmp(buffer, "char") == 0 || strcmp(buffer, "double") == 0) {
            return TYPE;
        }
        return ID;
    }

    /* Return single-character operators: +, -, *, /, (, ), ;, , */
    return c;
}

void yyerror(const char *s) {
    fprintf(stderr, "  [Syntax Error]: %s\n", s);
}

int main(void) {
    printf("============================================================\n");
    printf("  EXPERIMENT 4: Introduction to YACC Tool and Format        \n");
    printf("============================================================\n");
    printf("This parser demonstrates YACC grammar rules and C integration.\n");
    printf("Supported inputs:\n");
    printf("  1. Arithmetic expressions: e.g., (10 + 20) * 3\n");
    printf("  2. Variable declarations:  e.g., int a, b, c;\n");
    printf("Type an expression/declaration and press Enter (Ctrl+D to exit):\n\n");

    yyparse();

    printf("\n============================================================\n");
    printf("Parsing finished. Total valid statements parsed: %d\n", valid_statements);
    printf("============================================================\n");
    return 0;
}
