int main(){
    int *ptr_a;
    int *ptr_b;
    int a;
    int b;
    int sum_1;
    int sum_2;
    int sum_3;

    a = 54;
    b = 18;
    sum_1 = 0;
    sum_2 = 0;
    sum_3 = 0;
    ptr_a = &a;
    ptr_b = &b;
    sum_1 = *ptr_a + *ptr_b;
    a = 11;
    b = 43;
    sum_2 = *ptr_a + *ptr_b;
    *ptr_a = 28;
    *ptr_b = 37;
    sum_3 = *ptr_a + *ptr_b;
    
    ptr_a = NULL;
    ptr_b = NULL;
}
