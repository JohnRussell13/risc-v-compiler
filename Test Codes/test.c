//SOURCE https://www.tutorialspoint.com/data_structures_algorithms/merge_sort_program_in_c.htm

//#define max 10

void merging(int *a, int *b, int low, int mid, int high) {
   int l1;
   int l2;
   int i;

   l1 = low;
   l2 = mid + 1;

   for(i = low; l1 <= mid && l2 <= high; i++) {
      if(a[l1] <= a[l2]){
         b[i] = a[l1];
         l1++;
      }
      else{
         b[i] = a[l2];
         l2++;
      }
   }
   
   while(l1 <= mid){
      b[i] = a[l1];
      i++;
      l1++;
   }

   while(l2 <= high){
      b[i] = a[l2];
      i++;
      l2++;
   }

   for(i = low; i <= high; i++)
      a[i] = b[i];
}

void sort(int *a, int *b, int low, int high) {
   int mid;
   
   if(low < high) {
      mid = (low + high) / 2;
      sort(a, b, low, mid);
      sort(a, b, mid + 1, high);
      merging(a, b, low, mid, high);
   }
}

int main() { 
    int i;
    int a[3];
    int b[3];
   int max;
   max = 2;
   
    for(i = 0; i < 3; i++){
        a[i] = 10-i;
    }
    sort(a, b, 0, max);
}