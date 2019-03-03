package machineUniverselle.command;

import machineUniverselle.command.interfaces.Command;

public class WritePlateauSpecial implements Command{
	
	private int val;
	private int code;
	private int ra;
	private String file;
	private boolean append;
	
	public WritePlateauSpecial(int code, int ra, int val, String file, boolean a) {
		this.code = code;
		this.ra = ra;
		this.val=val;
		this.file = file;
		append =a;
	}

	@Override
	public void execute() {
		// TODO Auto-generated method stub
		UniverselleFileUtils.writeToFile(code, ra, val, file, append);

	}

}
