package machineUniverselle.test;

import static org.junit.Assert.*;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.junit.Test;

import machineUniverselle.LaunchMachine;
import machineUniverselle.UniverselleException;

public class Testeur {
	private final String folder="tests";
	private final String foldComp="sum";

	private final String compName="umc";
	private final String folderBin ="binOutput";
	
	private static String OS = System.getProperty("os.name").toLowerCase();
	
	
	 
	public File[] listFiles(String folder){

		File dir = new File(folder);
		System.out.println( dir.getAbsolutePath() );
		return  dir.listFiles(new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				return name.endsWith(".sum");
			}
		});
	}
	private String removeExtension(String f, int i){
		return f.substring(0, f.length() - i);
	}

	@Test
	public void test() throws UniverselleException, FileNotFoundException, IOException, InterruptedException{
		File [] files = listFiles(folder);
		String console;
		String cmd;
		
		Process p;
		InputStream old = System.in;
		for(File f : files ){
			System.out.println("\n==============================================");
			if(OS.indexOf("win") >= 0)
				cmd="ocamlrun.exe "+foldComp+"/"+compName+" "+ f.getAbsolutePath()+" "+folderBin+"/"+ removeExtension(f.getName(),4)+"out.um";
			else
				cmd="./"+foldComp+"/"+compName+" "+ f.getAbsolutePath()+" "+folderBin+"/"+ removeExtension(f.getName(),4)+"out.um";
		
			System.out.println(f.getAbsolutePath()+" COMPILE....");
			System.out.println(cmd);
			p = Runtime.getRuntime().exec(cmd);

			if(p.waitFor() >0){
				BufferedReader in = new BufferedReader(new InputStreamReader(p.getErrorStream()));
				throw new UniverselleException("compile Fail !\n"+in.readLine());
			}

			System.out.println("Compile done !\nExec...");
			
			/*Lecture fichiers INPUT*/
			try(BufferedReader input = new BufferedReader(new FileReader( removeExtension(f.getAbsolutePath(), 4) +".input"))){
				String linput = input.readLine();
				StringBuilder sb = new StringBuilder();
				while( linput != null){
					sb.append(linput);
					sb.append(System.lineSeparator());
					linput = input.readLine();
				}
				InputStream testInput = new ByteArrayInputStream( sb.toString().getBytes("UTF-8") );
				System.setIn( testInput );
			}
			console =LaunchMachine.launch(folderBin+"/"+removeExtension(f.getName(),4)+"out.um");
			System.setIn( old );
			
			
			/*Lecture fichier OUTPUT*/
			try(BufferedReader br = new BufferedReader(new FileReader( removeExtension(f.getAbsolutePath(), 4) +".output"))) {
				StringBuilder sb = new StringBuilder();
				String line = br.readLine();

				while (line != null) {
					sb.append(line);
					sb.append(System.lineSeparator());
					line = br.readLine();
				}
				//On trim pour enlever le saut de ligne
				assertEquals(sb.toString().trim(),console);
				
			}
		}
	}


}
