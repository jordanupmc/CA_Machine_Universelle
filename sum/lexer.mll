{
  open Parser
  open String
}
  
let number =  [ '0' - '9' ]+ 
let spaces = [ ' ' '\t']

let plus = '+'
let mult = '*'
let div = '/'

let eol = '\n'

let pointV =';'

let lpar = '('
let rpar = ')'

let string = '"' [ 'A'-'Z' 'a'-'z' '0'-'9' ' ' '#' -'/']+ '"'

let print_f = "print"
let scan = "scan"

let defVar = "let"

let affect = '='
let var =  [ 'a' - 'z' 'A'-'Z' ][ 'a'-'z' 'A'-'Z' '0'-'9' '_']*


let pointV =';'

let inf = '<'
let sup = '>'
let not = "NOT"
let land = "AND"
let lor = "OR"

rule token = parse 
| spaces { token lexbuf } 
| print_f { PRINT }
| number as x { INTEGER ( int_of_string x ) }
| plus { PLUS }
| mult { MULT }
| div { DIV }
| lpar { LPAR }
| rpar { RPAR }
| string as str { STRING ( (String.sub str 1 ((String.length str) -2) ) ) }
| scan { SCAN }
| defVar { DEF }
| affect { EQ }
| inf { INF }
| sup { SUP }
| land { AND }
| lor  { OR  }
| not { NOT }
| var as str { VAR(str) }
| pointV { SEMICOLON }
| eol { EOL }
| _ {token lexbuf }
