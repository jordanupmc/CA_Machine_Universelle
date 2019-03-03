package machineUniverselle;

import java.io.DataOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;

import machineUniverselle.command.Program;
import machineUniverselle.command.UniverselleFileUtils;
import machineUniverselle.command.WritePlateau;
import machineUniverselle.command.WritePlateauSpecial;

public class ProgramWriter {
	
	public static void main(String [] args) throws FileNotFoundException{

		
		/*INPUT OUTPUT*/
//		Program prog =new Program();
		// -1342177144  -1610612600
//		prog.storeAndExecute(new WritePlateau(11,2,1,0, "prog1", false));
//		prog.storeAndExecute(new WritePlateau(10,2,1,0, "prog1", true));
	
		/*ARITHMETIQUE*/
		//Program prog2 =new Program();
		
//		prog2.storeAndExecute(new WritePlateau(11,2,1,0, "prog1", false));
//		prog2.storeAndExecute(new WritePlateau(11,0,0,1, "prog1", true));
//
//		prog2.storeAndExecute(new WritePlateau(4,2,1,0, "prog1", true));
//		prog2.storeAndExecute(new WritePlateau(10,0,0,2,"prog1", true));

		
		/*ARRAY*/
		/*Modification d'un array*/
		/*Puis lecture d'une valeur dans le tab*/
		
//		Program prog3 =new Program();
//		prog3.storeAndExecute(new WritePlateau(11, 0,0,0, "prog1", false));
//		
//		prog3.storeAndExecute(new WritePlateau(8,  2,1,0, "prog1", true));
//		
//		prog3.storeAndExecute(new WritePlateau(2,  1,2,0,"prog1", true));
//		
//		prog3.storeAndExecute(new WritePlateau(1,  3,1,2,"prog1", true));
//		
//		
//		prog3.storeAndExecute(new WritePlateau(10, 0,0,3,"prog1", true));
//		
//		prog3.storeAndExecute(new WritePlateau(9,  0,0,1,"prog1", true));

		/*LOAD PRGM*/
		
		Program prog4 =new Program();
		
		// 1
		//prog4.storeAndExecute(new WritePlateau(11, 0,0,1, "prog1", false));
		prog4.storeAndExecute(new WritePlateauSpecial(13, 1,1, "prog1", false));
		//-1610612599
		prog4.storeAndExecute(new WritePlateau(11, 0,0,0, "prog1", true));
		
		prog4.storeAndExecute(new WritePlateau(8,  2,1,1, "prog1", true));
		
		prog4.storeAndExecute(new WritePlateau(2,  1,2,0,"prog1", true));
		
		prog4.storeAndExecute(new WritePlateau(12, 0,1,4,"prog1", true));
		
		
		
		
		
//		UniverselleFileUtils.clearContentFile("prog1.o");
//		UniverselleFileUtils.compile("prog1.u");
		
	}
	
	
}








