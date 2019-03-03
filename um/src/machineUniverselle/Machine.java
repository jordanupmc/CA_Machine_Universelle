package machineUniverselle;

import java.io.IOException;
import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.List;
import java.util.Scanner;

public class Machine {

	private List<List<Integer>> collection;
	private int[] registres;
	int PC;
	StringBuilder sb;
	
	public Machine(int[] tall, int size){

		registres = new int[8];
		collection = new ArrayList<>();
		PC=0;

		for(int i=0; i< registres.length; i++)
			registres[i] = 0;

		collection.add( new ArrayList<>());

		for(int i=0; i< size; i++)
			collection.get(0).add(tall[i]);

		sb = new StringBuilder();
	}

	public String getConsole(){
		return sb.toString();
	}
	
	public int getA(int plat){
		return plat >>> 6 & 7;
	}

	public int getSpecialA(int plat){
		return (plat >>> 25) & 7;
	}

	public int getSpecialValue(int plat){
		return plat & 0x1FFFFFF ; //33554431
	}

	public int getB(int plat){
		return plat >>> 3 & 7;
	}
	public int getC(int plat){
		return plat & 7;
	}


	public int input() throws UniverselleException{
		System.out.print("@>:");
	
		//(\b.bb)(\v.vv)06FHPVboundvarHRAk
		byte b;
		try {
			b = (byte) System.in.read();
			if(b == -1)
				return ~(0x0);
			return b;
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new UniverselleException(e.getMessage()+"\nMachine en panne !");
		}
	}

	public void start() throws UniverselleException{
		int cpt =0;
		while( PC < collection.get(0).size() ){
			int plateau = collection.get(0).get(PC);
			int code =plateau >>> 28;
			int regC = getC(plateau);
			int regA = getA(plateau);
			int regB = getB(plateau);
			//System.out.println(code+" regA = "+registres[regA]+" regB= "+registres[regB]+" regC="+registres[regC]);
			
			switch ( code ) {
			case 0:
				//MOV
				if(registres[regC] != 0)
					registres[regA]=registres[regB];
				break;

			case 1:
				//Indice de tableau
			
				registres[regA] = collection.get( registres[regB] ).get( registres[regC] );
				break;

			case 2:
				//Modif de tableau
				collection.get(registres[regA]).set(registres[regB], registres[regC]);
				break;

			case 3:
				//ADD
				registres[regA]= (registres[regB] + registres[regC]);
				break;

			case 4:
				//MULT
				registres[regA]= (registres[regB] * registres[regC]);
				break;

			case 5:
				//DIV
				if(registres[regC] == 0)
					throw  new UniverselleException("Div /0\nMachine en panne !");

				registres[regA]=Integer.divideUnsigned(registres[regB] ,registres[regC]);
				break;

			case 6:
				//NAND   NOT(B) + NOT(C)
				registres[regA] = ~(registres[regB] & registres[regC]);
				break;
			case 7:
				//EXIT
				System.out.println("EXIT");
				return;

			case 8:
				//NEW ARRAY
				int capacity = registres[regC];
				collection.add(new ArrayList<>(capacity));
				List<Integer> l = collection.get(collection.size()-1);

				for(int i=0; i< capacity; i++)
					l.add(0);

				registres[regB]= collection.size()-1;

				break;

			case 9:
				//FREE ARRAY ???
				collection.set(registres[regC], null);

				break;
			case 10:
				//OUTPUT
				int toPrint = registres[regC];

				if( toPrint > 255 || toPrint < 0  )
					throw new UniverselleException("value is "+toPrint+" value autoriser [0; 255]\nMachine en panne !");

				System.out.print((char)(toPrint));
				sb.append((char)toPrint);

				break;
			case 11:
				//INPUT
				registres[regC] = input();

				break;

			case 12:
				//LOAD PRGM
				// duplication
				if(registres[regB] > 0){	
					List<Integer> cp = new ArrayList<>(collection.get( registres[regB] ));
					//cp.add(0);
					//remplacement du tableau 0
					//System.out.println("LOAD =================="+cp.size());
					collection.set(0, cp);
				}
				//MODIFICATION DU PC
				PC = registres[regC];

				// PC -1 car on fait PC++ apr�s
				//PC = PC < 0 ? -1*PC : PC -1;
				PC--;
				break;

			case 13:
				registres[ getSpecialA(plateau) ] = getSpecialValue(plateau);
				break;


			default :
				System.out.println("CODE NON DEF ???");

				return;
			}
			PC++;
		}
	}

}
