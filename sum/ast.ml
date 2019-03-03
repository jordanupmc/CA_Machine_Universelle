type expr = 
| Integer of int
| Plus of expr * expr
| Div of expr * expr
| Mult of expr * expr
| String of string
| Var of int
| Inf of expr * expr
| Sup of expr * expr
| Eq of expr * expr
| And of expr * expr
| Or of expr * expr
| Not of expr

type statement = 
|Print of expr
|Binding of string * expr * int 
|Sequence of statement * statement
|Scan of int 

(* 
|Nop 
*)
