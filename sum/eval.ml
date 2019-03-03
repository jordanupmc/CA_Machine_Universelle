open Ast

(*Le nom du fichier out *)
let file = Sys.argv.(2)

(*indice du tableau representant le Heap.  *)
let regIndHeap = 1

(*indice du tableau representant l'ALU. *)
let regIndALU = 2

(*numero du registre ou mettre l'expression a print*)
let regPrint = 6

(*numero du registre ou mettre l'operand1 *)
let regOperand1 = regPrint
let regOperand2 = 3

(*HEAP INIT*)
let heap_size = 32

(*ALU INIT*)
let aluSize = 64
let aluInd = ref 0
(*TODO*)
let regIndCptALU = 4

(*On ecrase si le fichier d'output existait deja*)
let _ = if Sys.file_exists file then Sys.remove file

(*FALSE =0 *)
let _FALSE = 0
(*TRUE >= 1 *)
let _TRUE = 1

(* INVARIANTS 
 reg[0]			 = 0
 reg[regIndHeap] = 1
 reg[regIndALU]  = 2
*)

(*
Ecrit dans le file une instruction
comme les entiers sont sur 31 bit obligé d'ecrire octet par octet
*)
let writeToFile code ra rb rc file =
	let chan = open_out_gen [Open_binary; Open_wronly;	Open_append; Open_creat] 0o666 file in 
	output_byte chan (code*16);
	output_byte chan 0;
	if ra > 3 then output_byte chan 1
	else output_byte chan 0;

	output_byte chan ((( rb lsl 3) lor ((ra lsl 6) lor rc)) land 511);
	
	close_out chan

(*Ecrit dans le file une instruction special*)
let writeToFileSpecial code ra valeur file =
	let chan = open_out_gen [Open_binary; Open_wronly;	Open_append; Open_creat] 0o666 file in 
	let value = ref 0 in
	value := ( 0 lor (  code lsl 28 ) );
	value := ( !value  lor ( valeur land 33554431) );
	value := ( !value lor ( ra lsl 25));
	output_binary_int chan !value;
	close_out chan

(*return la liste de char d'un String*)
let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []


let push = (fun () -> aluInd:= !aluInd +1;Printf.printf "PUSH ALU ind = %d\n" !aluInd;())
let pop = (fun () -> aluInd:= !aluInd - 1;Printf.printf "POP ALU ind = %d\n" !aluInd;())

(*On cree un tableau de taille HEAP_SIZE l'indice est dans reg[1] mais comme c'est le 1er tableau*)

let _ = writeToFileSpecial  13 regIndHeap heap_size file;
		 writeToFile 8 0 regIndHeap regIndHeap file;
		 writeToFileSpecial 13 regIndALU aluSize file;
		 writeToFile 8 0 regIndALU regIndALU file

let getOperands e x y=
	e x regOperand1;
	e y regOperand2;

	writeToFileSpecial  13 regIndCptALU (!aluInd-2) file;
	writeToFile 1 regOperand1 regIndALU regIndCptALU file;

	writeToFileSpecial  13 regIndCptALU (!aluInd-1) file;
	writeToFile 1 regOperand2 regIndALU regIndCptALU file

let setResult arity =
	writeToFileSpecial  13 regIndCptALU (!aluInd-arity) file;
	writeToFile 2 regIndALU regIndCptALU regPrint file

let rec eval e reg =
		match e with
		| Integer x -> (
						writeToFileSpecial  13 reg x file;
						writeToFileSpecial  13 regIndCptALU !aluInd file;
						writeToFile 2 regIndALU regIndCptALU reg file;
					(*	Printf.printf "INT %d x=%d\n" (!aluInd) x;
					*)	push() 
						)

		| Plus (x , y) -> (
							getOperands eval x y;

							writeToFile 3 regPrint regOperand1 regOperand2 file;

							(*Printf.printf "Plus %d\n" (!aluInd-2);
							*)
							setResult 2;
							pop()
						)
		| Mult (x , y) -> (
							getOperands eval x y;
							
							
							writeToFile 4 regPrint regOperand1 regOperand2 file;
							
							setResult 2;	
							(*Printf.printf "Mult %d\n" (!aluInd-2);
							*)pop()

							)
		| Div (x , y) -> (
							getOperands eval x y;

							writeToFile 5 regPrint regOperand1 regOperand2 file;
							
							setResult 2;
							pop()
							)
		| String x -> ( failwith ("Error: les String sont uniquement affichable") )

		| Var id -> (writeToFile 1 reg regIndHeap id file )
		| And (x,y) ->(		
							getOperands eval x y;
							(*Pour normaliser tout ce qui est !=0 est TRUE*)
							writeToFile 0 regOperand2 regIndHeap regOperand2 file;
							writeToFile 0 regOperand1 regIndHeap regOperand1 file;

							writeToFile 6 regOperand1 regOperand1 regOperand2 file;						
							writeToFile 6 regPrint regOperand1 regOperand1 file;						
							(*Printf.printf "AND %d\n" (!aluInd-2);
							*)
							writeToFile 0 regPrint regIndHeap regPrint file;
							setResult 2;
							pop()
						)
		| Or (x, y) -> (
							getOperands eval x y;
							(*Pour normaliser tout ce qui est !=0 est TRUE*)
							writeToFile 0 regOperand2 regIndHeap regOperand2 file;
							writeToFile 0 regOperand1 regIndHeap regOperand1 file;

							(*NOT x*)
							writeToFile 6 regOperand1 regOperand1 regOperand1 file;
							(*NOT y*)
							writeToFile 6 regOperand2 regOperand2 regOperand2 file;

							(* (NOT x) NAND (NOT y) = x OR y*)
							writeToFile 6 regPrint regOperand1 regOperand2 file;

							writeToFile 0 regPrint regIndHeap regPrint file;
							setResult 2;

							pop()	
						)
		| Not x -> (
							eval x regOperand1;

							writeToFileSpecial  13 regIndCptALU (!aluInd-1 ) file;
							writeToFile 1 regOperand1 regIndALU regIndCptALU file;

							(*
							writeToFile 6 regOperand1 regOperand1 regOperand1 file;
							
							writeToFile 0 regOperand1 regIndHeap regOperand1 file;	
							*)
							(*
							DEBUG
							writeToFileSpecial 13 regOperand2 80 file;
							writeToFile 3 regOperand2 regOperand1 regOperand2 file;
							writeToFile 10 0 0 regOperand2 file ;
							*)
							writeToFileSpecial 13 regPrint _TRUE file;
							
							writeToFile 0 regPrint 0 regOperand1 file;
							
							writeToFileSpecial  13 regIndCptALU (!aluInd-1 ) file;
							writeToFile 2 regIndALU regIndCptALU regPrint file;
							
							(*setResult 1
							*)
							(*Pas besoin de pop*)
						)
		| Eq (x, y) -> (
							(*eval x regOperand1;
							eval y regOperand2;

							writeToFileSpecial  13 regIndCptALU (!aluInd-2) file;
							writeToFile 1 regOperand1 regIndALU regIndCptALU file;

							writeToFileSpecial  13 regIndCptALU (!aluInd-1) file;
							writeToFile 1 regOperand2 regIndALU regIndCptALU file;
*)
							getOperands eval x y;							
							(*Pour normaliser tout ce qui est !=0 est TRUE*)
							(*writeToFile 0 regOperand2 regIndHeap regOperand2 file;
							writeToFile 0 regOperand1 regIndHeap regOperand1 file;
							*)
							(*Load -x dans regOperand1 *)
							(* x NAND x = NOT x *)
							writeToFile 6 regOperand1 regOperand1 regOperand1 file;
							(* (NOT x) + 1 = -x *)
							writeToFile 3 regOperand1 regOperand1 regIndHeap file;
							(*-x + y *)
							writeToFile 3 regOperand1 regOperand1 regOperand2 file;
							(* on met 1 dans reg *)
							writeToFileSpecial 13 reg _TRUE file; 
							(*si -x + y != 0 on met 0(FALSE) dans reg 
							  sinon reg reste a 1(TRUE)
							*)
							writeToFile 0 reg 0 regOperand1 file; 
							(*Printf.printf "Eq %d\n" (!aluInd-2);*)
							writeToFile 0 reg regIndHeap reg file;
							writeToFileSpecial  13 regIndCptALU (!aluInd-2) file;
							writeToFile 2 regIndALU regIndCptALU reg file;
							pop()
						)
		| Inf (x, y) -> (						
								(* x<y <==> x-y<0 *)
							getOperands eval x y;
							(*Load -y dans regOperand2 *)
							(* y NAND y = NOT y *)
							writeToFile 6 regOperand2 regOperand2 regOperand2 file;
							(* (NOT y) + 1 = -y *)
							writeToFile 3 regOperand2 regOperand2 regIndHeap file;
							(*x - y *)
							writeToFile 3 regOperand1 regOperand1 regOperand2 file;
							(*capture*)
							writeToFile 3 regOperand2 regOperand1 0 file;

							(*2^15*)
							writeToFileSpecial 13 reg 32768 file;
							
							(*on decale de 15*)
							writeToFile 5 regOperand1 regOperand1 reg file;
							(*on decale de 15 -> 30*)		
							writeToFile 5 regOperand1 regOperand1 reg file;
							(*On decale de 1 -> 31 --> regOperand1 contient le MSB de x-y *)
							writeToFile 5 regOperand1 regOperand1 regIndALU file;

							(* x AND y =  (x NAND y) NAND (x NAND y) *)
							(* MSB(y-x) NAND 1 *)
							writeToFile 6 regOperand1 regOperand1 1 file;
							
							(* MSB(y-x) AND 1 *)
							writeToFile 6 regOperand1 regOperand1 regOperand1 file;

							writeToFileSpecial 13 reg _FALSE file; 
							(*Si x-y !=0  true SINON reste false*)
							writeToFile 0 reg regIndHeap regOperand2  file;
							
							writeToFile 0 regPrint regIndHeap regOperand1 file;							
							setResult 2;
							pop()
						)
		| Sup (x, y) -> (
								(* x>y <==> 0>y-x *)
							getOperands eval x y;

							(*Load -x dans regOperand1 *)
							(* x NAND x = NOT x *)
							writeToFile 6 regOperand1 regOperand1 regOperand1 file;
							(* (NOT x) + 1 = -x *)
							writeToFile 3 regOperand1 regOperand1 regIndHeap file;
							(*-x + y *)
							writeToFile 3 regOperand1 regOperand1 regOperand2 file;

							(*capture*)
							writeToFile 3 regOperand2 regOperand1 0 file;
							(*2^15*)
							writeToFileSpecial 13 reg 32768 file;
							
							(*on decale de 15*)
							writeToFile 5 regOperand1 regOperand1 reg file;
							(*on decale de 15 -> 30*)		
							writeToFile 5 regOperand1 regOperand1 reg file;
							(*On decale de 1 -> 31 --> regOperand1 contient le MSB de y-x *)
							writeToFile 5 regOperand1 regOperand1 regIndALU file;
							
							(* x AND y =  (x NAND y) NAND (x NAND y) *)
							(* MSB(y-x) NAND 1 *)
							writeToFile 6 regOperand1 regOperand1 1 file;
							
							(* MSB(y-x) AND 1 *)
							writeToFile 6 regOperand1 regOperand1 regOperand1 file;
							
							writeToFileSpecial 13 reg _FALSE file;

							(*Si y-x !=0  true SINON reste false*)
							writeToFile 0 reg regIndHeap regOperand2  file;

							(*Si MSB(y-x)!=0 true SINON reste false*)
							writeToFile 0 regPrint regIndHeap regOperand1 file;
							(*Printf.printf "SUP %d\n" (!aluInd-2);
							*)
							setResult 2;
							pop()
		)
		
let rec eval_stmt st = 
	match st with
	| Print (x) -> (
					match x with				(*On construit la liste des
													char ascii puis pour chaque char ascii on l'ecrit dans un regitre puis on l'affiche*)
						String s -> ( let _ = List.map (fun ascii -> (writeToFileSpecial  13 regPrint ascii file;
							 								 writeToFile 10 0 0 regPrint file)
							 		 ) (List.map (fun a -> (Char.code a)) (explode s) ) in
							 ())
						| Var id -> (
										eval x regPrint;
										writeToFile 10 0 0 regPrint file;
									)
						| _ -> (
								eval x regPrint;
								pop();
								writeToFileSpecial  13 regIndCptALU (!aluInd) file;
								writeToFile 1 regPrint regIndALU regIndCptALU file;
	 							writeToFile 10 0 0 regPrint file;
	 							)	
	 				)
	| Binding (name, expr, numV) -> (let _ =
										eval expr regPrint;
										pop();
										writeToFileSpecial  13 regIndCptALU (!aluInd) file;
										writeToFile 1 regPrint regIndALU regIndCptALU file;
										writeToFile 2 regIndHeap numV regPrint file in ()
									)
	| Sequence (st1, st2) -> (
								eval_stmt st1;
								eval_stmt st2
								)
	| Scan id -> (
					writeToFile 11 0 0 regPrint file;
					writeToFile 2 regIndHeap id regPrint file
				)