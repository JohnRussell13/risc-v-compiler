//#define MAX 5
//const int MAX = 5; IS NO GOOD SINCE WE NEED int x = 1; MAYBE EXPAND LATER

int main () {
   int var[5];
   int i;
   int *ptr;
   int MAX;
   MAX = 5;

   for(i = 0; i < MAX; i++){
      var[i] = 10 * i;
   }

   ptr = &var[0];

   for(i = 0; i < MAX; i++){
      *ptr++;
   }

   ptr = &var[MAX - 1];
   for(i = MAX; i > 0; i--){
      *ptr--;
   }
}
