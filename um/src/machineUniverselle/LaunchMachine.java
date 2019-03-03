package machineUniverselle;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import java.util.ArrayList;
import java.util.List;

public class LaunchMachine {
	
	
	public static String launch(String args) throws UniverselleException{
		try { 
			/*LECTURE DU FICHIER CONTENANT LE CODE*/
			/*DataInputStream input = new DataInputStream (
					new BufferedInputStream(new FileInputStream("sandmark.umz")));
*/
			
			DataInputStream input = new DataInputStream (
					new BufferedInputStream(new FileInputStream(args)));
	
			List<Integer> l =new ArrayList<>();
			
			while( input.available() > 0)
				l.add(input.readInt());
			
			
			int [] tall =new int[ l.size()];
			
			
			for(int i=0; i< l.size(); i++)
				tall[i]=l.get(i);
			
			
			/*DEMARRAGE DE LA MACHINE*/
			Machine univ = new Machine(tall,l.size());
			
			univ.start();
			input.close();
			return univ.getConsole();
			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return e.getMessage();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return e.getMessage();
		}
	}
	public static void main(String [] args) throws UniverselleException{
		
		launch( args[0] );
		
	}
}
