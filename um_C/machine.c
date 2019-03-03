#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <stdlib.h>    
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <arpa/inet.h>

#define MAX_REGISTRES 8
#define MAX_SIZE_PRGM 725456

typedef struct node {
  unsigned int val;
  struct node * next;
} node_t;

typedef struct element{
  node_t * array;
} list;

typedef struct dataIO{
  unsigned int * res;
  int size;
} dataIO;

node_t * makeNode(unsigned int val){
  node_t * tmp = malloc( sizeof(node_t));
  tmp -> val = val;
  tmp -> next = NULL;
  return tmp;
}

void push(node_t * head, int val) {
  node_t * current = head;
  if( !head ){
    printf("PUSH NULL\n");
    return ;
  }
  
  while (current->next != NULL) {
    current = current->next;
  }

  current->next = makeNode(val);
}

list collection[MAX_SIZE_PRGM]; 
unsigned int registres[MAX_REGISTRES];
unsigned int PC;
int collectionSize;



/*              E/S              */
/*
  int is_little_endian()
  {
  uint32_t magic = 0x00000001;
  uint8_t black_magic = *(uint8_t *)&magic;
  return black_magic;
  }

  uint32_t to_little_endian(uint32_t dword)
  {
  if (is_little_endian()) return dword;

  return (((dword >>  0) & 0xff) << 24)
  | (((dword >>  8) & 0xff) << 16)
  | (((dword >> 16) & 0xff) <<  8)
  | (((dword >> 24) & 0xff) <<  0);
  }
*/
dataIO * readProgram(char * filename ){
  int fd = open( filename,  O_RDONLY ,S_IRUSR  );
  if(fd == -1)
    perror("open fail ! ");

  int r;
  unsigned int buf[MAX_SIZE_PRGM];
  int i=0;
  int tmp;
  while( (r=read (fd, buf+i, sizeof(unsigned int))) ){
    if(r < 0 ){
      perror("Read fail !");  
      exit(1);
    }
    /*Convertit les bytes en big endian*/
    buf[i] = htonl( buf [i] );
    i++;
  }
  dataIO * res =  (dataIO *) malloc(sizeof(dataIO) );

  unsigned int * tab =(unsigned int *) malloc(sizeof( unsigned int) * i);
  int j;
  for(j=0; j < i; j++)
    tab[j] = buf[j];

  res -> res = tab;
  res -> size = i;
  return res;
} 
/*******************************/


unsigned int input(){
  unsigned int x;
  printf("Entrez un entier : ");
  scanf("%d", &x);
  return x;
}

void freeDataIO(dataIO * data){
  free(data->res);
  free(data);
}


void init(unsigned int * tall, int size){
  PC =0;
  int i = 0;
  for(i=0; i<MAX_REGISTRES; i++)
    registres[i] =0;

  collectionSize++;

  collection[0].array = makeNode( tall[0] ) ;
  for(i=1; i< MAX_SIZE_PRGM; i++)
    collection[i].array=NULL;

  for(i=1; i< size ; i++){
    push(collection[0].array , tall[i]);
  }
  
}
int sizeList( node_t * l){
  int cpt;
  if( ! l )
    return 0;
  return sizeList( l -> next ) + 1;
}

int getElem(node_t * l , int id){
  // int size = sizeList(l);
  if(!l)
    return -1;
  int i=0;
  node_t* tmp = l;
  while( tmp  ){
    if(i == id)
      break;
    tmp = tmp->next;
    i++;
  }
  return tmp->val;
}

void setElem(node_t * l, int pos, unsigned int val){
  if( ! l )
    return ;
  
  int i=0;
  
  node_t* tmp = l;
  node_t *prec;
  while( tmp ){
    if(i == pos)
      break;
    prec =tmp;
    tmp = tmp->next;
    i++;
  }
  /*Agrandir*/
  if( ! tmp ){
    //    printf("SET NULL :( \n\n"); 
    push(prec, 0);
    setElem(l, pos, val);
  }
  else
    tmp -> val = val;

}

void freeList ( node_t * n ){
  node_t * tmp = n;
  node_t * t;
  
  if( !n )
    return;

  while( tmp ){
    t = tmp->next;
   
    free(tmp);
    tmp = t;
  }
  free(tmp);

}

void freeMachine(){
  int i=0;

  /*TODO collectionSize ?*/
  for(i=0; i< MAX_SIZE_PRGM; i++)
    freeList( collection[i].array );

}

void afficheListe ( node_t * n ){
  if( !n )
    return;
  printf("%d\n", n->val);
  afficheListe(n->next);

}

void printMachine(){
  int i;
  /*TODO collectionSize ?*/
  for(i=0; i< collectionSize ; i++)
    afficheListe( collection[i].array); 
}
/*TODO !!!!!!*/
int firstFreeIndice(){
  int i; 
  // printf("FREEIND ?\n");
  for(i =0; i<MAX_SIZE_PRGM ; i++){
    //    printf("I = %d\n", i);
    if( ! collection[i].array )
      return i;
  }
  printf("FREEIND BUG\n");
  return -1;
}

