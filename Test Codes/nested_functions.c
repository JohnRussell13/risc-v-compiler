int sub(int a, int b){
    int x;
    x = a - b;
	return x;
}

int add(int a, int b){
    int x;
    x = (a+b)+sub(a,b);
	return x;
}

int main(){
    int x;

    x = 3;

    x = 3+sub(13,x);
    x = add(13,3);

    //return 0;
}
