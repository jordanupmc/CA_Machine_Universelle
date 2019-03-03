package machineUniverselle.command;

import machineUniverselle.ProgramWriter;
import machineUniverselle.command.interfaces.Command;

public class WritePlateau implements Command {

	private int code;
	private int ra;
	private int rb;
	private int rc;
	private String file;
	private boolean append;

	public WritePlateau(int code, int ra, int rb, int rc, String file, boolean a) {
		super();
		this.code = code;
		this.ra = ra;
		this.rb = rb;
		this.rc = rc;
		this.file = file;
		append =a;
	}



	@Override
	public void execute() {
		UniverselleFileUtils.writeToFile(code, ra, rb, rc, file, append);
	}

}
