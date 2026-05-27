package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS                                                                     */
/* ========================================================================= */
LineTerminator    = \r|\n|\r\n
WhiteSpace        = {LineTerminator} | [ \t\f]

Number            = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Letter            = [a-zA-Z]
Digit             = [0-9]
Identifier        = {Letter}({Letter}|{Digit}|_){0,31}
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%
/* ========================================================================= */
/* REGRAS LÉXICAS                                                             */
/* ========================================================================= */

<YYINITIAL> {

    {WhiteSpace}    { /* ignora */ }

    /* Palavras reservadas */
    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    /* Pontuação */
    "("             { return symbol(sym.LPAREN); }
    ")"             { return symbol(sym.RPAREN); }
    "{"             { return symbol(sym.LBRACE); }
    "}"             { return symbol(sym.RBRACE); }
    ";"             { return symbol(sym.SEMI); }

    /* Operadores relacionais (duplos antes dos simples!) */
    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }

    /* Atribuição (simples, depois dos relacionais) */
    "="             { return symbol(sym.ASSIGN); }

    /* Operadores aditivos */
    "+" | "-"       { return symbol(sym.ADD_OP, yytext()); }

    /* Operadores multiplicativos */
    "*" | "/" | "%" { return symbol(sym.MUL_OP, yytext()); }

    /* Identificadores e números */
    {OversizedIdentifier} { throw new RuntimeException("Erro Léxico: Identificador muito grande -> " + yytext()); }
    {Identifier}    { return symbol(sym.ID, yytext()); }
    {Number}        { return symbol(sym.NUMBER, yytext()); }

    /* Fallback */
    .               { throw new RuntimeException("Erro Léxico: Caractere ilegal -> " + yytext()); }
}

<<EOF>>             { return symbol(sym.EOF, ""); }