node_t* copyList(node_t * toCopy){
  if( !toCopy)
    return toCopy;

  node_t * tmp = toCopy;
  node_t * res = makeNode ( tmp->val );
  // printf("COPY ... \n\n");
  while( tmp->next ){
    tmp = tmp -> next;
    if( !tmp )
      printf(", NULL ! copy\n");
    push ( res, tmp->val );
   
  }
  //printf("COPY :) \n\n");

  return res;

}


int getA(unsigned int plat){
  return ((unsigned int)(plat >> 6) & 7);
}

int getSpecialA(unsigned int plat){
  return ((unsigned int)(plat >> 25) & 7);
}
int getSpecialValue(unsigned int plat){
  return (unsigned int)(plat & 33554431  ) ; //33554431
}

int getB(unsigned int plat){
  return (((unsigned int) (plat >> 3)) & 7);
}
int getC(unsigned int plat){
  return plat & 7;
}


void startMachine(){
  unsigned int code;
  unsigned int regC;
  unsigned int regA;
  unsigned int regB;
  unsigned int plateau;
  unsigned char toPrint;
  
  
    printf("ui =%d int=%d long=%d\n", sizeof(unsigned int), sizeof(int), sizeof(long));
    /*  PLAT =-1342177144
    PLAT =-1610612600
  */

  // while(PC < sizeList(collection[0].array)){
  while(1){
    plateau = getElem (collection[0].array , PC);
    code = ((unsigned int)plateau >> 28);
   
    regA = getA(plateau);
    regB = getB(plateau);
    regC = getC(plateau);
    
    //  printf("%d\n", code);
    /*printf("tmp %d\n",  (unsigned int)plateau>>28);*/

    switch ( code ){
    case 0:
      //MOV
      if(registres[regC])
	registres[regA]=registres[regB];
      break;
    case 1:
      //Indice de tableau
      PC;
      int res =  getElem(collection[ registres[regB] ].array , registres[regC]);

      if(res == -1)
	printf("Pas trouve !!\n");
      else
	registres[regA] = (unsigned int ) res;

 

      // printf("INDEX [%d][%d] SIZE = %d\n",registres[regB], res,sizeList(collection[registres[regB]].array) );
      break;
      
    case 2:
      //Modif de tableau
      // printf("MODIF %d\n", registres[regC]);
      setElem(collection[ registres[regA] ].array, registres[regB], registres[regC]);
      
      /*printf("AT [%d][%d] : %d,  %d\n", registres[regA], registres[regB],registres[regC] ,
	     getElem(collection[ registres[regA] ].array , registres[regB]));
      */     
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
      if(registres[regC] == 0){
	printf("Div /0\nMachine en panne !\n");
	exit(1);
      }
      registres[regA]= (unsigned int )(registres[regB]/registres[regC]);
      break;

    case 6:
      //NAND   NOT(B) + NOT(C)
      registres[regA] = ~(registres[regB] & registres[regC]);
      break;
      
    case 7:
      printf("EXIT machine\n");
      exit(1);
      break;
    
      
    case 8:
      //NEW ARRAY
      //  printf("NEW ARRAY\n\n");
      PC;
      int capacity = registres[regC];
      int i;
     
      int ind = firstFreeIndice();
      // printf("ind=%d\n", ind);
      
      if(ind <= 0){
	printf("Plus de place ! \n");
	break;
      }
      //  printf("NEW ARR %d", ind);
      if(capacity > 0)
	collection[ind].array = makeNode(0);
      for( i=1; i<capacity; i++)
	push( collection[ind].array, 0 );
       
      registres[regB]= ind;
      collectionSize++;
      break;
      
    case 9:
      //FREE ARRAY
      freeList ( collection[registres[regC] ].array ) ;
      collection[registres[regC] ].array = NULL;
      collectionSize--;
      break;  

      
    case 10:
      //OUTPUT
      toPrint = registres[regC];

      if( toPrint > 255 || toPrint < 0  ){
	printf("value autoriser [0; 255]\nMachine en panne !");
	exit(1);
      }
      
      printf("%c", toPrint);
      break;
    case 11:
      //INPUT
      registres[regC] = input();
      break;
      
    case 12:
      //LOAD PRGM
      // duplication
      PC;

      if(registres[regB]){
	node_t * cp = copyList (collection[registres[regB] ].array );

	if( ! cp )
	  printf("MINCE\n");
      
	//remplacement du tableau 0
	freeList(collection[0].array);
	collection[0].array = cp;
      
	//MODIFICATION DU PC
      }
      PC = registres[regC];
      
      // PC -1 car on fait PC++ apres
      PC--;
      
      break;

    case 13:
      //Orthographe ?   
      registres[ getSpecialA(plateau) ] = getSpecialValue(plateau);
      break;


    default:
      break;
    }
  
    PC++;
  }


}



int main(int argc, char ** argv){
  
  if( argc != 2){
    printf("Usage %s filename\n", argv[0]);
    return 1;
  }
  dataIO * data = readProgram( argv[1]);
 
  init(data->res, data->size);
  freeDataIO(data);

  startMachine();
  //printMachine();
  freeMachine();
  
  
  return 0;
}
