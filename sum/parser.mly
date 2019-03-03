%{
	open Ast
	let varTab = Hashtbl.create 32
	let nbVar = ref 0
%}

%token<int> INTEGER
%token<string> STRING 
%token PRINT


%token PLUS
%token MULT
%token DIV
%token SEMICOLON
%token EQ
%token<string> VAR
%token DEF
%token LPAR RPAR
%token EOL
%token SCAN

%token INF
%token SUP
%token AND
%token OR
%token NOT

%left OR EQ
%left AND INF SUP   
%left PLUS
%left MULT DIV
%left UNOT

%type <Ast.statement> statement seq main

%type <Ast.expr> expr
%type <Ast.expr> term

%type <Ast.expr> factor

%start main

%%

main : seq EOL { $1 }
;

statement :
		   | PRINT expr  { Print( $2 ) }
		   | DEF VAR EQ expr { 
		   					try 
		   						let _ = Hashtbl.find varTab $2
		   						in failwith ("Error: Variable "^ $2 ^" deja def")
		   					with  Not_found -> (Hashtbl.add varTab $2 !nbVar; nbVar := !nbVar + 1; Binding( $2, $4, !nbVar-1))
		   					}
		   | SCAN VAR { 
		   				try 
							let id = Hashtbl.find varTab $2 in Scan( id )
						with  Not_found -> ( failwith ("Error: Variable "^ $2 ^" non def") )
		   			}
;

seq : 
	| statement { $1 }
	| seq SEMICOLON EOL statement { Sequence( $1, $4) }
;

expr :  
	| expr PLUS expr { Plus($1, $3) }
	| term { $1 }
	| VAR {
		try 
			let id = Hashtbl.find varTab $1 in Var( id )
		with  Not_found -> ( failwith ("Error: Variable "^ $1 ^" non def") )
		   }
		
	| STRING { String ($1) }
;

term : 
	| term MULT term { Mult ($1, $3) }
	| term DIV term { Div ($1, $3) }
	| term INF term { Inf ($1, $3) }
	| term SUP term { Sup ($1, $3) }
	| term EQ term { Eq($1, $3) }
	| term AND term { And ($1, $3) }
	| term OR term { Or ($1, $3) }
	| NOT term %prec UNOT { Not ($2) }
	| factor  { $1 }
;

factor : INTEGER { Integer($1) }
	| LPAR expr RPAR { $2 }

;
%%