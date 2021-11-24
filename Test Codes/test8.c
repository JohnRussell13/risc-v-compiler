#define MAX 5
//const int MAX = 5; IS NO GOOD SINCE WE NEED int x = 1; MAYBE EXPAND LATER

int main () {
   int var[5];
   int i;
   int *ptr;

   for(i = 0; i < MAX; i++){
      var[i] = 10 * i;
   }

   ptr = var;

   for(i = 0; i < MAX; i++){
      ptr++;
   }

   ptr = &var[MAX - 1];
   for(i = MAX; i > 0; i--){
      ptr--;
   }
   
   ptr = NULL;
}
