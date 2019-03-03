package machineUniverselle.command;

import machineUniverselle.ProgramWriter;
import machineUniverselle.command.interfaces.Command;

public class ClearFile implements Command {

	private String file;
	
	public ClearFile(String file){
		this.file=file;
	}
	
	
	@Override
	public void execute() {
		UniverselleFileUtils.clearContentFile(file);
	}

}
