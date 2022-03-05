int fact(int x){
    int a;
    a = 1;
    if(x > 1){
        a = fact(x-1);
    }
    a = a * x;
    return a;
}

int main(){
    int x;

    x = fact(5);

    //return 0;
}
