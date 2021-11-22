const int MAX = 5;

int main () {
   int var[] = {10, 20, 30,40,50};
   int i;
   int *ptr;

   ptr = var;

   for(i=0;i<MAX;i++){
      ptr++;
   }

   ptr = &var[MAX-1];
   for(i=MAX;i>0;i--){
      ptr--;
   }
}
