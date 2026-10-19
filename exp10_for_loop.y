/*
 * EXPERIMENT 10: Parser for "FOR" Loop Statements.
 * Course Outcome: CO4
 *
 * DESCRIPTION:
 * A YACC parser that verifies whether a given C-style "for" loop statement
 * is syntactically valid according to context-free grammar specifications.
 *
 * Grammar supports:
 *   - Standard for loop header: for (init; condition; update)
 *   - Optional expressions: for (; ;) ;
 *   - Single statements and compound blocks: { ... }
 *   - Pre/post increment/decrement: i++, ++i, i--, --i
 *   - Relational operators: <, >, <=, >=, ==, !=
 *   - Nested for loops
 *
 * HOW TO COMPILE AND RUN:
 *   bison -d exp10_for_loop.y
 *   gcc exp10_for_loop.tab.c -o exp10_for_loop
 *   ./exp10_for_loop
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int yylex(void);
void yyerror(const char *s);
int has_error = 0;
%}

%token FOR TYPE ID NUM
%token LE GE EQ NE INC DEC ADD_ASSIGN SUB_ASSIGN

%%

start:
      for_statement {
          if (!has_error) {
              printf("\n============================================================\n");
              printf("  RESULT: VALID 'for' loop syntax!\n");
              printf("============================================================\n\n");
          }
      }
    ;

for_statement:
      FOR '(' init ';' cond ';' update ')' body
    ;

init:
      /* empty */
    | TYPE id_init_list
    | expr_list
    ;

id_init_list:
      id_init
    | id_init_list ',' id_init
    ;

id_init:
      ID
    | ID '=' expr
    ;

cond:
      /* empty */
    | expr
    ;

update:
      /* empty */
    | expr_list
    ;

expr_list:
      assign_or_expr
    | expr_list ',' assign_or_expr
    ;

assign_or_expr:
      ID '=' expr
    | ID ADD_ASSIGN expr
    | ID SUB_ASSIGN expr
    | ID INC
    | INC ID
    | ID DEC
    | DEC ID
    | expr
    ;

body:
      statement
    | '{' statement_list '}'
    | '{' '}'
    ;

statement_list:
      statement
    | statement_list statement
    ;

statement:
      ';'
    | assign_or_expr ';'
    | for_statement
    ;

expr:
      rel_expr
    ;

rel_expr:
      arith_expr
    | arith_expr '<' arith_expr
    | arith_expr '>' arith_expr
    | arith_expr LE arith_expr
    | arith_expr GE arith_expr
    | arith_expr EQ arith_expr
    | arith_expr NE arith_expr
    ;

arith_expr:
      term
    | arith_expr '+' term
    | arith_expr '-' term
    ;

term:
      factor
    | term '*' factor
    | term '/' factor
    ;

factor:
      ID
    | NUM
    | '(' expr ')'
    ;

%%

/* Built-in Lexer for self-contained compilation */
int yylex(void) {
    int c;

    /* Skip all whitespace */
    while ((c = getchar()) != EOF && isspace(c));

    if (c == EOF)
        return 0;

    /* Multi-character operators and symbols */
    if (c == '<') {
        int next = getchar();
        if (next == '=') return LE;
        ungetc(next, stdin);
        return '<';
    }
    if (c == '>') {
        int next = getchar();
        if (next == '=') return GE;
        ungetc(next, stdin);
        return '>';
    }
    if (c == '=') {
        int next = getchar();
        if (next == '=') return EQ;
        ungetc(next, stdin);
        return '=';
    }
    if (c == '!') {
        int next = getchar();
        if (next == '=') return NE;
        ungetc(next, stdin);
        return '!';
    }
    if (c == '+') {
        int next = getchar();
        if (next == '+') return INC;
        if (next == '=') return ADD_ASSIGN;
        ungetc(next, stdin);
        return '+';
    }
    if (c == '-') {
        int next = getchar();
        if (next == '-') return DEC;
        if (next == '=') return SUB_ASSIGN;
        ungetc(next, stdin);
        return '-';
    }

    /* Numbers */
    if (isdigit(c)) {
        while ((c = getchar()) != EOF && isdigit(c));
        ungetc(c, stdin);
        return NUM;
    }

    /* Identifiers and Keywords */
    if (isalpha(c) || c == '_') {
        char buf[64];
        int i = 0;
        buf[i++] = c;
        while ((c = getchar()) != EOF && (isalnum(c) || c == '_')) {
            if (i < 63) buf[i++] = c;
        }
        buf[i] = '\0';
        ungetc(c, stdin);

        if (strcmp(buf, "for") == 0) return FOR;
        if (strcmp(buf, "int") == 0 || strcmp(buf, "float") == 0 || 
            strcmp(buf, "char") == 0 || strcmp(buf, "double") == 0) return TYPE;

        return ID;
    }

    /* Delimiters and single characters: (, ), ;, {, }, ,, *, / */
    return c;
}

void yyerror(const char *s) {
    has_error = 1;
    printf("\n============================================================\n");
    printf("  RESULT: INVALID 'for' loop syntax!\n");
    printf("  Details: %s\n", s);
    printf("============================================================\n\n");
}

int main(void) {
    printf("============================================================\n");
    printf("  EXPERIMENT 10: Parser for 'FOR' Loop Statements           \n");
    printf("============================================================\n");
    printf("Enter a C-style 'for' loop statement:\n");
    printf("Examples:\n");
    printf("  1. for (i = 0; i < 10; i++) a = a + 1;\n");
    printf("  2. for (int i = 0; i <= n; i++) { sum = sum + i; count++; }\n");
    printf("  3. for (; ;) ;\n");
    printf("Type statement and press Enter (Ctrl+D to finish):\n\n");

    yyparse();

    return 0;
}
