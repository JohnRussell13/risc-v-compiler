void ptr(int *a){
    *a = 4;
}

int main(){
    int a;
    int x;

    x = 5;
    ptr(&x);

    //return 0;
}
