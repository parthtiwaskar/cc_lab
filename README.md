# Compiler Construction Lab (LEX & YACC)

This repository contains implementations for 10 experiments in Compiler Construction using **LEX / Flex** (Lexical Analyzer) and **YACC / Bison** (Parser Generator).

---

## Index of Experiments

| Exp # | Outcome | File | Description |
|:---:|:---:|:---|:---|
| **1** | **CO1** | [`exp1_intro_lex.l`](exp1_intro_lex.l) | Introduction to LEX tool, metadata (`yytext`, `yyleng`, `yylineno`, `yyin`, `yyout`), and regular expression patterns |
| **2** | **CO1** | [`exp2_count_tokens.l`](exp2_count_tokens.l) | Count single/multi-line comments, keywords, identifiers, words, lines, and spaces from an input file |
| **3** | **CO1** | [`exp3_words_starting_a.l`](exp3_words_starting_a.l) | Count the number of words starting with "A" or "a" |
| **4** | **CO2** | [`exp4_intro_yacc.y`](exp4_intro_yacc.y) | Introduction to YACC tool format (declarations, CFG rules, actions, C code) |
| **5** | **CO2** | [`exp5_case_conversion.l`](exp5_case_conversion.l) | Conversion of lowercase to uppercase and vice versa |
| **6** | **CO2** | [`exp6_dec_to_hex.l`](exp6_dec_to_hex.l) | Conversion of decimal numbers to hexadecimal in a file |
| **7** | **CO3** | [`exp7_lines_ending_com.l`](exp7_lines_ending_com.l) | Test and filter lines ending with "COM" / "com" |
| **8** | **CO3** | [`exp8_postfix_eval.y`](exp8_postfix_eval.y) | Postfix (Reverse Polish Notation) expression evaluation |
| **9** | **CO4** | [`exp9_desk_calculator.y`](exp9_desk_calculator.y) | Interactive desk calculator with syntax error recovery (`yyerrok`, `yyclearin`) |
| **10** | **CO4** | [`exp10_for_loop.y`](exp10_for_loop.y) | Syntax analyzer and parser for C-style `for` loop statements |

---

## Compilation & Execution Guide

### Prerequisites
- GCC / Clang
- Flex (`flex`)
- Bison / Yacc (`bison` or `yacc`)

### Running Lex Experiments (1, 2, 3, 5, 6, 7)
```bash
flex <filename.l>
gcc lex.yy.c -o <output_name>
./<output_name>
```

### Running YACC Experiments (4, 8, 9, 10)
```bash
bison -d <filename.y>
gcc <filename.tab.c> -o <output_name> -lm
./<output_name>
```
*(All YACC programs are self-contained with built-in tokenizers).*
