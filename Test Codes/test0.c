//TEST ALU OPS

//#define y 3
int add(void a,int b){
	return a+b;
}

int main(){
    int x;
    int y;
    int z0;
    int w;
    int q;
    int t;


    x = 2;
    y = 3;
    add(x,y);
    z0 = x + y;
    w = x - z0;
    q = x << y;
    t = z0 >> 1;

    x = 5;

    //return 0;
}
