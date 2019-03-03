#!/bin/sh

ocamllex lexer.mll;
ocamlc -c ast.ml;
ocamlc -c eval.ml;
ocamlyacc parser.mly;
ocamlc -c parser.mli;
ocamlc -c lexer.ml;
ocamlc -c parser.ml;
ocamlc -c umc.ml;
ocamlc -o umc ast.cmo eval.cmo lexer.cmo parser.cmo umc.cmo

