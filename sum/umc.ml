let file = Sys.argv.(1);;

let _ =
	let ic = open_in file in
	  try 
	    let lexbuf = Lexing.from_channel ic in
  		let ast = Parser.main Lexer.token lexbuf in

  		let _ = Eval.eval_stmt ast in
	    close_in ic                  (* close the input channel *) 
	  
	  with e ->                      (* some unexpected exception occurs *)
	    close_in_noerr ic;           (* emergency closing *)
	    raise e 