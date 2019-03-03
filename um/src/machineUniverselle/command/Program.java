package machineUniverselle.command;

import java.util.ArrayList;
import java.util.List;

import machineUniverselle.command.interfaces.Command;

public class Program {

	List<Command> instructions;

	public Program() {
		this.instructions = new ArrayList<>();	
	}
	
	public Program(List<Command> instructions) {
		super();
		this.instructions = new ArrayList<>( instructions );
	}
	
	public void storeAndExecute(Command instr){
		instructions.add(instr);
		instr.execute();
	}
	
	public void store(Command instr){
		instructions.add(instr);
	}
	
	public void executeAll(){
		for(Command c : instructions)
			c.execute();
	}
	
}
