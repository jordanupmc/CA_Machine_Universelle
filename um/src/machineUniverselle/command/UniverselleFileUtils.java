package machineUniverselle.command;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.Scanner;

public class UniverselleFileUtils {
	
	public static void compile(String filename) throws FileNotFoundException{
		Scanner s = new Scanner(new BufferedReader(new FileReader(filename)));
		int code=0, ra=0,rb=0,rc=0;
		int i=0;
		
		while(s.hasNext()){
			if(s.hasNextInt() && i < 4){
				if(i==0)
					code = s.nextInt();
				else if(i == 1)
					ra = s.nextInt();
				else if(i == 2)
					rb=s.nextInt();
				else if(i == 3)
					rc =s.nextInt();
				
				i++;
				
			}
			else{
				s.next();
				i=0;
				
				writeToFile(code, ra,rb,rc,(filename.substring(0, filename.length()-2))+".o",true);
			}
		}
		
	}
	
	public static void writeToFile(int code, int ra, int val, String filename, boolean append){
		
		DataOutputStream os;
		
		try {
			
			os = new DataOutputStream(new FileOutputStream(filename,append));
			int v;
			
			
			v = 0 | (code << 28);
			
			v = v | (val & 33554431);
			v= v | (ra << 25);
			
			
			System.out.println("v = "+v);
			BigInteger bigInt = BigInteger.valueOf(v);  
			byte arr[] = bigInt.toByteArray();
			
		
			os.writeInt(v);
			
			os.close();
		
			System.out.println("DONE !");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void writeToFile(int code, int ra, int rb, int rc, String filename, boolean append){
		
		DataOutputStream os;
		
		try {
			
			os = new DataOutputStream(new FileOutputStream(filename,append));
			int v;
			
			
			v = 0 | (code << 28);
			
			v= v | rc;
			v= v | (rb << 3);
			v= v | (ra << 6);
			
			
			System.out.println("v = "+v);
			BigInteger bigInt = BigInteger.valueOf(v);  
			byte arr[] = bigInt.toByteArray();
			
		
			os.writeInt(v);
			
			os.close();
		
			System.out.println("DONE !");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void clearContentFile(String filename){
		PrintWriter writer;
		try {
			writer = new PrintWriter(filename);
			writer.print("");
			writer.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
